import Foundation
import Parsing
import ParsingHelpers

public enum ItemRowRoute {
  case delete
  case duplicate
  case edit
}

public let itemRowDeepLinker = OneOf {
  Routing({ ItemRowRoute.edit }) {
    PathComponent("edit")
  }

  Routing({ ItemRowRoute.delete }) {
    PathComponent("delete")
  }

  Routing({ ItemRowRoute.duplicate }) {
    PathComponent("duplicate")
  }
}

extension ItemRowViewModel {
  public func navigate(to route: ItemRowRoute) {
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
