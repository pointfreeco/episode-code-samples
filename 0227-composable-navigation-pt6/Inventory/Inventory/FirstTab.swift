import ComposableArchitecture
import SwiftUI

struct FirstTabFeature: Reducer {
  struct State: Equatable {}
  enum Action: Equatable {
    case goToInventoryButtonTapped
    case delegate(Delegate)

    enum Delegate: Equatable {
      case switchToInventoryTab
    }
  }

  func reduce(into state: inout State, action: Action) -> Effect<Action> {
    switch action {
    case .delegate:
      return .none

    case .goToInventoryButtonTapped:
      return .send(.delegate(.switchToInventoryTab))
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
