import CasePaths
import ItemFeature
import ItemRowFeature
import XCTest

@testable import ItemRowFeature
@testable import Models

class ItemRowFeatureTests: XCTestCase {
  func testDelete() {
    let model = ItemRowModel(item: .headphones)

    let expectation = self.expectation(description: "commitDeletion")
    model.commitDeletion = {
      expectation.fulfill()
    }

    model.deleteButtonTapped()
    XCTAssertEqual(model.destination, .deleteConfirmationAlert)

    model.deleteConfirmationButtonTapped()
    XCTAssertEqual(model.destination, nil)

    self.wait(for: [expectation], timeout: 0)
  }

  func testEdit() {
    let model = ItemRowModel(item: .headphones)
    let expectation = self.expectation(description: "onTap")
    model.onTap = {
      expectation.fulfill()
    }

    model.rowTapped()
    self.wait(for: [expectation], timeout: 0)
  }

  func testDuplicate() throws {
    let model = ItemRowModel(item: .headphones)

    let expectation = self.expectation(description: "commitDeletion")
    model.commitDuplication = { _ in
      expectation.fulfill()
    }

    model.duplicateButtonTapped()

    let duplicateModel = try XCTUnwrap(
      (/ItemRowModel.Destination.duplicate).extract(from: XCTUnwrap(model.destination))
    )

    XCTAssertEqual(
      (/ItemRowModel.Destination.duplicate).extract(from: try XCTUnwrap(model.destination))?.item,
      duplicateModel.item
    )

    model.commitDuplicate()
    XCTAssertNil(model.destination)

    self.wait(for: [expectation], timeout: 0)
  }
}
