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

let item = QueryItem("name").orElse(Always(""))
  .take(QueryItem("quantity", Int.parser()).orElse(Always(1)))
  .map { name, quantity in
    Item(name: String(name), status: .inStock(quantity: quantity))
  }

public let inventoryDeepLinker = PathEnd() // /
  .map { InventoryRoute?.none }
  .orElse(
    PathComponent("add")
      .skip(PathEnd())
      .take(item)
      .map { .add($0) }
  )
  .orElse(
    PathComponent("add")
      .skip(PathComponent("colorPicker"))
      .skip(PathEnd())
      .take(item)
      .map { .add($0, .colorPicker) }
  )
  .orElse(
    PathComponent(UUID.parser())
      .take(itemRowDeepLinker)
      .map(InventoryRoute.row)
  )

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
