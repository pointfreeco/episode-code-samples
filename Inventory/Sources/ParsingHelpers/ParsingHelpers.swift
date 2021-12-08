import Foundation
import Parsing

public struct DeepLinkRequest {
  var pathComponents: ArraySlice<Substring>
  var queryItems: [String: ArraySlice<Substring?>]
}

extension DeepLinkRequest {
  public init(url: URL) {
    let queryItems = URLComponents(url: url, resolvingAgainstBaseURL: false)?.queryItems ?? []

    self.init(
      pathComponents: url.path.split(separator: "/")[...],
      queryItems: queryItems.reduce(into: [:]) { dictionary, item in
        dictionary[item.name, default: []].append(item.value?[...])
      }
    )
  }
}

public struct PathComponent<ComponentParser>: Parser
where
  ComponentParser: Parser,
  ComponentParser.Input == Substring
{
  let component: ComponentParser
  public init(_ component: ComponentParser) {
    self.component = component
  }

  public func parse(_ input: inout DeepLinkRequest) -> ComponentParser.Output? {
    guard
      var firstComponent = input.pathComponents.first,
      let output = self.component.parse(&firstComponent),
      firstComponent.isEmpty
    else { return nil }

    input.pathComponents.removeFirst()
    return output
  }
}

public struct PathEnd: Parser {
  public init() {}

  public func parse(_ input: inout DeepLinkRequest) -> Void? {
    guard input.pathComponents.isEmpty
    else { return nil }
    return ()
  }
}

public struct QueryItem<ValueParser>: Parser
where
  ValueParser: Parser,
  ValueParser.Input == Substring
{
  let name: String
  let valueParser: ValueParser

  public init(_ name: String, _ valueParser: ValueParser) {
    self.name = name
    self.valueParser = valueParser
  }

  public init(_ name: String) where ValueParser == Rest<Substring> {
    self.init(name, Rest())
  }

  public func parse(_ input: inout DeepLinkRequest) -> ValueParser.Output? {
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
