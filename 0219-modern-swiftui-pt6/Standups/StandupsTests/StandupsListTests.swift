import Dependencies
import XCTest

@testable import Standups

@MainActor
class StandupsListTests: XCTestCase {
  override func setUp() {
    super.setUp()
    try? FileManager.default.removeItem(at: .documentsDirectory.appending(component: "standups.json"))
  }

  func testPersistence() async throws {
    let mainQueue = DispatchQueue.test
    DependencyValues.withTestValues {
      $0.mainQueue = mainQueue.eraseToAnyScheduler()
    } assert: {
      let listModel = StandupsListModel()

      XCTAssertEqual(listModel.standups.count, 0)

      listModel.addStandupButtonTapped()
      listModel.confirmAddStandupButtonTapped()
      XCTAssertEqual(listModel.standups.count, 1)

      mainQueue.run()

      let nextLaunchListModel = StandupsListModel()
      XCTAssertEqual(nextLaunchListModel.standups.count, 1)
    }
  }
}
