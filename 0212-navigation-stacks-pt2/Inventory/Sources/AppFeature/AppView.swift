import InventoryFeature
import ItemFeature
import ItemRowFeature
import Models
import SwiftUI

public final class AppModel: ObservableObject {
  @Published public var inventoryModel: InventoryModel
  @Published var selectedTab: Tab

  public enum Tab {
    case one, inventory, three
  }

  public init(
    inventoryModel: InventoryModel = InventoryModel(),
    selectedTab: Tab = .one
  ) {
    self.inventoryModel = inventoryModel
    self.selectedTab = selectedTab
  }

  public func open(url: URL) {
    do {
      switch try appRouter.match(url: url) {
      case .one:
        self.selectedTab = .one

      case let .inventory(destination):
        self.selectedTab = .inventory
        self.inventoryModel.navigate(to: destination)

      case .three:
        self.selectedTab = .three
      }
    } catch {}
  }
}

public struct AppView: View {
  @ObservedObject var model: AppModel

  public init(model: AppModel) {
    self.model = model
  }

  public var body: some View {
    TabView(selection: self.$model.selectedTab) {
      Button("Go to 2nd tab") {
        self.model.selectedTab = .inventory
      }
      .tabItem { Text("One") }
      .tag(AppModel.Tab.one)

      InventoryView(model: self.model.inventoryModel)
        .tabItem { Text("Inventory") }
        .tag(AppModel.Tab.inventory)

      Text("Three")
        .tabItem { Text("Three") }
        .tag(AppModel.Tab.three)
    }
  }
}

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    AppView(model: AppModel(selectedTab: .inventory))
  }
}
