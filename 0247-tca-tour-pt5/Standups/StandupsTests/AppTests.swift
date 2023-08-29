import ComposableArchitecture
import XCTest
@testable import Standups

@MainActor
final class AppTests: XCTestCase {
  func testEdit() async {
    let standup = Standup.mock
    let store = TestStore(
      initialState: AppFeature.State(
        standupsList: StandupsListFeature.State(
          standups: [standup]
        )
      )
    ) {
      AppFeature()
    }
    await store.send(.path(.push(id: 0, state: .detail(StandupDetailFeature.State(standup: standup))))) {
      $0.path[id: 0] = .detail(StandupDetailFeature.State(standup: standup))
    }
    await store.send(.path(.element(id: 0, action: .detail(.editButtonTapped)))) {
      $0.path[id: 0, case: /AppFeature.Path.State.detail]?.destination = .editStandup(StandupFormFeature.State(standup: standup))
    }
    var editedStandup = standup
    editedStandup.title = "Point-Free Morning Sync"
    await store.send(.path(.element(id: 0, action: .detail(.destination(.presented(.editStandup(.set(\.$standup, editedStandup)))))))) {
      $0.path[id: 0, case: /AppFeature.Path.State.detail]?
        .$destination[case: /StandupDetailFeature.Destination.State.editStandup]?
        .standup.title = "Point-Free Morning Sync"
    }
    await store.send(.path(.element(id: 0, action: .detail(.saveStandupButtonTapped)))) {
      $0.path[id: 0, case: /AppFeature.Path.State.detail]?.destination = nil
      $0.path[id: 0, case: /AppFeature.Path.State.detail]?.standup.title = "Point-Free Morning Sync"
    }
    await store.receive(.path(.element(id: 0, action: .detail(.delegate(.standupUpdated(editedStandup)))))) {
      $0.standupsList.standups[0].title = "Point-Free Morning Sync"
    }
  }

  func testEdit_NonExhaustive() async {
    let standup = Standup.mock
    let store = TestStore(
      initialState: AppFeature.State(
        standupsList: StandupsListFeature.State(
          standups: [standup]
        )
      )
    ) {
      AppFeature()
    }
    store.exhaustivity = .off
    await store.send(.path(.push(id: 0, state: .detail(StandupDetailFeature.State(standup: standup)))))
    await store.send(.path(.element(id: 0, action: .detail(.editButtonTapped))))
    var editedStandup = standup
    editedStandup.title = "Point-Free Morning Sync"
    await store.send(.path(.element(id: 0, action: .detail(.destination(.presented(.editStandup(.set(\.$standup, editedStandup))))))))
    await store.send(.path(.element(id: 0, action: .detail(.saveStandupButtonTapped))))
    await store.skipReceivedActions()
    store.assert {
      $0.standupsList.standups[0].title = "Point-Free Morning Sync"
    }
  }


  func testDeletion_NonExhaustive() async {
    let standup = Standup.mock
    let store = TestStore(
      initialState: AppFeature.State(
        path: StackState([
          .detail(StandupDetailFeature.State(standup: standup))
        ]),
        standupsList: StandupsListFeature.State(
          standups: [standup]
        )
      )
    ) {
      AppFeature()
    }
    store.exhaustivity = .off

    await store.send(.path(.element(id: 0, action: .detail(.deleteButtonTapped)))) 
    await store.send(.path(.element(id: 0, action: .detail(.destination(.presented(.alert(.confirmDeletion)))))))
    await store.skipReceivedActions()
    store.assert {
      $0.path = StackState([])
      $0.standupsList.standups = []
    }
  }
}
