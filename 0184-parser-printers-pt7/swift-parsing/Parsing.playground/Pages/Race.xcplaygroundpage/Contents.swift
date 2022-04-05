import Parsing

protocol AppendableCollection: Collection {
  mutating func append<S>(contentsOf newElements: S) where S : Sequence, Self.Element == S.Element
  mutating func prepend<S>(contentsOf newElements: S) where S : Sequence, Self.Element == S.Element
}

extension Substring: AppendableCollection {
  mutating func prepend<S>(contentsOf newElements: S) where S : Sequence, Character == S.Element {
    var result = ""[...]
    defer { self = result }
    result.append(contentsOf: newElements)
    result.append(contentsOf: self)
  }
}

extension Substring.UTF8View: AppendableCollection {
  mutating func append<S>(contentsOf newElements: S) where S : Sequence, String.UTF8View.Element == S.Element {
    var result = Substring(self)
    switch newElements {
    case let newElements as Substring.UTF8View:
      result.append(contentsOf: Substring(newElements))
    default:
      result.append(contentsOf: Substring(decoding: Array(newElements), as: UTF8.self))
    }
    self = result.utf8
  }

  mutating func prepend<S>(contentsOf newElements: S) where S : Sequence, String.UTF8View.Element == S.Element {
    var result = Substring(self)
    switch newElements {
    case let newElements as Substring.UTF8View:
      result.prepend(contentsOf: Substring(newElements))
    default:
      result.prepend(contentsOf: Substring(decoding: Array(newElements), as: UTF8.self))
    }
    self = result.utf8
  }
}

protocol Printer {
  associatedtype Input
  associatedtype Output
  func print(_ output: Output, to input: inout Input) throws
}

extension String: Printer {
  func print(_ output: (), to input: inout Substring) {
    input.prepend(contentsOf: self)
  }
}

extension String.UTF8View: Printer {
  func print(_ output: (), to input: inout Substring.UTF8View) {
    input.prepend(contentsOf: self)
  }
}

struct PrintingError: Error {}

extension Prefix: Printer where Input: AppendableCollection {
  func print(_ output: Input, to input: inout Input) throws {
    guard input.isEmpty || !self.predicate!(input.first!)
    else { throw PrintingError() }

    guard output.allSatisfy(self.predicate!)
    else { throw PrintingError() }

    input.prepend(contentsOf: output)
  }
}

extension First: Printer where Input: AppendableCollection {
  func print(_ output: Input.Element, to input: inout Input) throws {
    input.prepend(contentsOf: [output])
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
    try self.p2.print((), to: &input)
    try self.p1.print(output, to: &input)
    try self.p0.print((), to: &input)
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

extension Parsers.OneOf3: Printer where P0: Printer, P1: Printer, P2: Printer {
  func print(_ output: P0.Output, to input: inout P0.Input) throws {
    let original = input
    do {
      try self.p2.print(output, to: &input)
    } catch {
      input = original
      do {
        try self.p1.print(output, to: &input)
      } catch {
        input = original
        try self.p0.print(output, to: &input)
      }
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
    try self.p1.print((), to: &input)
    try self.p0.print((), to: &input)
  }
}

extension Parsers.IntParser: Printer where Input: AppendableCollection {
  func print(_ output: Output, to input: inout Input) {
    input.prepend(contentsOf: String(output).utf8)
  }
}
extension Parsers.DoubleParser: Printer where Input: AppendableCollection {
  func print(_ output: Output, to input: inout Input) {
    input.prepend(contentsOf: String(output).utf8)
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

extension Parsers.BoolParser: Printer where Input: AppendableCollection {
  func print(
    _ output: Bool,
    to input: inout Input
  ) throws {
    input.prepend(contentsOf: String(output).utf8)
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
    try self.p4.print(output.2, to: &input)
    try self.p3.print((), to: &input)
    try self.p2.print(output.1, to: &input)
    try self.p1.print((), to: &input)
    try self.p0.print(output.0, to: &input)
  }
}

extension Parsers.ZipOV: Printer where P0: Printer, P1: Printer {
  func print(_ output: (P0.Output), to input: inout P0.Input) throws {
    try self.p1.print((), to: &input)
    try self.p0.print(output, to: &input)
  }
}

extension Parsers.ZipOVOVOO: Printer where P0: Printer, P1: Printer, P2: Printer, P3: Printer, P4: Printer, P5: Printer {
  func print(_ output: (P0.Output, P2.Output, P4.Output, P5.Output), to input: inout P0.Input) throws {
    try self.p5.print(output.3, to: &input)
    try self.p4.print(output.2, to: &input)
    try self.p3.print((), to: &input)
    try self.p2.print(output.1, to: &input)
    try self.p1.print((), to: &input)
    try self.p0.print(output.0, to: &input)
  }
}

extension Parsers.ZipOO: Printer where P0: Printer, P1: Printer {
  func print(_ output: (P0.Output, P1.Output), to input: inout P0.Input) throws {
    try p1.print(output.1, to: &input)
    try p0.print(output.0, to: &input)
  }
}

extension Parsers.ZipVO: Printer where P0: Printer, P1: Printer {
  func print(_ output: P1.Output, to input: inout P0.Input) throws {
    try p1.print(output, to: &input)
    try p0.print((), to: &input)
  }
}

extension Many: Printer
where
  Element: Printer,
  Separator: Printer,
  Separator.Output == Void,
  Terminator: Printer,
  Terminator.Output == Void,
  Result == [Element.Output]
{
  func print(_ output: [Element.Output], to input: inout Element.Input) throws {
    try self.terminator.print((), to: &input)
    var firstElement = true
    for elementOutput in output.reversed() {
      defer { firstElement = false }
      if !firstElement {
        try self.separator.print((), to: &input)
      }
      try self.element.print(elementOutput, to: &input)
    }
  }
}

extension Parsers.Map: Printer where
  Upstream: Printer,
  Upstream.Output == Void,
  NewOutput: Equatable
{
  func print(_ output: NewOutput, to input: inout Upstream.Input) throws {
    guard self.transform(()) == output
    else {
      throw PrintingError()
    }
    try self.upstream.print((), to: &input)
  }
}

typealias ParserPrinter = Parser & Printer

struct Conversion<A, B> {
  let apply: (A) throws -> B
  let unapply: (B) throws -> A
}

extension Conversion where A == Substring, B == String {
  static let string = Self(
    apply: { String($0) },
    unapply: { Substring($0) }
  )
}

extension Parser where Self: Printer {
  func map<NewOutput>(
    _ conversion: Conversion<Output, NewOutput>
  ) -> Parsers.InvertibleMap<Self, NewOutput> {
    .init(upstream: self, transform: conversion.apply, untransform: conversion.unapply)
  }
}

extension Parsers {
  struct InvertibleMap<Upstream: ParserPrinter, NewOutput>: ParserPrinter {
    let upstream: Upstream
    let transform: (Upstream.Output) throws -> NewOutput
    let untransform: (NewOutput) throws -> Upstream.Output

    func parse(_ input: inout Upstream.Input) throws -> NewOutput {
      try self.transform(self.upstream.parse(&input))
    }

    func print(_ output: NewOutput, to input: inout Upstream.Input) throws {
      try self.upstream.print(self.untransform(output), to: &input)
    }
  }
}

extension Parse {
  init<Upstream, NewOutput>(
    _ conversion: Conversion<Upstream.Output, NewOutput>,
    @ParserBuilder with build: () -> Upstream
  ) where Parsers == Parsing.Parsers.InvertibleMap<Upstream, NewOutput> {
    self.init { build().map(conversion) }
  }
}

extension Parsers.ZipOVO: Printer where P0: Printer, P1: Printer, P2: Printer {
  func print(_ output: (P0.Output, P2.Output), to input: inout P0.Input) throws {
    try self.p2.print(output.1, to: &input)
    try self.p1.print((), to: &input)
    try self.p0.print(output.0, to: &input)
  }
}

extension Parser {
  func printing(_ input: Input) -> Parsers.Printing<Self> where Input: AppendableCollection {
    .init(upstream: self, input: input)
  }
}

extension Parsers {
  struct Printing<Upstream: Parser>: ParserPrinter where Upstream.Input: AppendableCollection {
    let upstream: Upstream
    let input: Upstream.Input

    func parse(_ input: inout Upstream.Input) throws -> Upstream.Output {
      try self.upstream.parse(&input)
    }

    func print(_ output: Upstream.Output, to input: inout Upstream.Input) throws {
      input.prepend(contentsOf: self.input)
    }
  }
}

extension End: Printer {
  func print(_ output: (), to input: inout Input) throws {
    guard input.isEmpty
    else { throw PrintingError() }
  }
}

extension Rest: Printer where Input: AppendableCollection {
  func print(_ output: Input, to input: inout Input) throws {
    guard !output.isEmpty, input.isEmpty
    else { throw PrintingError() }

    input.prepend(contentsOf: output)
  }
}

extension Not: Printer where Upstream: Printer, Upstream.Output == Void {
  func print(_ output: (), to input: inout Upstream.Input) throws {
    var input = input
    do {
      try self.upstream.parse(&input)
    } catch {
      return
    }
    throw PrintingError()
  }
}

struct ConvertingError: Error {}

extension Conversion {
  static func `struct`(_ `init`: @escaping (A) -> B) -> Self {
    Self(
      apply: `init`,
      unapply: { unsafeBitCast($0, to: A.self) }
    )
  }
}
extension Always: Printer where Output == Void {
  func print(_ output: Void, to input: inout Input) throws {
  }
}

struct Coordinate {
  let latitude: Double
  let longitude: Double
}

enum Currency { case eur, gbp, usd }

struct Money {
  let currency: Currency
  let dollars: Int
}

Array("🥵".utf8)

let count = Conversion<[Void], Int>(
  apply: \.count,
  unapply: { count in Array(repeating: (), count: count) }
)

let difficulty = // Prefix { $0 == "🥵" }.map(\.count)
Many { "🥵".utf8 }.map(count)

input = ""[...].utf8
try Many { "🥵".utf8 }.print([(), (), ()], to: &input)
Substring(input)

try difficulty.parse("🥵🥵🥵🥵".utf8)

input = ""[...].utf8
try difficulty.print(5, to: &input)
Substring(input)

struct Race {
  let location: String
  let entranceFee: Money
  let difficulty: Int
  let path: [Coordinate]
}

let northSouthSign = OneOf {
  "N".utf8.map { 1.0 }
  "S".utf8.map { -1.0 }
}

var input = ""[...].utf8
try northSouthSign.print(-1, to: &input)
Substring(input)

let eastWestSign = OneOf {
  "E".utf8.map { 1.0 }
  "W".utf8.map { -1.0 }
}

let magnitudeSign = Conversion<(Double, Double), Double>(
  apply: *,
  unapply: { value in
    value < 0 ? (-value, -1) : (value, 1)
  }
)

func print(coordinate: Coordinate) -> String {
  "\(abs(coordinate.latitude))° \(coordinate.latitude < 0 ? "S" : "N"), \(abs(coordinate.longitude))° \(coordinate.longitude < 0 ? "W" : "E")"
}

let latitude = ParsePrint(magnitudeSign) {
  Double.parser()
  "° ".utf8
  northSouthSign
}
input = ""[...].utf8
try latitude.print(-37, to: &input)
Substring(input)

let longitude = ParsePrint(magnitudeSign) {
  Double.parser()
  "° ".utf8
  eastWestSign
}

let zeroOrMoreSpaces = Skip { Prefix { $0 == .init(ascii: " ") } }
  .printing(" "[...].utf8)

let coord = ParsePrint(.struct(Coordinate.init)) {
  latitude
  Skip {
    ",".utf8
    zeroOrMoreSpaces
  }
  longitude
}

input = ""[...].utf8
try coord.print(.init(latitude: 37, longitude: -42), to: &input)
Substring(input)

let currency = OneOf {
  "€".utf8.map { Currency.eur }
  "£".utf8.map { Currency.gbp }
  "$".utf8.map { Currency.usd }
}

input = ""[...].utf8
try currency.print(.eur, to: &input)
Substring(input)

let money = Parse(.struct(Money.init)) {
  currency
  Int.parser()
}

input = ""[...].utf8
try money.print(.init(currency: .usd, dollars: 300), to: &input)
Substring(input)

let locationName = Prefix { $0 != .init(ascii: ",") }

extension Conversion where A == Substring.UTF8View, B == String {
  static let string = Self(
    apply: { String(Substring($0)) },
    unapply: { $0[...].utf8 }
  )
}

let race = ParsePrint(.struct(Race.init)) {
  locationName.map(.string)
  Skip {
    ",".utf8
    zeroOrMoreSpaces
  }
  money
  Skip {
    ",".utf8
    zeroOrMoreSpaces
  }
  ParsePrint {
    difficulty
    "\n".utf8
  }
  Many {
    coord
  } separator: {
    "\n".utf8
  }
}

input = ""[...].utf8
try race.print(
  .init(
    location: "New York",
    entranceFee: .init(currency: .usd, dollars: 300),
    difficulty: 4,
    path: [
      .init(latitude: 37, longitude: 42),
        .init(latitude: 37.01, longitude: 42.01)
    ]
  ),
  to: &input
)
Substring(input)

let races = Many {
  race
} separator: {
  "\n---\n".utf8
}

input = ""[...].utf8
try races.print(
  [
    .init(
      location: "New York",
      entranceFee: .init(currency: .usd, dollars: 300),
      difficulty: 4,
      path: [
        .init(latitude: 37, longitude: 42),
          .init(latitude: 37.01, longitude: 42.01)
      ]
    ),
    .init(
      location: "Berlin",
      entranceFee: .init(currency: .eur, dollars: 200),
      difficulty: 3,
      path: [
        .init(latitude: 37, longitude: 42),
          .init(latitude: 37.01, longitude: 42.01)
      ]
    )
  ],
  to: &input
)
Substring(input)

let racesInput = """
  New York City, $300, 🥵🥵🥵🥵
  40.60248° N, 74.06433° W
  40.61807° N, 74.02966° W
  40.64953° N, 74.00929° W
  40.67884° N, 73.98198° W
  40.69894° N, 73.95701° W
  40.72791° N, 73.95314° W
  40.74882° N, 73.94221° W
  40.7574° N, 73.95309° W
  40.76149° N, 73.96142° W
  40.77111° N, 73.95362° W
  40.8026° N, 73.93061° W
  40.80409° N, 73.92893° W
  40.81432° N, 73.93292° W
  40.80325° N, 73.94472° W
  40.77392° N, 73.96917° W
  40.77293° N, 73.97671° W
  ---
  Berlin, €100, 🥵🥵🥵
  13.36015° N, 52.51516° E
  13.33999° N, 52.51381° E
  13.32539° N, 52.51797° E
  13.33696° N, 52.52507° E
  13.36454° N, 52.52278° E
  13.38152° N, 52.52295° E
  13.40072° N, 52.52969° E
  13.42555° N, 52.51508° E
  13.41858° N, 52.49862° E
  13.40929° N, 52.48882° E
  13.37968° N, 52.49247° E
  13.34898° N, 52.48942° E
  13.34103° N, 52.47626° E
  13.32851° N, 52.47122° E
  13.30852° N, 52.46797° E
  13.28742° N, 52.47214° E
  13.29091° N, 52.4827° E
  13.31084° N, 52.49275° E
  13.32052° N, 52.5019° E
  13.34577° N, 52.50134° E
  13.36903° N, 52.50701° E
  13.39155° N, 52.51046° E
  13.37256° N, 52.51598° E
  ---
  London, £500, 🥵🥵
  51.48205° N, 0.04283° E
  51.47439° N, 0.0217° E
  51.47618° N, 0.02199° E
  51.49295° N, 0.05658° E
  51.47542° N, 0.03019° E
  51.47537° N, 0.03015° E
  51.47435° N, 0.03733° E
  51.47954° N, 0.04866° E
  51.48604° N, 0.06293° E
  51.49314° N, 0.06104° E
  51.49248° N, 0.0474° E
  51.48888° N, 0.03564° E
  51.48655° N, 0.0183° E
  51.48085° N, 0.02223° W
  51.4921° N, 0.0451° W
  51.49324° N, 0.04699° W
  51.50959° N, 0.05491° W
  51.50961° N, 0.0539° W
  51.4995° N, 0.01356° W
  51.50898° N, 0.02341° W
  51.51069° N, 0.04225° W
  51.51056° N, 0.04353° W
  51.50946° N, 0.0781° W
  51.51121° N, 0.09786° W
  51.50964° N, 0.1187° W
  51.50273° N, 0.1385° W
  51.50095° N, 0.12411° W
  """
