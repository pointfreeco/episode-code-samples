import CasePaths
import CustomDump
import Dependencies
import XCTest

@testable import SyncUps_TreeBased

@MainActor
final class SyncUpDetailTests: BaseTestCase {
  func testSpeechRestricted() throws {
    let model = withDependencies {
      $0.speechClient.authorizationStatus = { .restricted }
    } operation: {
      SyncUpDetailModel(syncUp: .mock)
    }

    model.startMeetingButtonTapped()

    let alert = try XCTUnwrap(model.destination, case: /SyncUpDetailModel.Destination.alert)

    XCTAssertNoDifference(alert, .speechRecognitionRestricted)
  }

  func testSpeechDenied() async throws {
    let model = withDependencies {
      $0.speechClient.authorizationStatus = { .denied }
    } operation: {
      SyncUpDetailModel(syncUp: .mock)
    }

    model.startMeetingButtonTapped()

    let alert = try XCTUnwrap(model.destination, case: /SyncUpDetailModel.Destination.alert)

    XCTAssertNoDifference(alert, .speechRecognitionDenied)
  }

  func testOpenSettings() async {
    let settingsOpened = LockIsolated(false)
    let model = withDependencies {
      $0.openSettings = { settingsOpened.setValue(true) }
    } operation: {
      SyncUpDetailModel(
        destination: .alert(.speechRecognitionDenied),
        syncUp: .mock
      )
    }

    await model.alertButtonTapped(.openSettings)

    XCTAssertEqual(settingsOpened.value, true)
  }

  func testContinueWithoutRecording() async throws {
    let model = SyncUpDetailModel(
      destination: .alert(.speechRecognitionDenied),
      syncUp: .mock
    )

    await model.alertButtonTapped(.continueWithoutRecording)

    let recordModel = try XCTUnwrap(model.destination, case: /SyncUpDetailModel.Destination.record)

    XCTAssertEqual(recordModel.syncUp, model.syncUp)
  }

  func testSpeechAuthorized() async throws {
    let model = withDependencies {
      $0.speechClient.authorizationStatus = { .authorized }
    } operation: {
      SyncUpDetailModel(syncUp: .mock)
    }

    model.startMeetingButtonTapped()

    let recordModel = try XCTUnwrap(model.destination, case: /SyncUpDetailModel.Destination.record)

    XCTAssertEqual(recordModel.syncUp, model.syncUp)
  }

  func testRecordWithTranscript() async throws {
    let model = withDependencies {
      $0.continuousClock = ImmediateClock()
      $0.date.now = Date(timeIntervalSince1970: 1_234_567_890)
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
      SyncUpDetailModel(
        destination: .record(RecordMeetingModel(syncUp: .mock)),
        syncUp: SyncUp(
          id: SyncUp.ID(),
          attendees: [
            .init(id: Attendee.ID()),
            .init(id: Attendee.ID()),
          ],
          duration: .seconds(10),
          title: "Engineering"
        )
      )
    }
    let onSyncUpUpdatedExpectation = self.expectation(description: "onSyncUpUpdated")
    defer { self.wait(for: [onSyncUpUpdatedExpectation], timeout: 0) }
    model.onSyncUpUpdated = { _ in
      onSyncUpUpdatedExpectation.fulfill()
    }

    let recordModel = try XCTUnwrap(model.destination, case: /SyncUpDetailModel.Destination.record)

    await recordModel.task()

    XCTAssertNil(model.destination)
    XCTAssertNoDifference(
      model.syncUp.meetings,
      [
        Meeting(
          id: Meeting.ID(uuidString: "00000000-0000-0000-0000-000000000000")!,
          date: Date(timeIntervalSince1970: 1_234_567_890),
          transcript: "I completed the project"
        )
      ]
    )
  }

  func testEdit() throws {
    let model = withDependencies {
      $0.uuid = .incrementing
    } operation: {
      @Dependency(\.uuid) var uuid

      return SyncUpDetailModel(
        syncUp: SyncUp(
          id: SyncUp.ID(uuid()),
          title: "Engineering"
        )
      )
    }
    let onSyncUpUpdatedExpectation = self.expectation(description: "onSyncUpUpdated")
    defer { self.wait(for: [onSyncUpUpdatedExpectation], timeout: 0) }
    model.onSyncUpUpdated = { _ in
      onSyncUpUpdatedExpectation.fulfill()
    }

    model.editButtonTapped()

    let editModel = try XCTUnwrap(model.destination, case: /SyncUpDetailModel.Destination.edit)

    editModel.syncUp.title = "Engineering"
    editModel.syncUp.theme = .lavender
    model.doneEditingButtonTapped()

    XCTAssertNil(model.destination)
    XCTAssertEqual(
      model.syncUp,
      SyncUp(
        id: SyncUp.ID(uuidString: "00000000-0000-0000-0000-000000000000")!,
        attendees: [
          Attendee(id: Attendee.ID(uuidString: "00000000-0000-0000-0000-000000000001")!)
        ],
        theme: .lavender,
        title: "Engineering"
      )
    )
  }
}
