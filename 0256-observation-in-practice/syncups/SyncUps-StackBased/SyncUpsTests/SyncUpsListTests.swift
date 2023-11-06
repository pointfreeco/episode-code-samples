import CasePaths
import CustomDump
import Dependencies
import IdentifiedCollections
import XCTest

@testable import SyncUps_StackBased

@MainActor
final class SyncUpsListTests: BaseTestCase {
  let clock = TestClock()

  func testAdd() async throws {
    let savedData = LockIsolated(Data?.none)

    let model = withDependencies {
      $0.dataManager = .mock()
      $0.dataManager.save = { data, _ in savedData.setValue(data) }
      $0.continuousClock = ImmediateClock()
      $0.uuid = .incrementing
    } operation: {
      SyncUpsListModel()
    }

    model.addSyncUpButtonTapped()

    let addModel = try XCTUnwrap(model.destination, case: /SyncUpsListModel.Destination.add)

    addModel.syncUp.title = "Engineering"
    addModel.syncUp.attendees[0].name = "Blob"
    addModel.addAttendeeButtonTapped()
    addModel.syncUp.attendees[1].name = "Blob Jr."
    model.confirmAddSyncUpButtonTapped()

    XCTAssertNil(model.destination)

    XCTAssertNoDifference(
      model.syncUps,
      [
        SyncUp(
          id: SyncUp.ID(uuidString: "00000000-0000-0000-0000-000000000000")!,
          attendees: [
            Attendee(
              id: Attendee.ID(uuidString: "00000000-0000-0000-0000-000000000001")!,
              name: "Blob"
            ),
            Attendee(
              id: Attendee.ID(uuidString: "00000000-0000-0000-0000-000000000002")!,
              name: "Blob Jr."
            ),
          ],
          title: "Engineering"
        )
      ]
    )
  }

  func testAdd_ValidatedAttendees() async throws {
    let model = withDependencies {
      $0.dataManager = .mock()
      $0.continuousClock = ImmediateClock()
      $0.uuid = .incrementing
    } operation: {
      SyncUpsListModel(
        destination: .add(
          SyncUpFormModel(
            syncUp: SyncUp(
              id: SyncUp.ID(uuidString: "deadbeef-dead-beef-dead-beefdeadbeef")!,
              attendees: [
                Attendee(id: Attendee.ID(), name: ""),
                Attendee(id: Attendee.ID(), name: "    "),
              ],
              title: "Design"
            )
          )
        )
      )
    }

    model.confirmAddSyncUpButtonTapped()

    XCTAssertNil(model.destination)
    XCTAssertNoDifference(
      model.syncUps,
      [
        SyncUp(
          id: SyncUp.ID(uuidString: "deadbeef-dead-beef-dead-beefdeadbeef")!,
          attendees: [
            Attendee(
              id: Attendee.ID(uuidString: "00000000-0000-0000-0000-000000000000")!,
              name: ""
            )
          ],
          title: "Design"
        )
      ]
    )
  }

  func testLoadingDataDecodingFailed() async throws {
    let model = withDependencies {
      $0.continuousClock = ImmediateClock()
      $0.dataManager = .mock(
        initialData: Data("!@#$ BAD DATA %^&*()".utf8)
      )
    } operation: {
      SyncUpsListModel()
    }

    let alert = try XCTUnwrap(model.destination, case: /SyncUpsListModel.Destination.alert)

    XCTAssertNoDifference(alert, .dataFailedToLoad)

    model.alertButtonTapped(.confirmLoadMockData)

    XCTAssertNoDifference(model.syncUps, [.mock, .designMock, .engineeringMock])
  }

  func testLoadingDataFileNotFound() async throws {
    let model = withDependencies {
      $0.dataManager.load = { _ in
        struct FileNotFound: Error {}
        throw FileNotFound()
      }
    } operation: {
      SyncUpsListModel()
    }

    XCTAssertNil(model.destination)
  }

  func testSave() async throws {
    let expectation = self.expectation(description: "DataManager.save")
    let savedData = LockIsolated<Data>(Data())

    let model = withDependencies {
      $0.dataManager.load = { _ in try JSONEncoder().encode([SyncUp]()) }
      $0.dataManager.save = { data, url in
        savedData.setValue(data)
        expectation.fulfill()
      }
      $0.continuousClock = self.clock
    } operation: {
      SyncUpsListModel(
        destination: .add(SyncUpFormModel(syncUp: .mock))
      )
    }

    model.confirmAddSyncUpButtonTapped()
    await self.clock.advance(by: .seconds(1))
    await self.fulfillment(of: [expectation], timeout: 1)
    XCTAssertEqual(
      try JSONDecoder().decode([SyncUp].self, from: savedData.value),
      [.mock]
    )
  }
}
