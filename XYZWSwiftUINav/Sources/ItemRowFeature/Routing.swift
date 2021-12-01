import ParserHelpers
import Parsing

public enum ItemRowRoute {
  case delete
  case duplicate
  case edit
}

public let itemRowDeepLinker = PathComponent("edit")
  .skip(PathEnd())
  .map { id in ItemRowRoute.edit }
  .orElse(
    PathComponent("delete")
      .skip(PathEnd())
      .map { id in .delete }
  )
  .orElse(
    PathComponent("duplicate")
      .skip(PathEnd())
      .map { id in .duplicate }
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
