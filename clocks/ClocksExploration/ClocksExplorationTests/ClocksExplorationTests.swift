import XCTest
@testable import ClocksExploration

@MainActor
final class ClocksExplorationTests: XCTestCase {
  func testWelcome() async {
    let model = FeatureModel()

    XCTAssertEqual(model.message, "")
    await model.task()
    XCTAssertEqual(model.message, "Welcome!")
  }
}
