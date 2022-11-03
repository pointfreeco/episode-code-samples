import AppFeature
import InventoryFeature
import ItemFeature
import ItemRowFeature
import Models
import SwiftUI

@main
struct InventoryApp: App {
  let model = AppModel(
    inventoryModel: InventoryModel(
      inventory: [
        ItemRowModel(
          item: Item(name: "Keyboard", color: .blue, status: .inStock(quantity: 100))
        ),
        ItemRowModel(
          item: Item(name: "Charger", color: .yellow, status: .inStock(quantity: 20))
        ),
        ItemRowModel(
          item: Item(name: "Phone", color: .green, status: .outOfStock(isOnBackOrder: true))
        ),
        ItemRowModel(
          item: Item(name: "Headphones", color: .red, status: .outOfStock(isOnBackOrder: false))
        ),
      ]
    )
  )

  var body: some Scene {
    let _ = print("Default item ids:")
    let _ = print(model.inventoryModel.inventory.map(\.id.uuidString).joined(separator: "\n"))
    WindowGroup {
      AppView(model: self.model)
        .onOpenURL { url in
          self.model.open(url: url)
        }
    }
  }
}
