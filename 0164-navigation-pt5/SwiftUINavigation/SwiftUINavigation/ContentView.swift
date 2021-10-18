import SwiftUI

enum Tab {
  case one, inventory, three
}

class AppViewModel: ObservableObject {
  @Published var inventoryViewModel: InventoryViewModel
  @Published var selectedTab: Tab

  init(
    inventoryViewModel: InventoryViewModel = .init(),
    selectedTab: Tab = .one
  ) {
    self.inventoryViewModel = inventoryViewModel
    self.selectedTab = selectedTab
  }
}

struct ContentView: View {
  @ObservedObject var viewModel: AppViewModel

  var body: some View {
    TabView(selection: self.$viewModel.selectedTab) {
      Button("Go to 2nd tab") {
        self.viewModel.selectedTab = .inventory
      }
        .tabItem { Text("One") }
        .tag(Tab.one)

      NavigationView {
        InventoryView(viewModel: self.viewModel.inventoryViewModel)
      }
        .tabItem { Text("Inventory") }
        .tag(Tab.inventory)

      Text("Three")
        .tabItem { Text("Three") }
        .tag(Tab.three)
    }
  }
}

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    ContentView(viewModel: .init(selectedTab: .inventory))
  }
}
