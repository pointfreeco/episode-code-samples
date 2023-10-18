import ComposableArchitecture
import SwiftUI

protocol CasePathable {
  associatedtype Cases
  static var cases: Cases { get }
}

typealias CaseKeyPath<Root: CasePathable, Value> =
  KeyPath<Root.Cases, CasePath<Root, Value>>

struct NewScope<ParentState, ParentAction: CasePathable, Child: Reducer>: Reducer {
  let state: WritableKeyPath<ParentState, Child.State>
  let action: CaseKeyPath<ParentAction, Child.Action>
  let child: () -> Child
  var body: some Reducer<ParentState, ParentAction> {
    let actionCasePath = ParentAction.cases[keyPath: self.action]
    Scope(state: self.state, action: actionCasePath, child: child)
  }
}

struct AppFeature: Reducer {
  struct State: Equatable {
    var path = StackState<Path.State>()
    var syncUpsList = SyncUpsList.State()
  }

  enum Action: Equatable, CasePathable {
    case path(StackAction<Path.State, Path.Action>)
    case syncUpsList(SyncUpsList.Action)

    static let cases = Cases()

    struct Cases {
      let syncUpsList = CasePath<Action, SyncUpsList.Action>(
        embed: Action.syncUpsList,
        extract: {
          guard case let .syncUpsList(value) = $0
          else { return nil }
          return value
        }
      )
      let path = CasePath<Action, StackAction<Path.State, Path.Action>>(
        embed: Action.path,
        extract: {
          guard case let .path(value) = $0
          else { return nil }
          return value
        }
      )
    }

    func foo() {
      let _: KeyPath<Action.Cases, CasePath<Action, SyncUpsList.Action>> = \Action.Cases.syncUpsList
    }
  }

  @Dependency(\.continuousClock) var clock
  @Dependency(\.date.now) var now
  @Dependency(\.dataManager.save) var saveData
  @Dependency(\.uuid) var uuid

  private enum CancelID {
    case saveDebounce
  }

  var body: some ReducerOf<Self> {
    NewScope(state: \.syncUpsList, action: \.syncUpsList) {
      SyncUpsList()
    }
    Reduce { state, action in
      switch action {
      case let .path(.element(id, .detail(.delegate(delegateAction)))):
        guard case let .some(.detail(detailState)) = state.path[id: id]
        else { return .none }

        switch delegateAction {
        case .deleteSyncUp:
          state.syncUpsList.syncUps.remove(id: detailState.syncUp.id)
          return .none

        case let .syncUpUpdated(syncUp):
          state.syncUpsList.syncUps[id: syncUp.id] = syncUp
          return .none

        case .startMeeting:
          state.path.append(.record(RecordMeeting.State(syncUp: detailState.syncUp)))
          return .none
        }

      case let .path(.element(_, .record(.delegate(delegateAction)))):
        switch delegateAction {
        case let .save(transcript: transcript):
          guard let id = state.path.ids.dropLast().last
          else {
            XCTFail(
              """
              Record meeting is the only element in the stack. A detail feature should precede it.
              """
            )
            return .none
          }

          state.path[id: id, case: /Path.State.detail]?.syncUp.meetings.insert(
            Meeting(
              id: Meeting.ID(self.uuid()),
              date: self.now,
              transcript: transcript
            ),
            at: 0
          )
          guard let syncUp = state.path[id: id, case: /Path.State.detail]?.syncUp
          else { return .none }
          state.syncUpsList.syncUps[id: syncUp.id] = syncUp
          return .none
        }

      case .path:
        return .none

      case .syncUpsList:
        return .none
      }
    }
    .forEach(\.path, action: /Action.path) {
      Path()
    }

    Reduce { state, action in
      return .run { [syncUps = state.syncUpsList.syncUps] _ in
        try await withTaskCancellation(id: CancelID.saveDebounce, cancelInFlight: true) {
          try await self.clock.sleep(for: .seconds(1))
          try await self.saveData(JSONEncoder().encode(syncUps), .syncUps)
        }
      } catch: { _, _ in
      }
    }
  }

  struct Path: Reducer {
    enum State: Equatable {
      case detail(SyncUpDetail.State)
      case meeting(Meeting, syncUp: SyncUp)
      case record(RecordMeeting.State)
    }

    enum Action: Equatable {
      case detail(SyncUpDetail.Action)
      case record(RecordMeeting.Action)
    }

    var body: some Reducer<State, Action> {
      Scope(state: /State.detail, action: /Action.detail) {
        SyncUpDetail()
      }
      Scope(state: /State.record, action: /Action.record) {
        RecordMeeting()
      }
    }
  }
}

struct AppView: View {
  let store: StoreOf<AppFeature>

  var body: some View {
    NavigationStackStore(self.store.scope(state: \.path, action: { .path($0) })) {
      SyncUpsListView(
        store: self.store.scope(state: \.syncUpsList, action: { .syncUpsList($0) })
      )
    } destination: {
      switch $0 {
      case .detail:
        CaseLet(
          /AppFeature.Path.State.detail,
          action: AppFeature.Path.Action.detail,
          then: SyncUpDetailView.init(store:)
        )
      case let .meeting(meeting, syncUp: syncUp):
        MeetingView(meeting: meeting, syncUp: syncUp)
      case .record:
        CaseLet(
          /AppFeature.Path.State.record,
          action: AppFeature.Path.Action.record,
          then: RecordMeetingView.init(store:)
        )
      }
    }
  }
}

extension URL {
  static let syncUps = Self.documentsDirectory.appending(component: "sync-ups.json")
}
