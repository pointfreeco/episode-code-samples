import Benchmark
import Foundation
import Parsing

/*
 This benchmark demonstrates how you can build a URL request router that can transform an input
 request into a more well-structured data type, such as an enum. We build a router that can
 recognize one of 5 routes for a website.
 */

private struct Route<Parsers, NewOutput>: Parser
where
  Parsers: Parser,
  Parsers.Input == RequestData
{
  let transform: (Parsers.Output) -> NewOutput
  let parsers: Parsers
  init(
    _ transform: @escaping (Parsers.Output) -> NewOutput,
    @ParserBuilder parsers: () -> Parsers
  ) {
    self.transform = transform
    self.parsers = parsers()
  }
  init(
    _ newOutput: NewOutput,
    @ParserBuilder parsers: () -> Parsers
  )
  where Parsers.Output == Void
  {
    self.init({ newOutput }, parsers: parsers)
  }
  init(
    @ParserBuilder parsers: () -> Parsers
  )
  where Parsers.Output == NewOutput
  {
    self.transform = { $0 }
    self.parsers = parsers()
  }
  init(_ newOutput: NewOutput) where Parsers == Always<Input, Void> {
    self.init({ newOutput }, parsers: { Always<Input, Void>(()) })
  }
  func parse(_ input: inout Parsers.Input) -> NewOutput? {
    let original = input
    guard
      let output = self.parsers.parse(&input).map(transform),
      input.pathComponents.isEmpty,
      input.method == nil || input.method == "GET"
    else {
      input = original
      return nil
    }
    return output
  }
}


let routingSuite = BenchmarkSuite(name: "Routing") { suite in
  enum AppRoute: Equatable {
    case home
    case contactUs
    case episodes(Episodes)
  }
  enum Episodes: Equatable {
    case root
    case episode(id: Int, Episode)
  }
  enum Episode: Equatable {
    case root
    case comments
  }

  AppRoute.episodes(.episode(id: 42, .comments))

  let episodeRouter = OneOf {
    Route(Episode.root)

    Route(Episode.comments) {
      Path("comments".utf8)
    }
  }

  let episodesRouter = OneOf {
    Route(Episodes.root)

    Route(Episodes.episode) {
      Path(Int.parser())

      episodeRouter
    }
  }

  let router = OneOf {
    Route(AppRoute.home)

    Route(AppRoute.contactUs) {
      Path("contact-us".utf8)
    }

    Route(AppRoute.episodes) {
      Path("episodes".utf8)

      episodesRouter
    }

//    Route(AppRoute.episode(id:)) {
//      Path("episodes".utf8)
//      Path(Int.parser())
//    }
//
//    Route(AppRoute.episodeComments(id:)) {
//      Path("episodes".utf8)
//      Path(Int.parser())
//      Path("comments".utf8)
//
////      Path {
////        "episodes".utf8
////        Int.parser()
////        "comments".utf8
////      }
////      Query {
////        Field("page", Int.parser())
////        Field("count", Int.parser())
////      }
//    }
  }

  // /episodes/42

  let requests = [
    RequestData(
      method: "GET"
    ),
    RequestData(
      method: "GET",
      pathComponents: ["contact-us"[...].utf8]
    ),
    RequestData(
      method: "GET",
      pathComponents: ["episodes"[...].utf8]
    ),
    RequestData(
      method: "GET",
      pathComponents: ["episodes"[...].utf8, "1"[...].utf8]
    ),
    RequestData(
      method: "GET",
      pathComponents: ["episodes"[...].utf8, "1"[...].utf8, "comments"[...].utf8]
    ),
  ]

  var output: [AppRoute]!
  var expectedOutput: [AppRoute] = [
    .home,
    .contactUs,
    .episodes(.root),
    .episodes(.episode(id: 1, .root)),
    .episodes(.episode(id: 1, .comments))
  ]
  suite.benchmark(
    name: "Parser",
    run: {
      output = requests.map {
        var input = $0
        return router.parse(&input)!
      }
    },
    tearDown: {
      precondition(output == expectedOutput)
    }
  )
}

private struct RequestData {
  var body: Data?
  var headers: [(String, Substring.UTF8View)] = []
  var method: String?
  var pathComponents: ArraySlice<Substring.UTF8View> = []
  var queryItems: [(String, Substring.UTF8View)] = []
}

private struct Method: Parser {
  typealias Input = RequestData
  typealias Output = Void

  let method: String

  init(_ method: String) {
    self.method = method
  }

  func parse(_ input: inout RequestData) -> Void? {
    guard input.method?.lowercased() == self.method.lowercased()
    else { return nil }

    input.method = nil
    return ()
  }
}

private struct Path<Component>: Parser
where
  Component: Parser,
  Component.Input == Substring.UTF8View
{
  typealias Input = RequestData
  typealias Output = Component.Output

  let component: Component

  init(_ component: Component) {
    self.component = component
  }

  func parse(_ input: inout Input) -> Output? {
    guard !input.pathComponents.isEmpty
    else { return nil }

    let original = input
    let output = self.component.parse(&input.pathComponents[input.pathComponents.startIndex])
    guard input.pathComponents[input.pathComponents.startIndex].isEmpty
    else {
      input = original
      return nil
    }
    input.pathComponents.removeFirst()
    return output
  }
}

private struct PathEnd: Parser {
  typealias Input = RequestData
  typealias Output = Void

  func parse(_ input: inout Input) -> Output? {
    guard input.pathComponents.isEmpty else { return nil }
    return ()
  }
}
