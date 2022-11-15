import Foundation
import ItemFeature
import Parsing
import URLRouting

public enum ItemRowRoute {
  case delete
  case duplicate
//  case edit
}

public let itemRowRouter = OneOf {
//  Route(ItemRowRoute.edit) {
//    Path { "edit" }
//  }

  Route(ItemRowRoute.delete) {
    Path { "delete" }
  }

  Route(ItemRowRoute.duplicate) {
    Path { "duplicate" }
  }
}

extension ItemRowModel {
  public func navigate(to route: ItemRowRoute) {
    switch route {
    case .delete:
      self.destination = .deleteConfirmationAlert
    case .duplicate:
      self.destination = .duplicate(ItemModel(item: self.item))
//    case .edit:
//      self.destination = .edit(ItemModel(item: self.item))
    }
  }
}
