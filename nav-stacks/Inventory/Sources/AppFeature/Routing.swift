import InventoryFeature
import Parsing
import URLRouting

enum AppRoute {
  case one
  case inventory(InventoryRoute?)
  case three
}

let appRouter = OneOf {
  Route(AppRoute.one) {
    Path { "one" }
  }

  Route(AppRoute.inventory) {
    Path { "inventory" }
    inventoryRouter
  }
  
  Route(AppRoute.three) {
    Path { "three" }
  }
}
