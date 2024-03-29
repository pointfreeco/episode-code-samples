@_spi(Logging) import ComposableArchitecture
import SwiftUI

struct BasicsView: View {
  let store: StoreOf<Feature>

  var body: some View {
    let _ = Logger.shared.log("\(Self.self).body")
    Text(self.store.count.description)
    Button("Decrement") { self.store.send(.decrementButtonTapped) }
    Button("Increment") { self.store.send(.incrementButtonTapped) }
    Button("Dismiss") { self.store.send(.dismissButtonTapped) }
  }

  @Reducer
  struct Feature {
    @ObservableState
    struct State: Equatable, Identifiable {
      let id = UUID()
      var count = 0
    }
    enum Action {
      case decrementButtonTapped
      case dismissButtonTapped
      case incrementButtonTapped
    }
    @Dependency(\.dismiss) var dismiss
    var body: some ReducerOf<Self> {
      Reduce { state, action in
        switch action {
        case .decrementButtonTapped:
          state.count -= 1
          return .none
        case .dismissButtonTapped:
          return .run { _ in await self.dismiss() }
        case .incrementButtonTapped:
          state.count += 1
          return .none
        }
      }
    }
  }
}

struct BasicsPreviews: PreviewProvider {
  static var previews: some View {
    let _ = Logger.shared.isEnabled = true
    Form {
      BasicsView(
        store: Store(initialState: BasicsView.Feature.State()) {
          BasicsView.Feature()
        }
      )
    }
  }
}
