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
      $0.duplicateItem = ItemFormFeature.State(
        item: Item(
          id: UUID(uuidString: "00000000-0000-0000-0000-000000000000")!,
          name: "Headphones",
          color: .blue,
          status: .inStock(quantity: 20)
        )
      )
    }
    await store.send(.duplicateItem(.presented(.set(\.$item.name, "Bluetooth Headphones")))) {
      $0.duplicateItem?.item.name = "Bluetooth Headphones"
    }
    await store.send(.confirmDuplicateItemButtonTapped) {
      $0.duplicateItem = nil
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
      $0.addItem = ItemFormFeature.State(
        item: Item(
          id: UUID(uuidString: "00000000-0000-0000-0000-000000000000")!,
          name: "",
          status: .inStock(quantity: 1)
        )
      )
    }

    await store.send(.addItem(.presented(.set(\.$item.name, "Headphones")))) {
      $0.addItem?.item.name = "Headphones"
    }

    await store.send(.confirmAddItemButtonTapped) {
      $0.addItem = nil
      $0.items = [
        Item(
          id: UUID(uuidString: "00000000-0000-0000-0000-000000000000")!,
          name: "Headphones",
          status: .inStock(quantity: 1)
        )
      ]
    }
  }

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
      $0.addItem = ItemFormFeature.State(
        item: Item(
          id: UUID(uuidString: "00000000-0000-0000-0000-000000000000")!,
          name: "",
          status: .inStock(quantity: 1)
        )
      )
    }

    await store.send(.addItem(.presented(.set(\.$item.name, "Headphones")))) {
      $0.addItem?.item.name = "Headphones"
    }

    /*let toggleTask = */await store.send(.addItem(.presented(.set(\.$isTimerOn, true)))) {
      $0.addItem?.isTimerOn = true
    }

    //    await store.send(.addItem(.presented(.set(\.$isTimerOn, false)))) {
    //      $0.addItem?.isTimerOn = false
    //    }

    await store.send(.confirmAddItemButtonTapped) {
      $0.addItem = nil
      $0.items = [
        Item(
          id: UUID(uuidString: "00000000-0000-0000-0000-000000000000")!,
          name: "Headphones",
          status: .inStock(quantity: 1)
        )
      ]
    }

    //    await toggleTask.cancel()
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
      $0.addItem = ItemFormFeature.State(
        item: Item(
          id: UUID(uuidString: "00000000-0000-0000-0000-000000000000")!,
          name: "",
          status: .inStock(quantity: 1)
        )
      )
    }

    await store.send(.addItem(.presented(.set(\.$isTimerOn, true)))) {
      $0.addItem?.isTimerOn = true
    }
    await clock.advance(by: .seconds(3))
    await store.receive(.addItem(.presented(.timerTick))) {
      $0.addItem?.item.status = .inStock(quantity: 2)
    }
    await store.receive(.addItem(.presented(.timerTick))) {
      $0.addItem?.item.status = .inStock(quantity: 3)
    }
    await store.receive(.addItem(.presented(.timerTick))) {
      $0.addItem?.item.status = .inStock(quantity: 4)
    }
    await store.receive(.addItem(.dismiss)) {
      $0.addItem = nil
    }
  }

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
      $0.addItem = ItemFormFeature.State(
        item: Item(
          id: UUID(uuidString: "00000000-0000-0000-0000-000000000000")!,
          name: "",
          status: .inStock(quantity: 1)
        )
      )
    }

    await store.send(.addItem(.presented(.set(\.$isTimerOn, true)))) {
      $0.addItem?.isTimerOn = true
    }
    await store.receive(.addItem(.dismiss)) {
      $0.addItem = nil
    }
  }

  func testEditItem() async {
    let item = Item.headphones
    let store = TestStore(
      initialState: InventoryFeature.State(items: [item]),
      reducer: InventoryFeature()
    )

    await store.send(.itemButtonTapped(id: item.id)) {
      $0.editItem = ItemFormFeature.State(item: item)
    }
    await store.send(.editItem(.presented(.set(\.$item.name, "Bluetooth Headphones")))) {
      $0.editItem?.item.name = "Bluetooth Headphones"
    }
    await store.send(.editItem(.dismiss)) {
      $0.editItem = nil
      $0.items[0].name = "Bluetooth Headphones"
    }
  }

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
    await store.send(.editItem(.presented(.set(\.$isTimerOn, true))))
    await store.receive(.editItem(.dismiss)) {
      $0.editItem = nil
      $0.items[0].status = .inStock(quantity: 23)
    }
  }
}
