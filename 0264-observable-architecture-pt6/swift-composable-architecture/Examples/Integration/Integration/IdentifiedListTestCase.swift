@_spi(Logging) import ComposableArchitecture
import SwiftUI

struct IdentifiedListView: View {
  @State var store = Store(initialState: Feature.State()) {
    Feature()
  }

  var body: some View {
    let _ = Logger.shared.log("\(Self.self).body")
    List {
      Section {
        if let firstCount = self.store.rows.first?.count {
          HStack {
            Button("Increment First") {
              self.store.send(.incrementFirstButtonTapped)
            }
            Spacer()
            Text("Count: \(firstCount)")
          }
        }
      }

      if !self.store.rows.isEmpty {
        Section {
          ForEach(
            self.store.scope(state: \.rows, action: \.rows)
              .prefix(3)
          ) { store in
            let _ = Logger.shared.log("\(Self.self).body.ForEachStore")
            Section {
              HStack {
                VStack {
                  BasicsView(store: store)
                }
                Spacer()
                Button(action: { self.store.send(.removeButtonTapped(id: store.state.id)) }) {
                  Image(systemName: "trash")
                }
              }
            }
            .buttonStyle(.borderless)
          }
        } header: {
          Text("Top picks")
        }
      }

//      if self.store.rows.count > 3 {
//        Section {
//          ForEach(
//            self.store.scope(state: \.rows, action: \.rows)
//              .dropFirst(3)
//          ) { store in
//            let _ = Logger.shared.log("\(Self.self).body.ForEachStore")
//            Section {
//              HStack {
//                VStack {
//                  BasicsView(store: store)
//                }
//                Spacer()
//                Button(action: { self.store.send(.removeButtonTapped(id: store.state.id)) }) {
//                  Image(systemName: "trash")
//                }
//              }
//            }
//            .buttonStyle(.borderless)
//          }
//        } header: {
//          Text("You might also like")
//        }
//      }
    }
    .toolbar {
      ToolbarItem {
        Button("Add") { self.store.send(.addButtonTapped) }
      }
    }
  }

  @Reducer
  struct Feature {
    @ObservableState
    struct State: Equatable {
      var rows: IdentifiedArrayOf<BasicsView.Feature.State> = []
    }
    enum Action {
      case addButtonTapped
      case incrementFirstButtonTapped
      case removeButtonTapped(id: BasicsView.Feature.State.ID)
      case rows(IdentifiedActionOf<BasicsView.Feature>)
    }
    var body: some ReducerOf<Self> {
      Reduce { state, action in
        switch action {
        case .addButtonTapped:
          state.rows.append(BasicsView.Feature.State())
          return .none
        case .incrementFirstButtonTapped:
          state.rows[id: state.rows.ids[0]]?.count += 1
          return .none
        case let .removeButtonTapped(id: id):
          state.rows.remove(id: id)
          return .none
        case .rows:
          return .none
        }
      }
      .forEach(\.rows, action: \.rows) {
        BasicsView.Feature()
      }
    }
  }
}

struct IdentifiedListPreviews: PreviewProvider {
  static var previews: some View {
    let _ = Logger.shared.isEnabled = true
    NavigationStack {
      IdentifiedListView()
    }
  }
}
