import ComposableArchitecture
import SwiftUI

struct ThirdTabFeature: Reducer {
  struct State: Equatable {}
  enum Action: Equatable {}

  func reduce(into state: inout State, action: Action) -> Effect<Action> {
  }
}

struct ThirdTabView: View {
  let store: StoreOf<ThirdTabFeature>
  
  var body: some View {
    Text("Three")
  }
}
