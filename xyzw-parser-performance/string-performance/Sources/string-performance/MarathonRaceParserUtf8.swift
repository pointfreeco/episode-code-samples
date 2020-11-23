private let northSouth = Parser<Substring.UTF8View, UTF8.CodeUnit>.first.flatMap {
  $0 == .init(ascii: "N") ? .always(1.0)
    : $0 == .init(ascii: "S") ? .always(-1)
    : .never
}

private let eastWest = Parser<Substring.UTF8View, UTF8.CodeUnit>.first.flatMap {
  $0 == .init(ascii: "E") ? .always(1.0)
    : $0 == .init(ascii: "W") ? .always(-1)
    : .never
}

private let latitude = Parser.double
  .skip(.prefix("° "[...].utf8))
  .take(northSouth)
  .map(*)

// .skip("café")

private let longitude = Parser.double
  .skip(.prefix("° "[...].utf8))
  .take(eastWest)
  .map(*)

private let zeroOrMoreSpaces = Parser<Substring.UTF8View, Void>.prefix(" "[...].utf8).zeroOrMore()

private let coord = latitude
  .skip(.prefix(","[...].utf8))
  .skip(zeroOrMoreSpaces)
  .take(longitude)
  .map(Coordinate.init)

private let currency = Parser<Substring.UTF8View, Currency>.oneOf(
  Parser.prefix("€"[...].utf8).map { Currency.eur },
  Parser.prefix("£"[...].utf8).map { .gbp },
  Parser.prefix("$"[...].utf8).map { .usd }
)

private let _city = Parser<Substring.UTF8View, City>.oneOf(
  Parser.prefix("Berlin"[...].utf8).map { .berlin },
  Parser.prefix("London"[...].utf8).map { .london },
  Parser.prefix("New York City"[...].utf8).map { .newYork },
  Parser.prefix("San José").utf8.map { .sanJose }
)

private let money = zip(currency, .double)
  .map(Money.init(currency:value:))

private let locationName = Parser<Substring.UTF8View, Substring.UTF8View>.prefix(while: { $0 != .init(ascii: ",") })

private let race = _city // locationName.map { String(Substring($0)) }
  .skip(.prefix(","[...].utf8))
  .skip(zeroOrMoreSpaces)
  .take(money)
  .skip(.prefix("\n"[...].utf8))
  .take(coord.zeroOrMore(separatedBy: .prefix("\n"[...].utf8)))
  .map(Race.init(location:entranceFee:path:))

let racesUtf8 = race.zeroOrMore(separatedBy: .prefix("\n---\n"[...].utf8))
