import ComposableArchitecture
import SwiftUI

struct AppFeature: Reducer {
  struct State: Equatable {
    var path = StackState<Path.State>()
    var standupsList = StandupsListFeature.State()
  }
  enum Action: Equatable {
    case path(StackAction<Path.State, Path.Action>)
    case standupsList(StandupsListFeature.Action)
  }
  @Dependency(\.date.now) var now
  @Dependency(\.uuid) var uuid

  struct Path: Reducer {
    enum State: Equatable {
      case detail(StandupDetailFeature.State)
      case meeting(Meeting, standup: Standup)
      case recordMeeting(RecordMeetingFeature.State)
    }
    enum Action: Equatable {
      case detail(StandupDetailFeature.Action)
      case meeting(Never)
      case recordMeeting(RecordMeetingFeature.Action)
    }
    var body: some ReducerOf<Self> {
      Scope(state: /State.detail, action: /Action.detail) {
        StandupDetailFeature()
      }
      Scope(state: /State.recordMeeting, action: /Action.recordMeeting) {
        RecordMeetingFeature()
      }
    }
  }

  @Dependency(\.continuousClock) var clock
  @Dependency(\.dataManager.save) var saveData

  var body: some ReducerOf<Self> {
    Scope(state: \.standupsList, action: /Action.standupsList) {
      StandupsListFeature()
    }

    Reduce { state, action in
      switch action {
      case let .path(.element(id: _, action: .detail(.delegate(action)))):
        switch action {
        case let .deleteStandup(id: id):
          state.standupsList.standups.remove(id: id)
          return .none

        case let .standupUpdated(standup):
          state.standupsList.standups[id: standup.id] = standup
          return .none
        }

      case let .path(.element(id: id, action: .recordMeeting(.delegate(action)))):
        switch action {
        case let .saveMeeting(transcript: transcript):
          guard let detailID = state.path.ids.dropLast().last
          else {
            XCTFail("Record meeting is the last element in the stack. A detail feature should proceed it.")
            return .none
          }
          state.path[id: detailID, case: /Path.State.detail]?.standup.meetings.insert(
            Meeting(
              id: self.uuid(),
              date: self.now,
              transcript: transcript
            ),
            at: 0
          )
          guard let standup = state.path[id: detailID, case: /Path.State.detail]?.standup
          else { return .none }
          state.standupsList.standups[id: standup.id] = standup
          return .none
        }

      case .path:
        return .none

      case .standupsList:
        return .none
      }
    }
    .forEach(\.path, action: /Action.path) {
      Path()
    }

    Reduce { state, _ in
      .run { [standups = state.standupsList.standups] _ in
        enum CancelID { case saveDebounce }
        try await withTaskCancellation(id: CancelID.saveDebounce, cancelInFlight: true) {
          try await self.clock.sleep(for: .seconds(1))
          try self.saveData(
            JSONEncoder().encode(standups),
            .standups
          )
        }
      }
    }
  }
}

struct AppView: View {
  let store: StoreOf<AppFeature>

  var body: some View {
    NavigationStackStore(
      self.store.scope(state: \.path, action: { .path($0) })
    ) {
      StandupsListView(
        store: self.store.scope(
          state: \.standupsList,
          action: { .standupsList($0) }
        )
      )
    } destination: { state in
      switch state {
      case .detail:
        CaseLet(
          /AppFeature.Path.State.detail,
          action: AppFeature.Path.Action.detail,
          then: StandupDetailView.init(store:)
        )
      case let .meeting(meeting, standup: standup):
        MeetingView(meeting: meeting, standup: standup)
      case .recordMeeting:
        CaseLet(
          /AppFeature.Path.State.recordMeeting,
          action: AppFeature.Path.Action.recordMeeting,
          then: RecordMeetingView.init(store:)
        )
      }
    }
  }
}

extension URL {
  static let standups = Self.documentsDirectory.appending(component: "standups.json")
}

#Preview {
  AppView(
    store: Store(
      initialState: AppFeature.State(
        standupsList: StandupsListFeature.State()
      )
    ) {
      AppFeature()
        ._printChanges()
    } withDependencies: {
      $0.dataManager = .mock(initialData: try? JSONEncoder().encode([Standup.mock]))
    }
  )
}

#Preview("Quick finish meeting") {
  var standup = Standup.mock
  standup.duration = .seconds(6)

  return AppView(
    store: Store(
      initialState: AppFeature.State(
        path: StackState([
          .detail(StandupDetailFeature.State(standup: standup)),
          .recordMeeting(RecordMeetingFeature.State(standup: standup))
        ]),
        standupsList: StandupsListFeature.State(
//          standups: [standup]
        )
      )
    ) {
      AppFeature()
        ._printChanges()
    }
  )
}
