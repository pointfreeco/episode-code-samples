enum Validated<Valid, Invalid> {
  case valid(Valid)
  case invalid([Invalid])
}

enum Node {
  case element(tag: String, attributes: [String: String], children: [Node])
  case text(content: String)
}

enum Loading<A> {
  case loading
  case loaded(A)
  case cancelled
}
