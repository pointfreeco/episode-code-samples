import InlineSnapshotTesting
import TestCases
import XCTest

@MainActor
final class PresentationTests: BaseIntegrationTests {
  override func setUpWithError() throws {
    try super.setUpWithError()
    self.app.buttons["iOS 16"].tap()
    self.app.buttons["Presentation"].tap()
    self.clearLogs()
    //SnapshotTesting.isRecording = true
  }

  func testOptional() throws {
    try XCTSkipIf(ProcessInfo.processInfo.environment["CI"] != nil)

    self.app.buttons["Present sheet"].tap()
    self.assertLogs {
      """
      BasicsView.body
      PresentationView.body
      StoreOf<BasicsView.Feature>.init
      """
    }
    self.app.buttons["Increment"].tap()
    self.assertLogs {
      """
      BasicsView.body
      """
    }
    self.app.buttons["Dismiss"].firstMatch.tap()
    self.assertLogs {
      """
      PresentationView.body
      """
    }
  }

  func testOptional_ObserveChildCount() {
    self.app.buttons["Present sheet"].tap()
    self.assertLogs {
      """
      BasicsView.body
      PresentationView.body
      StoreOf<BasicsView.Feature>.init
      """
    }
    self.app.buttons["Observe child count"].tap()
    self.assertLogs {
      """
      PresentationView.body
      StoreOf<PresentationView.Feature>.scope
      """
    }
    self.app.buttons["Increment"].tap()
    self.assertLogs {
      """
      BasicsView.body
      PresentationView.body
      """
    }
    XCTAssertEqual(self.app.staticTexts["Count: 1"].exists, true)
    self.app.buttons["Dismiss"].firstMatch.tap()
    self.assertLogs {
      """
      PresentationView.body
      """
    }
  }
}
