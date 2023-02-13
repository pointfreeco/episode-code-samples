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
}
