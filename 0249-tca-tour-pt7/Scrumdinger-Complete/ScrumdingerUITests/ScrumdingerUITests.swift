import XCTest

@MainActor
final class ScrumdingerUITests: XCTestCase {
  let app = XCUIApplication()

  override func setUpWithError() throws {
    self.continueAfterFailure = false
  }

  func testBasics() async throws {
    self.app.launch()

    self.app.buttons["New Scrum"].tap()

    self.app.textFields["Title"].tap()
    self.app.typeText("Design")
    self.app.textFields["New Attendee"].tap()
    self.app.typeText("Blob")
    self.app.buttons["Add attendee"].tap()
    self.app.textFields["New Attendee"].tap()
    self.app.typeText("Blob Jr.")
    self.app.buttons["Add attendee"].tap()
    self.app.buttons["Add"].tap()

    XCTAssertTrue(self.app.cells.count >= 1)
    XCTAssertEqual(self.app.staticTexts["Engineering"].exists, true)

    XCUIDevice.shared.press(.home)
    self.app.launch()
    XCTAssertEqual(self.app.staticTexts["Engineering"].exists, true)
  }
}
