import Foundation
import ItemRowFeature
import Models
import Parsing
import ParsingHelpers

public enum InventoryRoute {
  case add(Item, ItemRoute? = nil)
  case row(Item.ID, ItemRowRoute)
}

public enum ItemRoute {
  case colorPicker
}

let item = Routing({ Item(name: $0, status: $1) }) {
  QueryItem("name")
    .orElse(Always(""))
    .map(String.init)

  QueryItem("quantity", Int.parser())
    .orElse(Always(1))
    .map(Item.Status.inStock)
}

let _inventoryDeepLinker = OneOf {
  Parse {
    PathComponent("add")

    OneOf {
      Routing({ InventoryRoute.add($0) }) {
        item
      }

      Routing({ InventoryRoute.add($0, .colorPicker) }) {
        PathComponent("colorPicker")
        item
      }
    }
  }

  Routing(InventoryRoute.row) {
    PathComponent(UUID.parser())
    itemRowDeepLinker
  }
}

public let inventoryDeepLinker = OneOf {
  PathEnd().map { InventoryRoute?.none }

  Routing(InventoryRoute?.some) {
    _inventoryDeepLinker
  }
}

extension InventoryViewModel {
  public func navigate(to route: InventoryRoute?) {
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
