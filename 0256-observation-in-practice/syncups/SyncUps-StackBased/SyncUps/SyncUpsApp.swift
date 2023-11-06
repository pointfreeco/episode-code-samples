import Dependencies
import SwiftUI

@main
struct SyncUpsApp: App {
  let model = AppModel(
    //            path: [
    //              .detail(SyncUpDetailModel(syncUp: .mock)),
    //              .record(
    //                RecordMeetingModel(
    //                  //destination: .alert(.endMeeting(isDiscardable: true)),
    //                  syncUp: .mock
    //                )
    //              )
    //            ],
                syncUpsList: SyncUpsListModel()
              )

  var body: some Scene {
    WindowGroup {
      // NB: This conditional is here only to facilitate UI testing so that we can mock out certain
      //     dependencies for the duration of the test (e.g. the data manager). We do not really
      //     recommend performing UI tests in general, but we do want to demonstrate how it can be
      //     done.
      if let testName = ProcessInfo.processInfo.environment["UI_TEST_NAME"] {
        UITestingView(testName: testName)
      } else {
        AppView(
          model: self.model
        )
      }
    }
  }
}

struct UITestingView: View {
  let testName: String

  var body: some View {
    withDependencies {
      $0.continuousClock = ContinuousClock()
      $0.date = DateGenerator { Date() }
      $0.mainQueue = DispatchQueue.main.eraseToAnyScheduler()
      $0.soundEffectClient = .noop
      $0.uuid = UUIDGenerator { UUID() }
      switch testName {
      case "testAdd":
        $0.dataManager = .mock()
      case "testDelete", "testEdit":
        $0.dataManager = .mock(initialData: try? JSONEncoder().encode([SyncUp.mock]))
      case "testRecord", "testRecord_Discard":
        $0.date = DateGenerator { Date(timeIntervalSince1970: 1234567890) }
        $0.speechClient.authorizationStatus = { .authorized }
        $0.speechClient.startTask = { _ in
          AsyncThrowingStream {
            $0.yield(
              SpeechRecognitionResult(
                bestTranscription: Transcription(formattedString: "Hello world!"),
                isFinal: true
              )
            )
            $0.finish()
          }
        }
        $0.dataManager = .mock(initialData: try? JSONEncoder().encode([SyncUp.mock]))
      case "testPersistence":
        let id = ProcessInfo.processInfo.environment["TEST_UUID"]!
        let url = URL.documentsDirectory.appending(component: "\(id).json")
        $0.dataManager = .init(
          load: { _ in try Data(contentsOf: url) },
          save: { data, _ in try data.write(to: url) }
        )

      default:
        fatalError()
      }
    } operation: {
      AppView(model: AppModel(syncUpsList: SyncUpsListModel()))
    }
  }
}
