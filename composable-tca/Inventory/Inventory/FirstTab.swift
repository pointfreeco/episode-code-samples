import ComposableArchitecture
import SwiftUI

struct FirstTabFeature: Reducer {
  struct State: Equatable {}
  enum Action {
    case goToInventoryButtonTapped
  }

  func reduce(into state: inout State, action: Action) -> Effect<Action> {
    switch action {
    case .goToInventoryButtonTapped:
      return .none
    }
  }
}

struct FirstTabView: View {
  let store: StoreOf<FirstTabFeature>

  var body: some View {
    WithViewStore(self.store, observe: { $0 }) { viewStore in
      Button {
        viewStore.send(.goToInventoryButtonTapped)
      } label: {
        Text("Go to inventory")
      }
    }
  }
}
