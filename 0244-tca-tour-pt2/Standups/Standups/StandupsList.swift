import ComposableArchitecture
import SwiftUI

struct StandupsListFeature: Reducer {
  struct State {
    var standups: IdentifiedArrayOf<Standup> = []
  }
  enum Action {
    case addButtonTapped
  }
  var body: some ReducerOf<Self> {
    Reduce { state, action in
      switch action {
      case .addButtonTapped:
        state.standups.append(
          Standup(
            id: UUID(),
            theme: .allCases.randomElement()!
          )
        )
        return .none
      }
    }
  }
}

struct StandupsListView: View {
  let store: StoreOf<StandupsListFeature>

  var body: some View {
    WithViewStore(self.store, observe: \.standups) { viewStore in
      List {
        ForEach(viewStore.state) { standup in
          CardView(standup: standup)
            .listRowBackground(standup.theme.mainColor)
        }
      }
      .navigationTitle("Daily Standups")
      .toolbar {
        ToolbarItem {
          Button("Add") {
            viewStore.send(.addButtonTapped)
          }
        }
      }
    }
  }
}

struct CardView: View {
  let standup: Standup

  var body: some View {
    VStack(alignment: .leading) {
      Text(self.standup.title)
        .font(.headline)
      Spacer()
      HStack {
        Label("\(self.standup.attendees.count)", systemImage: "person.3")
        Spacer()
        Label(self.standup.duration.formatted(.units()), systemImage: "clock")
          .labelStyle(.trailingIcon)
      }
      .font(.caption)
    }
    .padding()
    .foregroundColor(self.standup.theme.accentColor)
  }
}

struct TrailingIconLabelStyle: LabelStyle {
  func makeBody(configuration: Configuration) -> some View {
    HStack {
      configuration.title
      configuration.icon
    }
  }
}

extension LabelStyle where Self == TrailingIconLabelStyle {
  static var trailingIcon: Self { Self() }
}

#Preview {
  MainActor.assumeIsolated {
    NavigationStack {
      StandupsListView(
        store: Store(
          initialState: StandupsListFeature.State(
            standups: [.mock]
          )
        ) {
          StandupsListFeature()
        }
      )
    }
  }
}
