import Parsing
import SwiftUI

let deepLinker = AnyParser<URL, Tab> { url in
  switch url.path {
  case "/one":
    return .one
  case "/inventory":
    return .inventory
  case "/three":
    return .three
  default:
    return nil
  }
}

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
    
    var input = "123 hello"[...]
    let output = Int.parser().parse(&input) // 123
    input // " hello"
    
    self.inventoryViewModel = inventoryViewModel
    self.selectedTab = selectedTab
  }
  
  func open(url: URL) {
    var url = url
    if let tab = deepLinker.parse(&url) {
      self.selectedTab = tab
    }
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
    .onOpenURL { url in
      self.viewModel.open(url: url)
    }
  }
}

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    ContentView(viewModel: .init(selectedTab: .inventory))
  }
}
