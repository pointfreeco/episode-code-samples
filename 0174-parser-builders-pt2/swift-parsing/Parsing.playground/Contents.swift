import Parsing

// (inout Input) -> Output?

var input = "123 Hello World!"[...]
Int.parser().parse(&input)
input

//StartsWith(" Hello ").parse(&input)
" Hello ".parse(&input)
input

Prefix
  .init(while: { $0 != "!" }).parse(&input)
input

".".parse(&input)
input

input = "123 Hello World!"[...]
Int.parser()
  .skip(" Hello ")
  .take(Prefix { $0 != "!" })
  .skip("!")
  .parse(&input)
input

input = """
1,Blob,member
2,Blob Jr,guest
3,Blob Sr,admin
"""[...]

enum Role {
  case admin, guest, member
}

//let role = "admin".map { Role.admin }
//  .orElse("guest".map { Role.guest })
//  .orElse("member".map { Role.member })
//  .orElse(...)
//  .orElse(...)
//  .orElse(...)
//  .orElse(...)
//  .orElse(...)

@resultBuilder
enum OneOfBuilder {
  static func buildBlock<P0, P1, P2>(
    _ p0: P0,
    _ p1: P1,
    _ p2: P2
  )
  -> Parsers.OneOf<Parsers.OneOf<P0, P1>, P2>
  where
    P0: Parser,
    P1: Parser,
    P2: Parser
  {
    p0.orElse(p1).orElse(p2)
  }
}

extension Parsers.OneOf {
  init(@OneOfBuilder build: () -> Self) {
    self = build()
  }
}

typealias OneOf = Parsers.OneOf

// Parser<Substring, (Role, Role, Role)>

struct User {
  var id: Int
  var name: String
  var role: Role
}

let zeroOrMoreSpaces = Prefix { $0 == " " }

//let user = Skip(zeroOrMoreSpaces)
//  .take(Int.parser())
//  .skip(zeroOrMoreSpaces)
//  .skip(",")
//  .skip(zeroOrMoreSpaces)
//  .take(Prefix { $0 != "," }.map(String.init))
//  .skip(zeroOrMoreSpaces)
//  .skip(",")
//  .skip(zeroOrMoreSpaces)
//  .take(role)
//  .skip(zeroOrMoreSpaces)
//  .map(User.init(id:name:role:))

@resultBuilder
enum ParserBuilder {
  static func buildBlock<P0, P1, P2, P3, P4>(
    _ p0: P0,
    _ p1: P1,
    _ p2: P2,
    _ p3: P3,
    _ p4: P4
  )
  -> Parsers.Take3<Parsers.SkipSecond<Parsers.Take2<Parsers.SkipSecond<P0, P1>, P2>, P3>, P0.Output, P2.Output, P4>
  where
    P0: Parser,
    P1: Parser,
    P2: Parser,
    P3: Parser,
    P4: Parser,
    P1.Output == Void,
    P3.Output == Void
  {
    p0.skip(p1).take(p2).skip(p3).take(p4)
  }

  static func buildBlock<P0, P1, P2>(
    _ p0: P0,
    _ p1: P1,
    _ p2: P2
  )
  -> Parsers.Take3<Parsers.Take2<P0, P1>, P0.Output, P1.Output, P2>
  where
    P0: Parser,
    P1: Parser,
    P2: Parser
  {
    p0.take(p1).take(p2)
  }
}

Group {
  Text("Hi")
  Button("Bye") {}
}
struct _Group<Content>: View where Content: View {
  let content: Content
  init(@ViewBuilder content: () -> Content) {
    self.content = content()
  }
  var body: some View {
    self.content
  }
}
struct Parse<Parsers, NewOutput>: Parser where Parsers: Parser {
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
    @ParserBuilder parsers: () -> Parsers
  )
  where Parsers.Output == NewOutput
  {
    self.transform = { $0 }
    self.parsers = parsers()
  }
  func parse(_ input: inout Parsers.Input) -> NewOutput? {
    self.parsers.parse(&input).map(transform)
  }
}

let role = OneOf {
  "admin".map { Role.admin }
  "guest".map { Role.guest }
  "member".map { Role.member }
}

let user = Parse(User.init(id:name:role:)) {
  Int.parser()
  ","
  Prefix { $0 != "," }.map(String.init)
  ","
  role
}
//  .map(User.init(id:name:role:))

pow(2, 11)
//pow(2, n) + pow(2, n-1) + pow(2, n-2) + ... + pow(2, 0)
// = pow(2, n+1) - 1
pow(2, 6+1) - 1

let users = Many(user, separator: "\n")
//let users = Many {
//  user
//} separator: {
//  "\n"
//}
users.parse(&input)

input

/*
 Parsing.Many<Parsing.Parsers.Map<Parsing.Parsers.Take3<Parsing.Parsers.SkipSecond<Parsing.Parsers.Take2<Parsing.Parsers.SkipSecond<Parsing.Parsers.UTF8ViewToSubstring<Parsing.Parsers.IntParser<Substring.UTF8View, Int>>, String>, Parsing.Parsers.Map<Parsing.Prefix<Substring>, String>>, String>, Int, String, Parsing.Parsers.UTF8ViewToSubstring<Parsing.Parsers.BoolParser<Substring.UTF8View>>>, User>, Array<__lldb_expr_45.User>, String>
 */


import Combine

let publisher = Just(1)
  .map { $0 + 1 }
  .flatMap { Just($0) }
  .filter { $0.isMultiple(of: 2) }
  .dropFirst()
  .ignoreOutput()
/*
 Combine.Publishers.IgnoreOutput<Combine.Publishers.Drop<Combine.Publishers.Filter<Combine.Publishers.FlatMap<Combine.Just<Int>, Combine.Just<Int>>>>>
 */

import SwiftUI

let view = Group {
  ForEach(1...10, id: \.self) { index in
    Button(action: {}) {
      HStack {
        Text("Number")
        Text("\(index)")
      }
    }
  }
}
/*
 SwiftUI.ForEach<ClosedRange<Int>, Int, SwiftUI.Button<SwiftUI.HStack<SwiftUI.TupleView<(SwiftUI.Text, SwiftUI.Text)>>>>
 */

struct Template<Title: View, Content: View>: View {
  let title: Title
  let content: Content

  init(
    @ViewBuilder title: () -> Title,
    @ViewBuilder content: () -> Content
  ) {
    self.title = title()
    self.content = content()
  }

  var body: some View {
    VStack {
      self.title
      self.content
    }
  }
}

//Template(title: Text("Hi"), content: Text("Welcome!"))
Template {
  if true {
    Text("Hi")
  } else {
    Text("Bye")
  }
  Spacer()
} content: {
  Text("Welcome")
}


VStack { Text(""); Text(""); Text(""); Text(""); Text(""); Text(""); Text(""); Text(""); Text(""); Text(""); }

Section {
  Text("Content")
} header: {
  Text("Header")
} footer: {
  Text("Footer")
}

NavigationLink {
  Text("Destination")
} label: {
  Text("Label")
}

@resultBuilder
enum StringBuilder {
  static func buildArray(_ components: [String]) -> String {
    components.joined()
  }
  static func buildEither(first component: String) -> String {
    component
  }

  static func buildEither(second component: String) -> String {
    component
  }
  static func buildOptional(_ component: String?) -> String {
    component ?? ""
  }
  static func buildBlock(_ components: String...) -> String {
    components.joined()
  }
}

extension String {
  init(@StringBuilder build: () -> String) {
    self = build()
  }
}

let useSpace = false
String(build: {
  "Hello"
  switch useSpace {
  case true: " "
  case false: "-"
  }
  "World"
  for _ in 1...10 {
    "!"
  }
})
