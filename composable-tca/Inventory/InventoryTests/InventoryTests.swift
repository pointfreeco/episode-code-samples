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
}
