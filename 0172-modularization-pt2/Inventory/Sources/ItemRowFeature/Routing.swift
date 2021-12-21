import Foundation
import Parsing
import ParsingHelpers

public enum ItemRowRoute {
  case delete
  case duplicate
  case edit
}

// nav:///inventory/:uuid/edit/colorPicker?

public let itemRowDeepLinker = PathComponent("edit")
  .skip(PathEnd())
  .map { ItemRowRoute.edit }
  .orElse(
    PathComponent("delete")
      .skip(PathEnd())
      .map { .delete }
  )
  .orElse(
    PathComponent("duplicate")
      .skip(PathEnd())
      .map { .duplicate }
  )

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
