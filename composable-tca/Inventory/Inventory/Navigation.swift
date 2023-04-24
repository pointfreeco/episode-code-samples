import ComposableArchitecture
import SwiftUI
import SwiftUINavigation

extension NavigationLink where Destination == Never {
  init<Element>(
    state element: Element,
    @ViewBuilder label: () -> Label
  ) {
    self.init(
      value: StackState<Element>.Component(
        id: UUID(),
        element: element
      ),
      label: label
    )
  }
}

extension Reducer {
  func forEach<ElementState, ElementAction, Element: Reducer>(
    _ toElementsState: WritableKeyPath<State, StackState<ElementState>>,
    action toStackAction: CasePath<Action, StackAction<ElementState, ElementAction>>,
    @ReducerBuilder<ElementState, ElementAction> element: () -> Element,
    file: StaticString = #file,
    fileID: StaticString = #fileID,
    line: UInt = #line
  ) -> some ReducerOf<Self>
  where ElementState == Element.State, ElementAction == Element.Action {
    let element = element()

    return Reduce { state, action in
      switch toStackAction.extract(from: action) {
      case let .element(id: id, action: childAction):
        if state[keyPath: toElementsState].elements[id: id] == nil {
          XCTFail("Action was sent for an element that does not exist")
          return self.reduce(into: &state, action: action)
        }

        return .merge(
          element
            .reduce(into: &state[keyPath: toElementsState].elements[id: id]!.element, action: childAction)
            .map { toStackAction.embed(.element(id: id, action: $0)) },
          self.reduce(into: &state, action: action)
        )

      case let .setPath(path):
        state[keyPath: toElementsState] = path
        return self.reduce(into: &state, action: action)

      case .none:
        return self.reduce(into: &state, action: action)
      }
    }
  }
}

struct StackState<Element> {
  fileprivate var elements: IdentifiedArrayOf<Component> = []

  fileprivate init(elements: IdentifiedArrayOf<Component> = []) {
    self.elements = elements
  }

  init() {
  }
  init<S: Sequence>(_ elements: S) where S.Element == Element {
    self.elements = IdentifiedArray(
      uncheckedUniqueElements: elements.map { Component(id: UUID(), element: $0) }
    )
  }

  fileprivate struct Component: Identifiable {
    let id: UUID
    var element: Element
  }

  mutating func append(_ element: Element) {
    self.elements.append(Component(id: UUID(), element: element))
  }
}
extension StackState: Collection {
  var startIndex: Int { self.elements.startIndex }
  var endIndex: Int { self.elements.endIndex }
  func index(after i: Int) -> Int { self.elements.index(after: i) }
  subscript(position: Int) -> Element { self.elements[position].element }
}
extension StackState: Equatable where Element: Equatable {
  static func == (lhs: Self, rhs: Self) -> Bool {
    guard lhs.elements.count == rhs.elements.count
    else { return false }
    return zip(lhs.elements, rhs.elements).allSatisfy {
      $0.id == $1.id && $0.element == $1.element
    }
  }
}

extension StackState.Component: Hashable {
  static func == (lhs: Self, rhs: Self) -> Bool {
    lhs.id == rhs.id
  }
  func hash(into hasher: inout Hasher) {
    hasher.combine(self.id)
  }
}

enum StackAction<State, Action> {
  case element(id: UUID, action: Action)
  case setPath(StackState<State>)
}

struct NavigationStackStore<
  Root: View,
  PathState,
  PathAction,
  Destination: View
>: View {
  let store: Store<StackState<PathState>, StackAction<PathState, PathAction>>
  let root: Root
  let destination: (PathState) -> Destination

  init(
    _ store: Store<StackState<PathState>, StackAction<PathState, PathAction>>,
    @ViewBuilder root: () -> Root,
    @ViewBuilder destination: @escaping (PathState) -> Destination
  ) {
    self.store = store
    self.root = root()
    self.destination = destination
  }

  var body: some View {
    WithViewStore(
      self.store,
      observe: { $0 },
      removeDuplicates: { $0.elements.ids == $1.elements.ids }
    ) { viewStore in
      NavigationStack(
        path: viewStore.binding(
          get: { _ in
            ViewStore(self.store, observe: { $0 }, removeDuplicates: { _, _ in true }).state.elements
          },
          send: { .setPath(StackState(elements: $0)) }
        )
      ) {
        self.root
          .navigationDestination(for: StackState<PathState>.Component.self) { component in
            SwitchStore(
              self.store.scope(
                state: { $0.elements[id: component.id]?.element ?? component.element },
                action: {
                  .element(id: component.id, action: $0)
                }
              )
            ) { state in
              self.destination(state)
            }
          }
      }
    }
  }
}

@propertyWrapper
struct PresentationState<State> {
  private var value: [State]
  fileprivate var isPresented = false

  init(wrappedValue: State?) {
    if let wrappedValue {
      self.value = [wrappedValue]
    } else {
      self.value = []
    }
  }

  var wrappedValue: State? {
    get {
      self.value.first
    }
    set {
      guard let newValue = newValue
      else {
        self.value = []
        return
      }
      self.value = [newValue]
    }
  }

  var projectedValue: Self {
    get { self }
    set { self = newValue }
  }
}
extension PresentationState: Equatable where State: Equatable {
  static func == (lhs: Self, rhs: Self) -> Bool {
    lhs.value == rhs.value
  }
}
extension PresentationState: Hashable where State: Hashable {
  func hash(into hasher: inout Hasher) {
    hasher.combine(self.value)
  }
}
extension PresentationState: CustomDumpReflectable {
  var customDumpMirror: Mirror {
    Mirror(reflecting: self.wrappedValue as Any)
  }
}

enum PresentationAction<Action> {
  case dismiss
  case presented(Action)
}
extension PresentationAction: Equatable where Action: Equatable {}

extension Reducer {
  func ifLet<ChildState: Identifiable, ChildAction>(
    _ stateKeyPath: WritableKeyPath<State, PresentationState<ChildState>>,
    action actionCasePath: CasePath<Action, PresentationAction<ChildAction>>
  ) -> some ReducerOf<Self>
  where ChildState: _EphemeralState
  {
    self.ifLet(stateKeyPath, action: actionCasePath) {
      EmptyReducer()
    }
  }

  func ifLet<ChildState: Identifiable, ChildAction>(
    _ stateKeyPath: WritableKeyPath<State, PresentationState<ChildState>>,
    action actionCasePath: CasePath<Action, PresentationAction<ChildAction>>,
    @ReducerBuilder<ChildState, ChildAction> child: () -> some Reducer<ChildState, ChildAction>
  ) -> some ReducerOf<Self> {
    let child = child()
    return Reduce { state, action in
      switch (state[keyPath: stateKeyPath].wrappedValue, actionCasePath.extract(from: action)) {

      case (_, .none):
        let childStateBefore = state[keyPath: stateKeyPath].wrappedValue
        let effects = self.reduce(into: &state, action: action)
        let childStateAfter = state[keyPath: stateKeyPath].wrappedValue
        let cancelEffect: Effect<Action>
        if
          let childStateBefore,
          !isEphemeral(childStateBefore),
          childStateBefore.id != childStateAfter?.id
        {
          cancelEffect = .cancel(id: childStateBefore.id)
        } else {
          cancelEffect = .none
        }
        let onFirstAppearEffect: Effect<Action>
        if
          let childStateAfter,
          !isEphemeral(childStateAfter),
          childStateAfter.id != childStateBefore?.id || !state[keyPath: stateKeyPath].isPresented
        {
          state[keyPath: stateKeyPath].isPresented = true
          onFirstAppearEffect = .run { send in
            do {
              try await withTaskCancellation(id:  DismissID(id: childStateAfter.id)) {
                try await Task.never()
              }
            } catch is CancellationError {
              await send(actionCasePath.embed(.dismiss))
            }
          }
          .cancellable(id: childStateAfter.id)
        } else {
          onFirstAppearEffect = .none
        }
        return .merge(
          effects,
          cancelEffect,
          onFirstAppearEffect
        )

      case (.none, .some(.presented)), (.none, .some(.dismiss)):
        XCTFail("A presentation action was sent while child state was nil.")
        return self.reduce(into: &state, action: action)

      case (.some(var childState), .some(.presented(let childAction))):
        defer {
          if isEphemeral(childState) {
            state[keyPath: stateKeyPath].wrappedValue = nil
          }
        }
        let childEffects = child
          .dependency(\.dismiss, DismissEffect { [id = childState.id] in
            Task.cancel(id:  DismissID(id: id))
          })
          .reduce(into: &childState, action: childAction)
        state[keyPath: stateKeyPath].wrappedValue = childState
        let effects = self.reduce(into: &state, action: action)

        let onFirstAppearEffect: Effect<Action>
        if
          let childStateAfter = state[keyPath: stateKeyPath].wrappedValue,
          !isEphemeral(childStateAfter),
          childStateAfter.id != childState.id || !state[keyPath: stateKeyPath].isPresented
        {
          state[keyPath: stateKeyPath].isPresented = true
          onFirstAppearEffect = .run { send in
            do {
              try await withTaskCancellation(id:  DismissID(id: childStateAfter.id)) {
                try await Task.never()
              }
            } catch is CancellationError {
              await send(actionCasePath.embed(.dismiss))
            }
          }
          .cancellable(id: childStateAfter.id)
        } else {
          onFirstAppearEffect = .none
        }

        return .merge(
          childEffects
            .map { actionCasePath.embed(.presented($0)) }
            .cancellable(id: childState.id),
          effects,
          onFirstAppearEffect
        )

      case let (.some(childState), .some(.dismiss)):
        let effects = self.reduce(into: &state, action: action)
        state[keyPath: stateKeyPath].wrappedValue = nil
        return .merge(
          effects,
          .cancel(id: childState.id)
        )
      }
    }
  }
}

@_spi(Reflection) import CasePaths
private func isEphemeral<State>(_ state: State) -> Bool {
  if State.self is _EphemeralState.Type {
    return true
  } else if let metadata = EnumMetadata(State.self) {
    return metadata.associatedValueType(forTag: metadata.tag(of: state)) is _EphemeralState.Type
  }
  return false
}

protocol _EphemeralState {}
extension AlertState: _EphemeralState {}
extension ConfirmationDialogState: _EphemeralState {}

private struct DismissID: Hashable { let id: AnyHashable }

struct DismissEffect: Sendable {
  private var dismiss: @Sendable () async -> Void
  func callAsFunction() async {
    await self.dismiss()
  }
}
extension DismissEffect {
  init(_ dismiss: @escaping @Sendable () async -> Void) {
    self.dismiss = dismiss
  }
}
extension DismissEffect: DependencyKey {
  static var liveValue = DismissEffect(dismiss: {})
  static var testValue = DismissEffect(dismiss: {})
}
extension DependencyValues {
  var dismiss: DismissEffect {
    get { self[DismissEffect.self] }
    set { self[DismissEffect.self] = newValue }
  }
}
// self.dismiss.dismiss()
// self.dismiss()

extension View {
  func sheet<DestinationState, DestinationAction, ChildState: Identifiable, ChildAction>(
    store: Store<DestinationState?, PresentationAction<DestinationAction>>,
    state toChildState: @escaping (DestinationState) -> ChildState?,
    action fromChildAction: @escaping (ChildAction) -> DestinationAction,
    @ViewBuilder child: @escaping (Store<ChildState, ChildAction>) -> some View
  ) -> some View {
    self.sheet(
      store: store.scope(
        state: { $0.flatMap(toChildState) },
        action: {
          switch $0 {
          case .dismiss:
            return .dismiss
          case let .presented(action):
            return .presented(fromChildAction(action))
          }
        }
      ),
      child: child
    )
  }

  func sheet<ChildState: Identifiable, ChildAction>(
    store: Store<ChildState?, PresentationAction<ChildAction>>,
    @ViewBuilder child: @escaping (Store<ChildState, ChildAction>) -> some View
  ) -> some View {
    WithViewStore(store, observe: { $0?.id }) { viewStore in
      self.sheet(
        item: Binding(
          get: { viewStore.state.map { Identified($0, id: \.self) } },
          set: { newState in
            if viewStore.state != nil {
              viewStore.send(.dismiss)
            }
          }
        )
      ) { _ in
        IfLetStore(
          store.scope(
            state: returningLastNonNilValue { $0 },
            action: PresentationAction.presented
          )
        ) { store in
          child(store)
        }
      }
    }
  }

  func popover<DestinationState, DestinationAction, ChildState: Identifiable, ChildAction>(
    store: Store<DestinationState?, PresentationAction<DestinationAction>>,
    state toChildState: @escaping (DestinationState) -> ChildState?,
    action fromChildAction: @escaping (ChildAction) -> DestinationAction,
    @ViewBuilder child: @escaping (Store<ChildState, ChildAction>) -> some View
  ) -> some View {
    self.popover(
      store: store.scope(
        state: { $0.flatMap(toChildState) },
        action: {
          switch $0 {
          case .dismiss:
            return .dismiss
          case let .presented(action):
            return .presented(fromChildAction(action))
          }
        }
      ),
      child: child
    )
  }

  func popover<ChildState: Identifiable, ChildAction>(
    store: Store<ChildState?, PresentationAction<ChildAction>>,
    @ViewBuilder child: @escaping (Store<ChildState, ChildAction>) -> some View
  ) -> some View {
    WithViewStore(store, observe: { $0?.id }) { viewStore in
      self.popover(
        item: Binding(
          get: { viewStore.state.map { Identified($0, id: \.self) } },
          set: { newState in
            if viewStore.state != nil {
              viewStore.send(.dismiss)
            }
          }
        )
      ) { _ in
        IfLetStore(
          store.scope(
            state: returningLastNonNilValue { $0 },
            action: PresentationAction.presented
          )
        ) { store in
          child(store)
        }
      }
    }
  }

  func fullScreenCover<ChildState: Identifiable, ChildAction>(
    store: Store<ChildState?, PresentationAction<ChildAction>>,
    @ViewBuilder child: @escaping (Store<ChildState, ChildAction>) -> some View
  ) -> some View {
    WithViewStore(store, observe: { $0?.id }) { viewStore in
      self.fullScreenCover(
        item: Binding(
          get: { viewStore.state.map { Identified($0, id: \.self) } },
          set: { newState in
            if viewStore.state != nil {
              viewStore.send(.dismiss)
            }
          }
        )
      ) { _ in
        IfLetStore(
          store.scope(
            state: returningLastNonNilValue { $0 },
            action: PresentationAction.presented
          )
        ) { store in
          child(store)
        }
      }
    }
  }
}

func returningLastNonNilValue<A, B>(
  _ f: @escaping (A) -> B?
) -> (A) -> B? {
  var lastValue: B?
  return { a in
    lastValue = f(a) ?? lastValue
    return lastValue
  }
}

extension View {
  func alert<DestinationState, DestinationAction, Action>(
    store: Store<DestinationState?, PresentationAction<DestinationAction>>,
    state toAlertState: @escaping (DestinationState) -> AlertState<Action>?,
    action fromAlertAction: @escaping (Action) -> DestinationAction
  ) -> some View {
    self.alert(
      store: store.scope(
        state: { $0.flatMap(toAlertState) },
        action: {
          switch $0 {
          case .dismiss:
            return .dismiss
          case let .presented(action):
            return .presented(fromAlertAction(action))
          }
        }
      )
    )
  }

  func alert<Action>(
    store: Store<AlertState<Action>?, PresentationAction<Action>>
  ) -> some View {
    WithViewStore(
      store,
      observe: { $0 },
      removeDuplicates: { ($0 != nil) == ($1 != nil) }
    ) { viewStore in
      self.alert(
        unwrapping: Binding(
          get: { viewStore.state },
          set: { newState in
            if viewStore.state != nil {
              viewStore.send(.dismiss)
            }
          }
        )
      ) { action in
        if let action {
          viewStore.send(.presented(action))
        }
      }
    }
  }
}

extension View {
  func confirmationDialog<DestinationState, DestinationAction, Action>(
    store: Store<DestinationState?, PresentationAction<DestinationAction>>,
    state toAlertState: @escaping (DestinationState) -> ConfirmationDialogState<Action>?,
    action fromAlertAction: @escaping (Action) -> DestinationAction
  ) -> some View {
    self.confirmationDialog(
      store: store.scope(
        state: { $0.flatMap(toAlertState) },
        action: {
          switch $0 {
          case .dismiss:
            return .dismiss
          case let .presented(action):
            return .presented(fromAlertAction(action))
          }
        }
      )
    )
  }

  func confirmationDialog<Action>(
    store: Store<ConfirmationDialogState<Action>?, PresentationAction<Action>>
  ) -> some View {
    WithViewStore(
      store,
      observe: { $0 },
      removeDuplicates: { ($0 != nil) == ($1 != nil) }
    ) { viewStore in
      self.confirmationDialog(
        unwrapping: Binding( 
          get: { viewStore.state },
          set: { newState in
            if viewStore.state != nil {
              viewStore.send(.dismiss)
            }
          }
        )
      ) { action in
        if let action {
          viewStore.send(.presented(action))
        }
      }
    }
  }
}

@available(*, deprecated)
struct NavigationLinkStore<ChildState: Identifiable, ChildAction, Destination: View, Label: View>: View {
  let store: Store<ChildState?, PresentationAction<ChildAction>>
  let id: ChildState.ID?
  let action: () -> Void
  @ViewBuilder let destination: (Store<ChildState, ChildAction>) -> Destination
  @ViewBuilder let label: Label

  var body: some View {
//    NavigationLink(
//      tag: <#T##V#>,
//      selection: <#T##SwiftUI.Binding<V?>#>,
//      destination: <#T##() -> Destination#>,
//      label: <#T##() -> Label#>
//    )

    WithViewStore(self.store, observe: { $0?.id == self.id }) { viewStore in
      NavigationLink(
        isActive: Binding(
          get: { viewStore.state },
          set: { isActive in
            if isActive {
              self.action()
            } else if viewStore.state {
              viewStore.send(.dismiss)
            }
          }
        ),
        destination: {
          IfLetStore(
            self.store.scope(state: returningLastNonNilValue { $0 }, action: { .presented($0) })
          ) { store in
            self.destination(store)
          }
        },
        label: { self.label }
      )
    }
  }
}

extension View {
  func navigationDestination<DestinationState, DestinationAction, ChildState: Identifiable, ChildAction>(
    store: Store<DestinationState?, PresentationAction<DestinationAction>>,
    state toChildState: @escaping (DestinationState) -> ChildState?,
    action fromChildAction: @escaping (ChildAction) -> DestinationAction,
    @ViewBuilder child: @escaping (Store<ChildState, ChildAction>) -> some View
  ) -> some View {
    self.navigationDestination(
      store: store.scope(
        state: { $0.flatMap(toChildState) },
        action: {
          switch $0 {
          case .dismiss:
            return .dismiss
          case let .presented(action):
            return .presented(fromChildAction(action))
          }
        }
      ),
      destination: child
    )
  }

  func navigationDestination<ChildState, ChildAction>(
    store: Store<ChildState?, PresentationAction<ChildAction>>,
    @ViewBuilder destination: @escaping (Store<ChildState, ChildAction>) -> some View
  ) -> some View {
    WithViewStore(
      store,
      observe: { $0 },
      removeDuplicates: { ($0 != nil) == ($1 != nil) }
    ) { viewStore in
      self.navigationDestination(
        isPresented: Binding(
          get: { viewStore.state != nil },
          set: { isActive in
            if !isActive, viewStore.state != nil {
              viewStore.send(.dismiss)
            }
          }
        )
      ) {
        IfLetStore(
          store.scope(
            state: returningLastNonNilValue { $0 },
            action: { .presented($0) }
          )
        ) { store in
          destination(store)
        }
      }
    }
  }
}

struct Test: View, PreviewProvider {
  static var previews: some View {
    Self()
  }

  @State var background = Color.white
  @State var message = ""
  @State var isPresented = false

  var body: some View {
    ZStack {
      self.background.edgesIgnoringSafeArea(.all)
      Button {
        self.isPresented = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
          self.message = "\(Int.random(in: 0...1_000_000))"
          self.background = .red
        }
      } label: {
        Text("Press")
      }
      .alert("Hello: \(self.message)", isPresented: self.$isPresented) {
        Text("Ok")
      }
    }
  }
}
