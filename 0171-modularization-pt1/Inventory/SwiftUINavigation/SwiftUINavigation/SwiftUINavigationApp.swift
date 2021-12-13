import AppFeature
import InventoryFeature
import ItemRowFeature
import Models
import SwiftUI
import SwiftUIHelpers

@main
struct SwiftUINavigationApp: App {
  var body: some Scene {
    let keyboard = Item(name: "Keyboard", color: .blue, status: .inStock(quantity: 100))

    var editedKeyboard = keyboard
    editedKeyboard.name = "Bluetooth Keyboard"
    editedKeyboard.status = .inStock(quantity: 1000)

    let viewModel = AppViewModel(
      inventoryViewModel: .init(
        inventory: [
          .init(item: keyboard),
          .init(item: Item(name: "Charger", color: .yellow, status: .inStock(quantity: 20))),
          .init(item: Item(name: "Phone", color: .green, status: .outOfStock(isOnBackOrder: true))),
          .init(item: Item(name: "Headphones", color: .green, status: .outOfStock(isOnBackOrder: false))),
        ],
        route: nil
      ),
      selectedTab: .one
    )

    return WindowGroup {
      RootView(viewModel: viewModel)
    }
  }
}

struct RootView: View {
  @State var isSwiftUI = true
  let viewModel: AppViewModel

  var body: some View {
    ZStack(alignment: .top) {
      Group {
        if self.isSwiftUI {
          ContentView(viewModel: self.viewModel)
        } else {
          ToSwiftUI {
            ContentViewController(viewModel: self.viewModel)
          }
          .onOpenURL { url in
            self.viewModel.open(url: url)
          }
        }
      }
      .padding(.top, 44)

      Button(self.isSwiftUI ? "Use UIKit" : "Use SwiftUI") {
        self.isSwiftUI.toggle()
      }
    }
  }
}
