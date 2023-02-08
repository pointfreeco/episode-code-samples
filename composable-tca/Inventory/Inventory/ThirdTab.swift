import ComposableArchitecture
import SwiftUI

struct ThirdTabFeature: Reducer {
  struct State {}
  enum Action {}

  func reduce(into state: inout State, action: Action) -> Effect<Action> {
  }
}

struct ThirdTabView: View {
  let store: StoreOf<ThirdTabFeature>
  
  var body: some View {
    Text("Three")
  }
}
