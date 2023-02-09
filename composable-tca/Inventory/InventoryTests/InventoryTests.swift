import ComposableArchitecture
import XCTest
@testable import Inventory

@MainActor
final class InventoryTests: XCTestCase {
  func testGoToInventory() async {
    let store = TestStore(
      initialState: AppFeature.State(),
      reducer: AppFeature()
    )

    await store.send(.firstTab(.goToInventoryButtonTapped))
    await store.receive(.firstTab(.delegate(.switchToInventoryTab))) {
      $0.selectedTab = .inventory
    }
  }

  func testDelete() async {
    let item = Item.headphones

    let store = TestStore(
      initialState: InventoryFeature.State(items: [item]),
      reducer: InventoryFeature()
    )

    await store.send(.deleteButtonTapped(id: item.id)) {
      $0.alert = .delete(item: item)
    }
    await store.send(.alert(.presented(.confirmDeletion(id: item.id)))) {
      $0.alert = nil
      $0.items = []
    }
  }

  func testDuplicate() async {
    let item = Item.headphones

    let store = TestStore(
      initialState: InventoryFeature.State(items: [item]),
      reducer: InventoryFeature()
    ) {
      $0.uuid = .incrementing
    }

    await store.send(.duplicateButtonTapped(id: item.id)) {
      $0.confirmationDialog = .duplicate(item: item)
    }
    await store.send(.confirmationDialog(.presented(.confirmDuplication(id: item.id)))) {
      $0.confirmationDialog = nil
      $0.items = [
        Item(
          id: UUID(uuidString: "00000000-0000-0000-0000-000000000000")!,
          name: "Headphones",
          color: .blue,
          status: .inStock(quantity: 20)
        ),
        item
      ]
    }
  }
}
