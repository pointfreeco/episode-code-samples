import ItemRowFeature
import Models
import SwiftUI

@main
struct ItemRowPreviewAppApp: App {
  let model = ItemRowModel(
    item: Item(
      name: "Keyboard",
      color: .blue,
      status: .inStock(quantity: 1)
    )
  )

  var body: some Scene {
    WindowGroup {
      NavigationStack {
        List {
          ItemRowView(model: self.model)
        }
      }
      .onOpenURL { url in
        do {
          try self.model.navigate(to: itemRowRouter.match(url: url))
        } catch {}
      }
    }
  }
}
