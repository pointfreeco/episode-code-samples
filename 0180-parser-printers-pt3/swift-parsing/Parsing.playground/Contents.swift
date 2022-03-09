import Parsing

var input = ""[...]

protocol Printer {
  associatedtype Input
  associatedtype Output
  func print(_ output: Output, to input: inout Input) throws
}

extension String: Printer {
  func print(_ output: (), to input: inout Substring) {
    input.append(contentsOf: self)
  }
}

struct PrintingError: Error {}

extension Prefix: Printer where Input == Substring {
  func print(_ output: Input, to input: inout Input) throws {
    guard output.allSatisfy(self.predicate!)
    else { throw PrintingError() }

    input.append(contentsOf: output)
  }
}

extension Parse: Printer where Parsers: Printer {
  func print(_ output: Parsers.Output, to input: inout Parsers.Input) throws {
    try self.parsers.print(output, to: &input)
  }
}

extension Parsers.ZipVOV: Printer
where P0: Printer, P1: Printer, P2: Printer
{
  func print(
    _ output: P1.Output,
    to input: inout P0.Input
  ) throws {
    try self.p0.print((), to: &input)
    try self.p1.print(output, to: &input)
    try self.p2.print((), to: &input)
  }
}

typealias ParsePrint<P: Parser & Printer> = Parse<P>

extension OneOf: Printer where Parsers: Printer {
  func print(_ output: Parsers.Output, to input: inout Parsers.Input) throws {
    try self.parsers.print(output, to: &input)
  }
}

extension Parsers.OneOf2: Printer where P0: Printer, P1: Printer {
  func print(_ output: P0.Output, to input: inout P0.Input) throws {
    let original = input
    do {
      try self.p1.print(output, to: &input)
    } catch {
      input = original
      try self.p0.print(output, to: &input)
    }
  }
}

extension Skip: Printer where Parsers: Printer, Parsers.Output == Void {
  func print(
    _ output: (),
    to input: inout Parsers.Input
  ) throws {
    try self.parsers.print((), to: &input)
  }
}

extension Parsers.ZipVV: Printer where P0: Printer, P1: Printer {
  func print(_ output: (), to input: inout P0.Input) throws {
    try self.p0.print((), to: &input)
    try self.p1.print((), to: &input)
  }
}

extension Parsers.IntParser: Printer where Input == Substring.UTF8View {
  func print(_ output: Output, to input: inout Input) {
    var substring = Substring(input)
    substring.append(contentsOf: String(output))
    input = substring.utf8
  }
}

extension FromUTF8View: Printer where UTF8Parser: Printer {
  func print(
    _ output: UTF8Parser.Output,
    to input: inout Input
  ) throws {
    var utf8 = self.toUTF8(input)
    defer { input = self.fromUTF8(utf8) }
    try self.utf8Parser.print(output, to: &utf8)
  }
}

extension Parsers.BoolParser: Printer where Input == Substring.UTF8View {
  func print(
    _ output: Bool,
    to input: inout Substring.UTF8View
  ) throws {
    var substring = Substring(input)
    substring.append(contentsOf: String(output))
    input = substring.utf8
  }
}

extension Parsers.ZipOVOVO: Printer
where
  P0: Printer,
  P1: Printer,
  P2: Printer,
  P3: Printer,
  P4: Printer
{
  func print(_ output: (P0.Output, P2.Output, P4.Output), to input: inout P0.Input) throws {
    try self.p0.print(output.0, to: &input)
    try self.p1.print((), to: &input)
    try self.p2.print(output.1, to: &input)
    try self.p3.print((), to: &input)
    try self.p4.print(output.2, to: &input)
  }
}

extension Many: Printer
where
  Element: Printer,
  Separator: Printer,
  Separator.Output == Void,
  Result == [Element.Output]
{
  func print(_ output: [Element.Output], to input: inout Element.Input) throws {
    var firstElement = true
    for elementOutput in output {
      defer { firstElement = false }
      if !firstElement {
        try self.separator.print((), to: &input)
      }
      try self.element.print(elementOutput, to: &input)
    }
  }
}

try Parse
{
  "Hello "
  FromUTF8View { Int.parser() }
  "!"
}
.parse("Hello 42!")

input = ""
try Parse { "Hello "; Int.parser(); "!" }
.print(42, to: &input)
input

//Skip { Prefix { $0 != "," } }.print(<#T##output: ()##()#>, to: &<#T##_#>)


//extension Parsers.Map: Printer where Upstream: Printer {
//  func print(_ output: NewOutput, to input: inout Upstream.Input) throws {
//    self.tran
//    self.upstream.print(<#T##output: Upstream.Output##Upstream.Output#>, to: &<#T##Upstream.Input#>)
//  }
//}

input = ""
try Parse {
  Prefix { $0 != "\"" }
}
.print("Blob, Esq.", to: &input)
input

try Prefix
{ $0 != "\"" }.parse(&input)

input = ""
"Hello".print((), to: &input)
try "Hello".parse(&input) // ()

//print(<#T##items: Any...##Any#>, to: &<#T##TextOutputStream#>)

// parse: (inout Input) throws -> Output

// parse: (Input) throws -> (Output, Input)
// print: (Output, Input) throws -> Input

// print: (Output, inout Input) throws -> Void

// (S) -> (S, A)
// (inout S) -> A

let usersCsv = """
1, Blob, true
2, Blob Jr, false
3, Blob Sr, true
4, "Blob, Esq.", true
"""

struct User: Equatable {
  var id: Int
  var name: String
  var admin: Bool
}

//OneOf {
//  a.map(f)
//  b.map(f)
//  c.map(f)
//}
//==
//OneOf {
//  a
//  b
//  c
//}
//.map(f)

let quotedField = ParsePrint {
  "\""
  Prefix { $0 != "\"" }
  "\""
}

input = ""
try quotedField.print("Blob, Esq.", to: &input)
input
let parsedQuotedField = try quotedField.parse(&input)
try quotedField.print(parsedQuotedField, to: &input)
input

let field = OneOf {
  quotedField

  Prefix { $0 != "," }
}

input = ""
try field.print("Blob, Esq.", to: &input)
input

input = ""
try field.print("Blob Jr.", to: &input)
input

let zeroOrOneSpace = OneOf {
  " "
  ""
}

input = ""
try Skip {
  ","
  zeroOrOneSpace
}
.print((), to: &input)
input

let user = Parse {
  Int.parser()
  Skip {
    ","
    zeroOrOneSpace
  }
  field
  Skip {
    ","
    zeroOrOneSpace
  }
  Bool.parser()
}

input = ""
try user.print((42, "Blob, Esq.", true), to: &input)
input

let users = Many {
  user
} separator: {
  "\n"
} terminator: {
  End()
}

input = ""
try users.print([
  (1, "Blob", true),
  (2, "Blob, Esq.", false),
], to: &input)
input

input = "A,A,A,B"
try Many { "A" } separator: { "," }.parse(&input)
input

input = usersCsv[...]
let output = try users.parse(&input)
input

"，" == ","

func print(user: User) -> String {
  "\(user.id), \(user.name.contains(",") ? "\"\(user.name)\"" : "\(user.name)"), \(user.admin)"
}
struct UserPrinter: Printer {
  func print(_ user: User, to input: inout String) {
    input.append(contentsOf: "\(user.id),")
    if user.name.contains(",") {
      input.append(contentsOf: "\"\(user.name)\"")
    } else {
      input.append(contentsOf: user.name)
    }
    input.append(contentsOf: ",\(user.admin)")
  }
}

print(user: .init(id: 42, name: "Blob", admin: true))

func print(users: [User]) -> String {
  users.map(print(user:)).joined(separator: "\n")
}
struct UsersPrinter: Printer {
  func print(_ users: [User], to input: inout String) {
    var firstElement = true
    for user in users {
      defer { firstElement = false }
      if !firstElement {
        input += "\n"
      }
      UserPrinter().print(user, to: &input)
    }
  }
}

input = ""
//users.print(output, to: &input)

//print(users: output)
//
//input = usersCsv[...]
//try print(users: users.parse(input)) == input
//try users.parse(print(users: output)) == output
//
//var inputString = ""
//UsersPrinter().print(output, to: &inputString)
//inputString
