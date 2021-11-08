import Parsing
import SwiftUI

struct DeepLinkRequest {
  var pathComponents: ArraySlice<Substring>
  var queryItems: [String: ArraySlice<Substring?>]
}

extension DeepLinkRequest {
  init(url: URL) {
    let queryItems = URLComponents(url: url, resolvingAgainstBaseURL: false)?.queryItems ?? []

    self.init(
      pathComponents: url.path.split(separator: "/")[...],
      queryItems: queryItems.reduce(into: [:]) { dictionary, item in
        dictionary[item.name, default: []].append(item.value?[...])
      }
    )
  }
}

struct PathComponent<ComponentParser>: Parser
where
  ComponentParser: Parser,
  ComponentParser.Input == Substring
{
  let component: ComponentParser
  init(_ component: ComponentParser) {
    self.component = component
  }

  func parse(_ input: inout DeepLinkRequest) -> ComponentParser.Output? {
    guard
      var firstComponent = input.pathComponents.first,
      let output = self.component.parse(&firstComponent),
      firstComponent.isEmpty
    else { return nil }

    input.pathComponents.removeFirst()
    return output
  }
}

struct PathEnd: Parser {
  func parse(_ input: inout DeepLinkRequest) -> Void? {
    guard input.pathComponents.isEmpty
    else { return nil }
    return ()
  }
}

struct QueryItem<ValueParser>: Parser
where
  ValueParser: Parser,
  ValueParser.Input == Substring
{
  let name: String
  let valueParser: ValueParser
  
  init(_ name: String, _ valueParser: ValueParser) {
    self.name = name
    self.valueParser = valueParser
  }
  
  init(_ name: String) where ValueParser == Rest<Substring> {
    self.init(name, Rest())
  }
  
  func parse(_ input: inout DeepLinkRequest) -> ValueParser.Output? {
    guard
      let wrapped = input.queryItems[self.name]?.first,
      var value = wrapped,
      let output = self.valueParser.parse(&value),
      value.isEmpty
    else { return nil }
    
    input.queryItems[self.name]?.removeFirst()
    return output
  }
}

enum AppRoute {
  case one
  case inventory(InventoryRoute?)
  case three
}

enum InventoryRoute {
  case add(Item, ItemRoute? = nil)
  case row(Item.ID, RowRoute)

  enum RowRoute {
    case delete
    case duplicate
    case edit
  }
}

enum ItemRoute {
  case colorPicker
}

let item = QueryItem("name").orElse(Always(""))
  .take(QueryItem("quantity", Int.parser()).orElse(Always(1)))
  .map { name, quantity in
    Item(name: String(name), status: .inStock(quantity: quantity))
  }

let inventoryDeepLinker = PathEnd()
  .map { AppRoute.inventory(nil) }
  .orElse(
    PathComponent("add")
      .skip(PathEnd())
      .take(item)
      .map { .inventory(.add($0)) }
  )
  .orElse(
    PathComponent("add")
      .skip(PathComponent("colorPicker"))
      .skip(PathEnd())
      .take(item)
      .map { .inventory(.add($0, .colorPicker)) }
  )
  .orElse(
    PathComponent(UUID.parser())
      .skip(PathComponent("edit"))
      .skip(PathEnd())
      .map { id in .inventory(.row(id, .edit)) }
  )
  .orElse(
    PathComponent(UUID.parser())
      .skip(PathComponent("delete"))
      .skip(PathEnd())
      .map { id in .inventory(.row(id, .delete)) }
  )

let deepLinker = PathComponent("one")
  .skip(PathEnd())
  .map { AppRoute.one }
  .orElse(
    PathComponent("inventory")
      .take(inventoryDeepLinker)
  )
  .orElse(
    PathComponent("three")
      .skip(PathEnd())
      .map { .three }
  )

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
  
  func open(url: URL) {
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

extension InventoryViewModel {
  func navigate(to route: InventoryRoute?) {
    switch route {
    case let .add(item, .none):
      self.route = .add(.init(item: item))

    case let .add(item, .colorPicker):
      self.route = .add(.init(item: item, route: .colorPicker))

    case let .row(id, rowRoute):
      guard let viewModel = self.inventory[id: id]
      else { break }
      viewModel.navigate(to: rowRoute)

    case .none:
      self.route = nil
    }
  }
}

extension ItemRowViewModel {
  func navigate(to route: InventoryRoute.RowRoute) {
    switch route {
    case .delete:
      self.route = .deleteAlert
    case .duplicate:
      self.route = .duplicate(.init(item: self.item))
    case .edit:
      self.route = .edit(.init(item: self.item))
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
