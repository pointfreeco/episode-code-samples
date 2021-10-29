import Parsing
import SwiftUI

struct DeepLinkRequest {
  var pathComponents: ArraySlice<Substring>
  var queryItems: [String: ArraySlice<Substring?>]
  // ?name=Blob&name=BlobJr&isAdmin
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

struct PathComponent: Parser {
  let component: String
  init(_ component: String) {
    self.component = component
  }

  func parse(_ input: inout DeepLinkRequest) -> Void? {
    guard input.pathComponents.first == self.component[...]
    else { return nil }

    input.pathComponents.removeFirst()
    return ()
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
}

enum ItemRoute {
  case colorPicker
}

let item = QueryItem("name").orElse(Always(""))
  .take(QueryItem("quantity", Int.parser()).orElse(Always(1)))
  .map { name, quantity in
    Item(name: String(name), status: .inStock(quantity: quantity))
  }

let deepLinker = PathComponent("one")
  .skip(PathEnd())
  .map { AppRoute.one }
  .orElse(
    PathComponent("inventory")
      .skip(PathEnd())
      .map { .inventory(nil) }
  )
  .orElse(
    PathComponent("inventory")
      .skip(PathComponent("add"))
      .skip(PathEnd())
      .take(item)
      .map { .inventory(.add($0)) }
  )
  .orElse(
    PathComponent("inventory")
      .skip(PathComponent("add"))
      .skip(PathComponent("colorPicker"))
      .skip(PathEnd())
      .take(item)
      .map { .inventory(.add($0, .colorPicker)) }
  )
  .orElse(
    PathComponent("three")
      .skip(PathEnd())
      .map { .three }
  )

// nav:///inventory/add/colorPicker
// nav:///inventory/add?quantity=100&name=Keyboard

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

    case .none:
      self.route = nil
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
