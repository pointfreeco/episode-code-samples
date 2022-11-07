import XCTest

@testable import ItemFeature
@testable import Models

class ItemFeatureTests: XCTestCase {
  func testNavigation() {
    let model = ItemModel(item: .headphones)

    model.setColorPickerNavigation(isActive: true)
    XCTAssertEqual(model.destination, .colorPicker)

    model.setColorPickerNavigation(isActive: false)
    XCTAssertEqual(model.destination, nil)
  }
}
