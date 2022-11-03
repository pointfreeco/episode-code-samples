import CasePaths
import XCTest

@testable import InventoryFeature
@testable import ItemFeature
@testable import ItemRowFeature
@testable import Models

class InventoryFeatureTests: XCTestCase {
  func testAdd() throws {
    let model = InventoryModel()

    model.addButtonTapped()

    let addItemModel = try XCTUnwrap(
      (/InventoryModel.Destination.add).extract(from: XCTUnwrap(model.destination))
    )

    XCTAssertEqual(model.destination, .add(addItemModel))

    addItemModel.item.name = "Headphones"
    addItemModel.item.status = .outOfStock(isOnBackOrder: false)

    model.confirmAdd(item: addItemModel.item)

    XCTAssertEqual(model.inventory.count, 1)
    XCTAssertEqual(model.inventory[0].item.name, "Headphones")
    XCTAssertEqual(model.inventory[0].item.status, .outOfStock(isOnBackOrder: false))
    XCTAssertEqual(model.destination, nil)
  }

  func testDuplicate() throws {
    let headphones = Item.headphones
    let model = InventoryModel(
      inventory: [
        ItemRowModel(item: headphones)
      ]
    )

    model.inventory[0].duplicateButtonTapped()

    let duplicateItemModel = try XCTUnwrap(
      (/ItemRowModel.Destination.duplicate).extract(from: XCTUnwrap(model.inventory[0].destination))
    )

    XCTAssertEqual(duplicateItemModel.item.name, headphones.name)

    duplicateItemModel.item.name = "Bluetooth \(duplicateItemModel.item.name)"

    model.inventory[0].commitDuplicate()

    XCTAssertEqual(model.inventory.count, 2)
    XCTAssertEqual(model.inventory[1].item, duplicateItemModel.item)
    XCTAssertEqual(model.destination, nil)
  }

  func testEdit() async throws {
    let headphones = Item.headphones
    let model = InventoryModel(
      inventory: [
        ItemRowModel(item: headphones)
      ]
    )

    model.inventory[0].setEditNavigation(isActive: true)

    let editItemModel = try XCTUnwrap(
      (/ItemRowModel.Destination.edit).extract(from: XCTUnwrap(model.inventory[0].destination))
    )

    XCTAssertEqual(editItemModel.item.id, headphones.id)

    editItemModel.item.name = "Bluetooth \(editItemModel.item.name)"

    await model.inventory[0].commitEdit()

    XCTAssertEqual(model.inventory.count, 1)
    XCTAssertEqual(model.inventory[0].item, editItemModel.item)
    XCTAssertEqual(model.destination, nil)
  }

  func testCancel() throws {
    let model = InventoryModel()

    model.addButtonTapped()
    XCTAssertNotNil(model.destination)
    model.cancelAddButtonTapped()
    XCTAssertNil(model.destination)
  }

  func testDelete() throws {
    let headphones = Item.headphones
    let model = InventoryModel(
      inventory: [ItemRowModel(item: headphones)]
    )

    model.inventory[0].deleteButtonTapped()

    XCTAssertEqual(model.inventory[0].destination, .deleteConfirmationAlert)

    model.inventory[0].deleteConfirmationButtonTapped()
    XCTAssertEqual(model.inventory, [])
    XCTAssertEqual(model.destination, nil)
  }
}
