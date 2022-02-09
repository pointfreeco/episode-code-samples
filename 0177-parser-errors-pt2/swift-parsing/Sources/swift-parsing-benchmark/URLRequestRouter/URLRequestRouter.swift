#if compiler(>=5.5)
  import Foundation
  import Parsing

  struct URLRequestData {
    var body: ArraySlice<UInt8>?
    var headers: [String: Substring]
    var method: String?
    var path: ArraySlice<Substring>
    var query: [String: ArraySlice<Substring?>]

    init(
      method: String? = nil,
      path: ArraySlice<Substring> = [],
      query: [String: ArraySlice<Substring?>] = [:],
      headers: [String: Substring] = [:],
      body: ArraySlice<UInt8>? = nil
    ) {
      self.method = method
      self.path = path
      self.query = query
      self.headers = headers
      self.body = body
    }
  }

  struct Body<Parsers>: Parser
  where
    Parsers: Parser,
    Parsers.Input == ArraySlice<UInt8>
  {
    let bodyParser: Parsers

    @inlinable
    init(@ParserBuilder _ bodyParser: () -> Parsers) {
      self.bodyParser = bodyParser()
    }

    @inlinable
    func parse(_ input: inout URLRequestData) -> Parsers.Output? {
      guard
        var body = input.body,
        let output = self.bodyParser.parse(&body),
        body.isEmpty
      else { return nil }

      input.body = nil
      return output
    }
  }

  struct JSON<Value: Decodable>: Parser {
    let decoder: JSONDecoder

    @inlinable
    init(
      _ type: Value.Type,
      decoder: JSONDecoder = .init()
    ) {
      self.decoder = decoder
    }

    @inlinable
    func parse(_ input: inout ArraySlice<UInt8>) -> Value? {
      guard
        let output = try? decoder.decode(Value.self, from: Data(input))
      else { return nil }
      input = []
      return output
    }
  }

  struct Method: Parser {
    let name: String

    static let get = Self("GET")
    static let post = Self("POST")
    static let put = Self("PUT")
    static let patch = Self("PATCH")
    static let delete = Self("DELETE")

    @inlinable
    init(_ name: String) {
      self.name = name.uppercased()
    }

    @inlinable
    func parse(_ input: inout URLRequestData) -> Void? {
      guard input.method?.uppercased() == self.name else { return nil }
      input.method = nil
      return ()
    }
  }

  struct Path<Component>: Parser
  where
    Component: Parser,
    Component.Input == Substring
  {
    let componentParser: Component

    @inlinable
    init(_ component: Component) {
      self.componentParser = component
    }

    @inlinable
    func parse(_ input: inout URLRequestData) -> Component.Output? {
      guard
        var component = input.path.first,
        let output = self.componentParser.parse(&component),
        component.isEmpty
      else { return nil }

      input.path.removeFirst()
      return output
    }
  }

  struct PathEnd: Parser {
    @inlinable
    init() {}

    @inlinable
    func parse(_ input: inout URLRequestData) -> Void? {
      guard input.path.isEmpty
      else { return nil }
      return ()
    }
  }

  struct Query<Value>: Parser
  where
    Value: Parser,
    Value.Input == Substring
  {
    let defaultValue: Value.Output?
    let name: String
    let valueParser: Value

    @inlinable
    init(
      _ name: String,
      _ value: Value,
      default defaultValue: Value.Output? = nil
    ) {
      self.defaultValue = defaultValue
      self.name = name
      self.valueParser = value
    }

    @inlinable
    init(
      _ name: String,
      default defaultValue: Value.Output? = nil
    ) where Value == Rest<Substring> {
      self.init(
        name,
        Rest(),
        default: defaultValue
      )
    }

    @inlinable
    func parse(_ input: inout URLRequestData) -> Value.Output? {
      guard
        let wrapped = input.query[self.name]?.first,
        var value = wrapped,
        let output = self.valueParser.parse(&value),
        value.isEmpty
      else { return defaultValue }

      input.query[self.name]?.removeFirst()
      if input.query[self.name]?.isEmpty ?? true {
        input.query[self.name] = nil
      }
      return output
    }
  }

  struct Route<Parsers>: Parser
  where
    Parsers: Parser,
    Parsers.Input == URLRequestData
  {
    let parsers: Parsers

    @inlinable
    init<Upstream, Route>(
      _ transform: @escaping (Upstream.Output) -> Route,
      @ParserBuilder with parsers: () -> Upstream
    ) where Upstream.Input == URLRequestData, Parsers == Parsing.Parsers.Map<Upstream, Route> {
      self.parsers = parsers().map(transform)
    }

    @inlinable
    init<Upstream, Route>(
      _ route: Route,
      @ParserBuilder with parsers: () -> Upstream
    )
    where
      Upstream.Input == URLRequestData,
      Upstream.Output == Void,
      Parsers == Parsing.Parsers.Map<Upstream, Route>
    {
      self.parsers = parsers().map { route }
    }

    @inlinable
    init<Route>(_ route: Route) where Parsers == Always<URLRequestData, Route> {
      self.parsers = Always<URLRequestData, Route>(route)
    }

    @inlinable
    func parse(_ input: inout URLRequestData) -> Parsers.Output? {
      let original = input
      guard
        let output = self.parsers.parse(&input),
        input.path.isEmpty,
        input.method == nil || Method.get.parse(&input) != nil
      else {
        input = original
        return nil
      }
      return output
    }
  }
#endif
