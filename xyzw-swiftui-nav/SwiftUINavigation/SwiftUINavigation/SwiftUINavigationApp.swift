import SwiftUI

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
        route: .row(
          id: keyboard.id,
          route: .edit(
            .init(
              item: keyboard,
              route: nil
            )
          )
        )
      ),
      selectedTab: .inventory
    )

    return WindowGroup {
      //      ContentView(viewModel: viewModel)
//      Representable(
//        viewController: ContentViewController(viewModel: viewModel)
//      )
      RootView(viewModel: viewModel)
      .onOpenURL(perform: viewModel.open(url:))
    }
  }
}

struct RootView: View {
  @State var useSwiftUI = true
  let viewModel: AppViewModel

  var body: some View {
    ZStack(alignment: .top) {
      Group {
        if self.useSwiftUI {
          ContentView(viewModel: viewModel)
        } else {
          Representable(
            viewController: ContentViewController(viewModel: self.viewModel)
          )
        }
      }
      .padding(.top, 44)
      .onOpenURL(perform: self.viewModel.open(url:))

      Button(self.useSwiftUI ? "Use UIKit" : "Use SwiftUI") {
        self.useSwiftUI.toggle()
      }
    }
  }
}

struct Root_Previews: PreviewProvider {
  static var previews: some View {
    RootView(viewModel: .init())
  }
}
