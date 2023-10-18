import CasePaths
import CustomDump
import Dependencies
import XCTest

@testable import SyncUps_StackBased

@MainActor
final class AppTests: BaseTestCase {
  func testRecordWithTranscript() async throws {
    let syncUp = SyncUp(
      id: SyncUp.ID(),
      attendees: [
        .init(id: Attendee.ID()),
        .init(id: Attendee.ID()),
      ],
      duration: .seconds(10),
      title: "Engineering"
    )

    let model = withDependencies {
      $0.continuousClock = ImmediateClock()
      $0.date.now = Date(timeIntervalSince1970: 1_234_567_890)
      $0.dataManager = .mock(initialData: try? JSONEncoder().encode([syncUp]))
      $0.soundEffectClient = .noop
      $0.speechClient.authorizationStatus = { .authorized }
      $0.speechClient.startTask = { _ in
        AsyncThrowingStream { continuation in
          continuation.yield(
            SpeechRecognitionResult(
              bestTranscription: Transcription(formattedString: "I completed the project"),
              isFinal: true
            )
          )
          continuation.finish()
        }
      }
      $0.uuid = .incrementing
    } operation: {
      AppModel(
        path: [
          .detail(SyncUpDetailModel(syncUp: syncUp)),
          .record(RecordMeetingModel(syncUp: syncUp)),
        ],
        syncUpsList: SyncUpsListModel()
      )
    }

    let recordModel = try XCTUnwrap(model.path[1], case: /AppModel.Destination.record)
    await recordModel.task()

    XCTAssertNoDifference(
      model.syncUpsList.syncUps[0].meetings,
      [
        Meeting(
          id: Meeting.ID(uuidString: "00000000-0000-0000-0000-000000000000")!,
          date: Date(timeIntervalSince1970: 1_234_567_890),
          transcript: "I completed the project"
        )
      ]
    )
  }

  func testDelete() async throws {
    let model = try withDependencies { dependencies in
      dependencies.dataManager = .mock(
        initialData: try JSONEncoder().encode([SyncUp.mock])
      )
      dependencies.continuousClock = ImmediateClock()
    } operation: {
      AppModel(syncUpsList: SyncUpsListModel())
    }

    model.syncUpsList.syncUpTapped(syncUp: model.syncUpsList.syncUps[0])

    let detailModel = try XCTUnwrap(model.path[0], case: /AppModel.Destination.detail)

    detailModel.deleteButtonTapped()

    let alert = try XCTUnwrap(detailModel.destination, case: /SyncUpDetailModel.Destination.alert)

    XCTAssertNoDifference(alert, .deleteSyncUp)

    await detailModel.alertButtonTapped(.confirmDeletion)

    XCTAssertEqual(model.path, [])
    XCTAssertEqual(model.syncUpsList.syncUps, [])
  }

  func testDetailEdit() async throws {
    let model = try withDependencies { dependencies in
      dependencies.dataManager = .mock(
        initialData: try JSONEncoder().encode([
          SyncUp(
            id: SyncUp.ID(uuidString: "00000000-0000-0000-0000-000000000000")!,
            attendees: [
              Attendee(id: Attendee.ID(uuidString: "00000000-0000-0000-0000-000000000001")!)
            ]
          )
        ])
      )
      dependencies.continuousClock = ImmediateClock()
    } operation: {
      AppModel(syncUpsList: SyncUpsListModel())
    }

    model.syncUpsList.syncUpTapped(syncUp: model.syncUpsList.syncUps[0])

    let detailModel = try XCTUnwrap(model.path[0], case: /AppModel.Destination.detail)

    detailModel.editButtonTapped()

    let editModel = try XCTUnwrap(
      detailModel.destination, case: /SyncUpDetailModel.Destination.edit)

    editModel.syncUp.title = "Design"
    detailModel.doneEditingButtonTapped()

    XCTAssertNil(detailModel.destination)
    XCTAssertEqual(
      model.syncUpsList.syncUps,
      [
        SyncUp(
          id: SyncUp.ID(uuidString: "00000000-0000-0000-0000-000000000000")!,
          attendees: [
            Attendee(id: Attendee.ID(uuidString: "00000000-0000-0000-0000-000000000001")!)
          ],
          title: "Design"
        )
      ]
    )
  }
}
