import Benchmark
import Parsing

private struct Color: Equatable {
  let red, green, blue: UInt8
}

private let hexPrimary = Prefix(2)
  .pipe(UInt8.parser(of: Substring.UTF8View.self, isSigned: false, radix: 16).skip(End()))

private let hexColor = "#".utf8
  .take(hexPrimary)
  .take(hexPrimary)
  .take(hexPrimary)
  .map(Color.init)

let colorSuite = BenchmarkSuite(name: "Color") { suite in
  let input = "#FF0000"
  let expected = Color(red: 0xFF, green: 0x00, blue: 0x00)
  var output: Color!

  suite.benchmark(
    name: "Parser",
    run: { output = hexColor.parse(input) },
    tearDown: { precondition(output == expected) }
  )
}
