@_spi(Logging) import ComposableArchitecture
import SwiftUI

struct EnumView: View {
  @State var store = Store(initialState: Feature.State()) {
    Feature()
  }

  var body: some View {
    Form {
      let _ = Logger.shared.log("\(Self.self).body")
      Section {
        switch self.store.destination {
        case .feature1:
          Button("Toggle feature 1 off") {
            self.store.send(.toggle1ButtonTapped)
          }
          Button("Toggle feature 2 on") {
            self.store.send(.toggle2ButtonTapped)
          }
        case .feature2:
          Button("Toggle feature 1 on") {
            self.store.send(.toggle1ButtonTapped)
          }
          Button("Toggle feature 2 off") {
            self.store.send(.toggle2ButtonTapped)
          }
        case .none:
          Button("Toggle feature 1 on") {
            self.store.send(.toggle1ButtonTapped)
          }
          Button("Toggle feature 2 on") {
            self.store.send(.toggle2ButtonTapped)
          }
        }
      }
      if let store = self.store.scope(state: \.destination, action: \.destination.presented) {
        switch store.state {
        case .feature1:
          if let store = store.scope(state: \.feature1, action: \.feature1) {
            Section {
              BasicsView(store: store)
            } header: {
              Text("Feature 1")
            }
          }
        case .feature2:
          if let store = store.scope(state: \.feature2, action: \.feature2) {
            Section {
              BasicsView(store: store)
            } header: {
              Text("Feature 2")
            }
          }
        }
      }
    }
  }

  @Reducer
  struct Feature {
    @ObservableState
    struct State: Equatable {
      @PresentationState var destination: Destination.State?
    }
    enum Action {
      case destination(PresentationAction<Destination.Action>)
      case toggle1ButtonTapped
      case toggle2ButtonTapped
    }
    @Reducer
    struct Destination {
//      @ObservableState
      enum State: Equatable, ObservableState {
        case feature1(BasicsView.Feature.State)
        case feature2(BasicsView.Feature.State)

        var _$id: UUID {
          switch self {
          case let .feature1(state):
            return state._$id
          case let .feature2(state):
            return state._$id
          }
        }
      }
      enum Action {
        case feature1(BasicsView.Feature.Action)
        case feature2(BasicsView.Feature.Action)
      }
      var body: some ReducerOf<Self> {
        Scope(state: \.feature1, action: \.feature1) {
          BasicsView.Feature()
        }
        Scope(state: \.feature2, action: \.feature2) {
          BasicsView.Feature()
        }
      }
    }
    var body: some ReducerOf<Self> {
      Reduce { state, action in
        switch action {
        case .destination:
          return .none
        case .toggle1ButtonTapped:
          switch state.destination {
          case .feature1:
            state.destination = nil
          case .feature2:
            state.destination = .feature1(BasicsView.Feature.State())
          case .none:
            state.destination = .feature1(BasicsView.Feature.State())
          }
          return .none
        case .toggle2ButtonTapped:
          switch state.destination {
          case .feature1:
            state.destination = .feature2(BasicsView.Feature.State())
          case .feature2:
            state.destination = nil
          case .none:
            state.destination = .feature2(BasicsView.Feature.State())
          }
          return .none
        }
      }
      .ifLet(\.$destination, action: \.destination) {
        Destination()
      }
    }
  }
}

struct EnumTestCase_Previews: PreviewProvider {
  static var previews: some View {
    let _ = Logger.shared.isEnabled = true
    EnumView()
  }
}
