import ComposableArchitecture
import SwiftUI

struct StandupsListFeature: Reducer {
  struct State: Equatable {
    @PresentationState var addStandup: StandupFormFeature.State?
    var standups: IdentifiedArrayOf<Standup> = []
    init(
      addStandup: StandupFormFeature.State? = nil
    ) {
      self.addStandup = addStandup
      do {
        @Dependency(\.dataManager.load) var loadData
        self.standups = try JSONDecoder().decode(IdentifiedArrayOf<Standup>.self, from: loadData(.standups))
      } catch {
        self.standups = []
      }
    }
  }
  enum Action: Equatable {
    case addButtonTapped
    case addStandup(PresentationAction<StandupFormFeature.Action>)
    case cancelStandupButtonTapped
    case saveStandupButtonTapped
  }
  @Dependency(\.uuid) var uuid
  var body: some ReducerOf<Self> {
    Reduce { state, action in
      switch action {
      case .addButtonTapped:
        state.addStandup = StandupFormFeature.State(standup: Standup(id: self.uuid()))
        return .none

      case .addStandup:
        return .none

      case .cancelStandupButtonTapped:
        state.addStandup = nil
        return .none

      case .saveStandupButtonTapped:
        guard let standup = state.addStandup?.standup
        else { return .none }
        state.standups.append(standup)
        state.addStandup = nil
        return .none
      }
    }
    .ifLet(\.$addStandup, action: /Action.addStandup) {
      StandupFormFeature()
    }
  }
}

struct StandupsListView: View {
  let store: StoreOf<StandupsListFeature>

  var body: some View {
    WithViewStore(self.store, observe: \.standups) { viewStore in
      List {
        ForEach(viewStore.state) { standup in
          NavigationLink(
            state: AppFeature.Path.State.detail(StandupDetailFeature.State(standup: standup))
          ) {
            CardView(standup: standup)
          }
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
      .sheet(
        store: self.store.scope(
          state: \.$addStandup,
          action: { .addStandup($0) }
        )
      ) { store in
        NavigationStack {
          StandupFormView(store: store)
            .navigationTitle("New standup")
            .toolbar {
              ToolbarItem {
                Button("Save") { viewStore.send(.saveStandupButtonTapped) }
              }
              ToolbarItem(placement: .cancellationAction) {
                Button("Cancel") { viewStore.send(.cancelStandupButtonTapped) }
              }
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
//            standups: [.mock]
          )
        ) {
          StandupsListFeature()
            ._printChanges()
        }
      )
    }
  }
}
