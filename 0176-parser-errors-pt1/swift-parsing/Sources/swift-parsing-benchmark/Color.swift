import Benchmark
import Parsing

private struct Color: Equatable {
  let red, green, blue: UInt8
}

private let hexPrimary = Prefix<Substring.UTF8View>(2).pipe {
  UInt8.parser(isSigned: false, radix: 16)
  End()
}

private let hexColor = Parse(Color.init(red:green:blue:)) {
  "#".utf8
  hexPrimary
  hexPrimary
  hexPrimary
}

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
