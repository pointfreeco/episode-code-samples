
public enum Node {
  indirect case el(String, [(String, String)], [Node])
  case text(String)
}

extension Node: ExpressibleByStringLiteral {
  public init(stringLiteral value: String) {
    self = .text(value)
  }
}
public func header(_ children: [Node]) -> Node {
  return .el("header", [], children)
}
public func h1(_ children: [Node]) -> Node {
  return .el("h1", [], children)
}
public func ul(_ children: [Node]) -> Node {
  return .el("ul", [], children)
}
public func li(_ children: [Node]) -> Node {
  return .el("li", [], children)
}
public func p(_ attrs: [(String, String)], _ children: [Node]) -> Node {
  return .el("p", attrs, children)
}
public func a(_ attrs: [(String, String)], _ children: [Node]) -> Node {
  return .el("a", attrs, children)
}
public func img(_ attrs: [(String, String)]) -> Node {
  return .el("img", attrs, [])
}

public func id(_ value: String) -> (String, String) {
  return ("id", value)
}
public func href(_ value: String) -> (String, String) {
  return ("href", value)
}
public func src(_ value: String) -> (String, String) {
  return ("src", value)
}
public func width(_ value: Int) -> (String, String) {
  return ("width", "\(value)")
}
public func height(_ value: Int) -> (String, String) {
  return ("height", "\(value)")
}

public func render(_ node: Node) -> String {
  switch node {
  case let .el(tag, attrs, children):
    let formattedAttrs = attrs
      .map { key, value in "\(key)=\"\(value)\"" }
      .joined(separator: " ")
    let formattedChildren = children.map(render).joined()
    return "<\(tag) \(formattedAttrs)>\(formattedChildren)</\(tag)>"
  case let .text(string):
    return string
  }
}
