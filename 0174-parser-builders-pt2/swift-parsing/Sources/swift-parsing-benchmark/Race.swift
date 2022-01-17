import Benchmark
import Parsing

/*
 This benchmark implements a parser for a custom format covered in a collection of episodes on
 Point-Free: https://www.pointfree.co/collections/parsing
 */

// MARK: - Parser

private let northSouth = "N".utf8.map { 1.0 }
  .orElse("S".utf8.map { -1 })

private let eastWest = "E".utf8.map { 1.0 }
  .orElse("W".utf8.map { -1 })

private let latitude = Double.parser()
  .skip("° ".utf8)
  .take(northSouth)
  .map(*)

private let longitude = Double.parser()
  .skip("° ".utf8)
  .take(eastWest)
  .map(*)

private struct Coordinate {
  let latitude: Double
  let longitude: Double
}

private let zeroOrMoreSpaces = Prefix { $0 == .init(ascii: " ") }

private let coord =
  latitude
  .skip(",".utf8)
  .skip(zeroOrMoreSpaces)
  .take(longitude)
  .map(Coordinate.init)

private enum Currency { case eur, gbp, usd }

private let currency = "€".utf8.map { Currency.eur }
  .orElse("£".utf8.map { .gbp })
  .orElse("$".utf8.map { .usd })

private struct Money {
  let currency: Currency
  let value: Double
}

private let money = currency.take(Double.parser())
  .map(Money.init(currency:value:))

private struct Race {
  let location: String
  let entranceFee: Money
  let path: [Coordinate]
}

private let locationName = Prefix { $0 != .init(ascii: ",") }

private let race = locationName.map { String(Substring($0)) }
  .skip(",".utf8)
  .skip(zeroOrMoreSpaces)
  .take(money)
  .skip("\n".utf8)
  .take(Many(coord, separator: "\n".utf8))
  .map(Race.init(location:entranceFee:path:))

private let races = Many(race, separator: "\n---\n".utf8)

// MARK: - Benchmarks

let raceSuite = BenchmarkSuite(name: "Race") { suite in
  let input = """
    New York City, $300
    40.60248° N, 74.06433° W
    40.61807° N, 74.02966° W
    40.64953° N, 74.00929° W
    40.67884° N, 73.98198° W
    40.69894° N, 73.95701° W
    40.72791° N, 73.95314° W
    40.74882° N, 73.94221° W
    40.75740° N, 73.95309° W
    40.76149° N, 73.96142° W
    40.77111° N, 73.95362° W
    40.80260° N, 73.93061° W
    40.80409° N, 73.92893° W
    40.81432° N, 73.93292° W
    40.80325° N, 73.94472° W
    40.77392° N, 73.96917° W
    40.77293° N, 73.97671° W
    ---
    Berlin, €100
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
    13.29091° N, 52.48270° E
    13.31084° N, 52.49275° E
    13.32052° N, 52.50190° E
    13.34577° N, 52.50134° E
    13.36903° N, 52.50701° E
    13.39155° N, 52.51046° E
    13.37256° N, 52.51598° E
    ---
    London, £500
    51.48205° N, 0.04283° E
    51.47439° N, 0.02170° E
    51.47618° N, 0.02199° E
    51.49295° N, 0.05658° E
    51.47542° N, 0.03019° E
    51.47537° N, 0.03015° E
    51.47435° N, 0.03733° E
    51.47954° N, 0.04866° E
    51.48604° N, 0.06293° E
    51.49314° N, 0.06104° E
    51.49248° N, 0.04740° E
    51.48888° N, 0.03564° E
    51.48655° N, 0.01830° E
    51.48085° N, 0.02223° W
    51.49210° N, 0.04510° W
    51.49324° N, 0.04699° W
    51.50959° N, 0.05491° W
    51.50961° N, 0.05390° W
    51.49950° N, 0.01356° W
    51.50898° N, 0.02341° W
    51.51069° N, 0.04225° W
    51.51056° N, 0.04353° W
    51.50946° N, 0.07810° W
    51.51121° N, 0.09786° W
    51.50964° N, 0.11870° W
    51.50273° N, 0.13850° W
    51.50095° N, 0.12411° W
    """
  var output: [Race]!

  suite.benchmark(
    name: "Parser",
    run: { output = races.parse(input) },
    tearDown: { precondition(output.count == 3) }
  )
}
