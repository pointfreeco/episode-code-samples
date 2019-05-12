//typealias Parser<A> = (String) -> A

struct Parser<A> {
//  let run: (String) -> A?
//  let run: (String) -> (match: A?, rest: String)
//  let run: (inout String) -> A?
  let run: (inout Substring) -> A?

  func run(_ str: String) -> (match: A?, rest: Substring) {
    var str = str[...]
    let match = self.run(&str)
    return (match, str)
  }
}

let int = Parser<Int> { str in
  let prefix = str.prefix(while: { $0.isNumber })
  guard let int = Int(prefix) else { return nil }
  str.removeFirst(prefix.count)
  return int
}


//Substring


int.run("42")
int.run("42 Hello World")
int.run("Hello World")


// (A)       -> A
// (inout A) -> Void

enum Route {
  case home
  case profile
  case episodes
  case episode(id: Int)
}

let router = Parser<Route> { str in
  fatalError()
}

//router.run("/") // .home
//router.run("/episodes/42") // .episode(42)

//switch router.run("/episodes/42") {
//case .none:
//case .some(.home):
//case .some(.profile):
//case .some(.episodes):
//case let .some(.episode(id)):
//}

import Foundation

enum EnumPropertyGenerator {
  case help
  case version
  case invoke(urls: [URL], dryRun: Bool)
}

let cli = Parser<EnumPropertyGenerator> { str in
  fatalError()
}

//cli.run("generate-enum-properties --version") // .version
//cli.run("generate-enum-properties --help") // .help
//cli.run("generate-enum-properties --dry-run /path/to/file.swift") // .invoke(["/path/to/file.swift"], dryRun: true)
//
//switch cli.run("generate-enum-properties --dry-run /path/to/file.swift") {
//case .help:
//case .version:
//case .invoke:
//case nil:
//}
