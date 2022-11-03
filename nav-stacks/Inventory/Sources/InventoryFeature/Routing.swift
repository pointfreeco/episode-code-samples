import Foundation
import ItemFeature
import ItemRowFeature
import Models
import Parsing
import URLRouting

public enum InventoryRoute {
  case add(Item, ItemRoute? = nil)
  case row(Item.ID, ItemRowRoute)
}

public enum ItemRoute {
  case colorPicker
}

let item = Parse { name, quantity in
  Item(name: String(name), status: .inStock(quantity: quantity))
} with: {
  Query {
    Field("name", .string, default: "")
    Field("quantity", default: 1) { Digits() }
  }
}

public let inventoryRouter = OneOf {
  Route(InventoryRoute?.none)

  Route { Optional(InventoryRoute.add($0)) } with: {
    Path { "add" }
    item
  }

  Route { Optional(InventoryRoute.add($0, .colorPicker)) } with: {
    Path { "add"; "colorPicker" }
    item
  }

  Route { Optional(InventoryRoute.row($0, $1)) } with: {
    Path { UUID.parser() }
    itemRowRouter
  }
}

extension InventoryModel {
  public func navigate(to route: InventoryRoute?) {
    switch route {
    case let .add(item, .none):
      self.destination = .add(ItemModel(item: item))

    case let .add(item, .colorPicker):
      self.destination = .add(ItemModel(destination: .colorPicker, item: item))

    case let .row(id, rowRoute):
      guard let model = self.inventory[id: id]
      else { break }
      model.navigate(to: rowRoute)

    case .none:
      self.destination = nil
    }
  }
}
