import AppFeature
import InventoryFeature
import ItemFeature
import ItemRowFeature
import Models
import SwiftUI


class NestedModel: ObservableObject {
  @Published var child: NestedModel?
  init(child: NestedModel? = nil) {
    self.child = child
  }
}


struct NestedView: View {
  @ObservedObject var model: NestedModel

  var body: some View {
    NavigationLink(
      unwrapping: self.$model.child
    ) { isActive in
      self.model.child = isActive ? NestedModel() : nil
    } destination: { $child in
      NestedView(model: child)
    } label: {
      Text("Go to child feature")
    }
  }
}


let lastItem = Item(
  name: "Headphones",
  color: .red,
  status: .outOfStock(isOnBackOrder: false)
)


@main
struct InventoryApp: App {
  let model = AppModel(
    inventoryModel: InventoryModel(
//      destination: .add(
//        ItemModel(
//          destination: .colorPicker,
//          item: Item(
//            name: "Ergnomic Keyboard",
//            status: .inStock(quantity: 100)
//          )
//        )
//      ),
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
        ItemRowModel(
          destination: .edit(ItemModel(item: lastItem)),
          item: lastItem
        )
      ]
    ),
    selectedTab: .inventory
  )

  var body: some Scene {
    let _ = print("Default item ids:")
    let _ = print(model.inventoryModel.inventory.map(\.id.uuidString).joined(separator: "\n"))
    WindowGroup {
      AppView(model: self.model)
        .onOpenURL { url in
          self.model.open(url: url)
        }

//      NavigationView {
//        NestedView(
//          model: NestedModel(
//            child: NestedModel(
//              child: NestedModel(
//                child: NestedModel(
//                  child: NestedModel(
//                    child: NestedModel(
//                      child: .init()
//                    )
//                  )
//                )
//              )
//            )
//          )
//        )
//      }
//      .navigationViewStyle(.stack)
    }
  }
}



/*
                                 |-------|
                                 |   U   |
                 |-------|       |   s   |
                 |   I   |       |   e   |-------|
         |-------|   n   |       |   r   |   S   |
         |   I   |   v   |-------|   P   |   e   |
         |   t   |   e   |   S   |   r   |   t   |
 |-------|   e   |   n   |   e   |   o   |   t   |
 |   I   |   m   |   t   |   a   |   f   |   i   |    ...
 |   t   |   R   |   o   |   r   |   i   |   n   |
 |   e   |   o   |   r   |   c   |   l   |   g   |
 |   m   |   w   |   y   |   h   |   e   |   s   |
 |-------|-------|-------|-------|-------|------*/
/*--------------------------------------------------------|
|                                                         |
|            MODEL/HELPER/DEPENDENCY MODULES              |
|                                                         |
|      |---------------|-----------|---------------|      |
|      |    Models     | ApiClient | ApiClientLive |      |
|      |---------------|-----------|---------------|      |
|                                                         |
|---------------------------------------------------------|
*/
