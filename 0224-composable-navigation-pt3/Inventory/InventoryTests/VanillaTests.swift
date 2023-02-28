import XCTest

@testable import Inventory

class VanillaTests: XCTestCase {
  func testFirstTabModel() {
    let model = FirstTabModel()

//    let expectation = self.expectation(description: "switchToInventoryTab")
    model.switchToInventoryTab = {
//      expectation.fulfill()
    }

    model.goToInventoryTab()
//    self.wait(for: [expectation], timeout: 0)
  }

  func testAppModel() {
    let model = AppModel(
      firstTab: FirstTabModel()
    )

    model.firstTab.goToInventoryTab()
//    XCTAssertEqual(model.selectedTab, .inventory)
  }
}
