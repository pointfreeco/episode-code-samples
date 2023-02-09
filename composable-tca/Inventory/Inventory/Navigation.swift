import ComposableArchitecture
import SwiftUI
import SwiftUINavigation

enum AlertAction<Action> {
  case dismiss
  case presented(Action)
}
extension AlertAction: Equatable where Action: Equatable {}

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
        unwrapping: Binding( //viewStore.binding(send: .dismiss)
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
