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
      $0.destination = .alert(.delete(item: item))
    }
    await store.send(.destination(.presented(.alert(.confirmDeletion(id: item.id))))) {
      $0.destination = nil
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
      $0.destination = .duplicateItem(
        ItemFormFeature.State(
          item: Item(
            id: UUID(uuidString: "00000000-0000-0000-0000-000000000000")!,
            name: "Headphones",
            color: .blue,
            status: .inStock(quantity: 20)
          )
        )
      )
    }
    await store.send(.destination(.presented(.duplicateItem(.set(\.$item.name, "Bluetooth Headphones"))))) {
//      guard case let .duplicateItem(&state) = $0.destination
//      else { XCTFail(); return }
//      state.item.name = "Bluetooth Headphones"

      XCTModify(&$0.destination, case: /InventoryFeature.Destination.State.duplicateItem) {
        $0.item.name = "Bluetooth Headphones"
      }
    }
    await store.send(.confirmDuplicateItemButtonTapped) {
      $0.destination = nil
      $0.items = [
        item,
        Item(
          id: UUID(uuidString: "00000000-0000-0000-0000-000000000000")!,
          name: "Bluetooth Headphones",
          color: .blue,
          status: .inStock(quantity: 20)
        )
      ]
    }
  }

  func testAddItem() async {
    let store = TestStore(
      initialState: InventoryFeature.State(),
      reducer: InventoryFeature()
    ) {
      $0.uuid = .incrementing
    }

    await store.send(.addButtonTapped) {
      $0.destination = .addItem(
        ItemFormFeature.State(
          item: Item(
            id: UUID(uuidString: "00000000-0000-0000-0000-000000000000")!,
            name: "",
            status: .inStock(quantity: 1)
          )
        )
      )
    }

    await store.send(.destination(.presented(.addItem(.set(\.$item.name, "Headphones"))))) {
      XCTModify(&$0.destination, case: /InventoryFeature.Destination.State.addItem) {
        $0.item.name = "Headphones"
      }
    }

    await store.send(.confirmAddItemButtonTapped) {
      $0.destination = nil
      $0.items = [
        Item(
          id: UUID(uuidString: "00000000-0000-0000-0000-000000000000")!,
          name: "Headphones",
          status: .inStock(quantity: 1)
        )
      ]
    }
  }
//
  func testAddItem_Timer() async {
    let clock = TestClock()
    let store = TestStore(
      initialState: InventoryFeature.State(),
      reducer: InventoryFeature()
    ) {
      $0.continuousClock = clock
      $0.uuid = .incrementing
    }

    await store.send(.addButtonTapped) {
      $0.destination = .addItem(
        ItemFormFeature.State(
          item: Item(
            id: UUID(uuidString: "00000000-0000-0000-0000-000000000000")!,
            name: "",
            status: .inStock(quantity: 1)
          )
        )
      )
    }

    await store.send(.destination(.presented(.addItem(.set(\.$item.name, "Headphones"))))) {
      XCTModify(&$0.destination, case: /InventoryFeature.Destination.State.addItem) {
        $0.item.name = "Headphones"
      }
    }

    await store.send(.destination(.presented(.addItem(.set(\.$isTimerOn, true))))) {
      XCTModify(&$0.destination, case: /InventoryFeature.Destination.State.addItem) {
        $0.isTimerOn = true
      }
    }

    await store.send(.confirmAddItemButtonTapped) {
      $0.destination = nil
      $0.items = [
        Item(
          id: UUID(uuidString: "00000000-0000-0000-0000-000000000000")!,
          name: "Headphones",
          status: .inStock(quantity: 1)
        )
      ]
    }
  }

  func testAddItem_Timer_Dismissal() async {
    let clock = TestClock()
    let store = TestStore(
      initialState: InventoryFeature.State(),
      reducer: InventoryFeature()
    ) {
      $0.continuousClock = clock
      $0.uuid = .incrementing
    }

    await store.send(.addButtonTapped) {
      $0.destination = .addItem(
        ItemFormFeature.State(
          item: Item(
            id: UUID(uuidString: "00000000-0000-0000-0000-000000000000")!,
            name: "",
            status: .inStock(quantity: 1)
          )
        )
      )
    }

    await store.send(.destination(.presented(.addItem(.set(\.$isTimerOn, true))))) {
      XCTModify(&$0.destination, case: /InventoryFeature.Destination.State.addItem) {
        $0.isTimerOn = true
      }
    }
    await clock.advance(by: .seconds(3))
    await store.receive(.destination(.presented(.addItem(.timerTick)))) {
      XCTModify(&$0.destination, case: /InventoryFeature.Destination.State.addItem) {
        $0.item.status = .inStock(quantity: 2)
      }
    }
    await store.receive(.destination(.presented(.addItem(.timerTick)))) {
      XCTModify(&$0.destination, case: /InventoryFeature.Destination.State.addItem) {
        $0.item.status = .inStock(quantity: 3)
      }
    }
    await store.receive(.destination(.presented(.addItem(.timerTick)))) {
      XCTModify(&$0.destination, case: /InventoryFeature.Destination.State.addItem) {
        $0.item.status = .inStock(quantity: 4)
      }
    }
    await store.receive(.destination(.dismiss)) {
      $0.destination = nil
    }
  }
//
  func testAddItem_Timer_Dismissal_NonExhaustive() async {
    let store = TestStore(
      initialState: InventoryFeature.State(),
      reducer: InventoryFeature()
    ) {
      $0.continuousClock = ImmediateClock()
      $0.uuid = .incrementing
    }

    store.exhaustivity = .off(showSkippedAssertions: true)

    await store.send(.addButtonTapped) {
      $0.destination = .addItem(
        ItemFormFeature.State(
          item: Item(
            id: UUID(uuidString: "00000000-0000-0000-0000-000000000000")!,
            name: "",
            status: .inStock(quantity: 1)
          )
        )
      )
    }

    await store.send(.destination(.presented(.addItem(.set(\.$isTimerOn, true)))))
    await store.receive(.destination(.dismiss)) {
      $0.destination = nil
    }
  }
//
  func testEditItem() async {
    let item = Item.headphones
    let store = TestStore(
      initialState: InventoryFeature.State(items: [item]),
      reducer: InventoryFeature()
    )

    await store.send(.itemButtonTapped(id: item.id)) {
      $0.destination = .editItem(ItemFormFeature.State(item: item))
    }
    await store.send(.destination(.presented(.editItem(.set(\.$item.name, "Bluetooth Headphones"))))) {
      XCTModify(&$0.destination, case: /InventoryFeature.Destination.State.editItem) {
        $0.item.name = "Bluetooth Headphones"
      }
    }
    await store.send(.destination(.dismiss)) {
      $0.destination = nil
      $0.items[0].name = "Bluetooth Headphones"
    }
  }
//
  func testEditItem_Timer() async {
    let item = Item.headphones
    let store = TestStore(
      initialState: InventoryFeature.State(items: [item]),
      reducer: InventoryFeature()
    ) {
      $0.continuousClock = ImmediateClock()
    }
    store.exhaustivity = .off(showSkippedAssertions: true)

    await store.send(.itemButtonTapped(id: item.id))
    await store.send(.destination(.presented(.editItem(.set(\.$isTimerOn, true)))))
    await store.receive(.destination(.dismiss)) {
      $0.destination = nil
      $0.items[0].status = .inStock(quantity: 23)
    }
  }

  func testDismiss() async {
    let store = TestStore(
      initialState: InventoryFeature.State(
        destination: .addItem(ItemFormFeature.State(item: .headphones))
      ),
      reducer: InventoryFeature()
    )

    await store.send(.destination(.presented(.addItem(.dismissButtonTapped)))) {
      $0.destination = nil
    }
//    await store.receive(.destination(.dismiss)) {
//      $0.destination = nil
//    }
  }
}
