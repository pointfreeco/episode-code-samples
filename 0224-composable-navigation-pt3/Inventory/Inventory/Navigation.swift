import ComposableArchitecture
import SwiftUI
import SwiftUINavigation

enum AlertAction<Action> {
  case dismiss
  case presented(Action)
}
extension AlertAction: Equatable where Action: Equatable {}

enum ConfirmationDialogAction<Action> {
  case dismiss
  case presented(Action)
}
extension ConfirmationDialogAction: Equatable where Action: Equatable {}

enum SheetAction<Action> {
  case dismiss
  case presented(Action)
}
extension SheetAction: Equatable where Action: Equatable {}

extension Reducer {
  func sheet<ChildState, ChildAction>(
    state stateKeyPath: WritableKeyPath<State, ChildState?>,
    action actionCasePath: CasePath<Action, SheetAction<ChildAction>>,
    @ReducerBuilder<ChildState, ChildAction> child: () -> some Reducer<ChildState, ChildAction>
  ) -> some ReducerOf<Self> {
    let child = child()
    return Reduce { state, action in
      switch (state[keyPath: stateKeyPath], actionCasePath.extract(from: action)) {

      case (_, .none):
        return self.reduce(into: &state, action: action)

      case (.none, .some(.presented)), (.none, .some(.dismiss)):
        XCTFail("A sheet action was sent while child state was nil.")
        return self.reduce(into: &state, action: action)

      case (.some(var childState), .some(.presented(let childAction))):
        let childEffects = child.reduce(into: &childState, action: childAction)
        state[keyPath: stateKeyPath] = childState
        let effects = self.reduce(into: &state, action: action)
        return .merge(
          childEffects.map { actionCasePath.embed(.presented($0)) },
          effects
        )

      case (.some, .some(.dismiss)):
        let effects = self.reduce(into: &state, action: action)
        state[keyPath: stateKeyPath] = nil
        return effects
      }
    }
  }
}

extension View {
  func sheet<ChildState: Identifiable, ChildAction>(
    store: Store<ChildState?, SheetAction<ChildAction>>,
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
            action: SheetAction.presented
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

extension Reducer {
  func alert<Action>(
    state alertKeyPath: WritableKeyPath<State, AlertState<Action>?>,
    action alertCasePath: CasePath<Self.Action, AlertAction<Action>>
  ) -> some ReducerOf<Self> {
    Reduce { state, action in
      let effects = self.reduce(into: &state, action: action)
      if alertCasePath ~= action {
        state[keyPath: alertKeyPath] = nil
      }
      return effects
    }
  }
}

extension Reducer {
  func confirmationDialog<Action>(
    state alertKeyPath: WritableKeyPath<State, ConfirmationDialogState<Action>?>,
    action alertCasePath: CasePath<Self.Action, ConfirmationDialogAction<Action>>
  ) -> some ReducerOf<Self> {
    Reduce { state, action in
      let effects = self.reduce(into: &state, action: action)
      if alertCasePath ~= action {
        state[keyPath: alertKeyPath] = nil
      }
      return effects
    }
  }
}

extension View {
  func alert<Action>(
    store: Store<AlertState<Action>?, AlertAction<Action>>
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
  func confirmationDialog<Action>(
    store: Store<ConfirmationDialogState<Action>?, ConfirmationDialogAction<Action>>
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
