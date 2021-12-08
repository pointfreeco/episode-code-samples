import InventoryFeature
import ItemFeature
import ItemRowFeature
import Models
import Parsing
import ParsingHelpers
import SwiftUI

enum AppRoute {
  case one
  case inventory(InventoryRoute?)
  case three
}

let deepLinker = PathComponent("one")
  .skip(PathEnd())
  .map { AppRoute.one }
  .orElse(
    PathComponent("inventory")
      .take(inventoryDeepLinker)
      .map(AppRoute.inventory)
  )
  .orElse(
    PathComponent("three")
      .skip(PathEnd())
      .map { .three }
  )

public enum Tab {
  case one, inventory, three
}

public class AppViewModel: ObservableObject {
  @Published var inventoryViewModel: InventoryViewModel
  @Published var selectedTab: Tab

  public init(
    inventoryViewModel: InventoryViewModel = .init(),
    selectedTab: Tab = .one
  ) {
    self.inventoryViewModel = inventoryViewModel
    self.selectedTab = selectedTab
  }
  
  public func open(url: URL) {
    var request = DeepLinkRequest(url: url)
    if let route = deepLinker.parse(&request) {
      switch route {
      case .one:
        self.selectedTab = .one

      case let .inventory(inventoryRoute):
        self.selectedTab = .inventory
        self.inventoryViewModel.navigate(to: inventoryRoute)

      case .three:
        self.selectedTab = .three
      }
    }
  }
}

public struct ContentView: View {
  @ObservedObject var viewModel: AppViewModel
  
  public init(viewModel: AppViewModel) {
    self.viewModel = viewModel
  }

  public var body: some View {
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
