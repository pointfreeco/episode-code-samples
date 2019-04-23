
enum Validated<Valid, Invalid> {
  case valid(Valid)
  case invalid([Invalid])
}

enum Node {
  case element(tag: String, attributes: [String: String], children: [Node])
  case text(content: String)
}

enum Fetched<A> {
  case cancelled
  case data(A)
  case failed
  case loading
}
