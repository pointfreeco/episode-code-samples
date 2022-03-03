import Benchmark
import Parsing

/// This benchmark demonstrates how to parse a hexadecimal color.
///
/// Compare to the Rust [example using nom](https://github.com/Geal/nom#example).
let colorSuite = BenchmarkSuite(name: "Color") { suite in
  struct Color: Equatable {
    let red, green, blue: UInt8
  }

  let hexPrimary = Prefix<Substring.UTF8View>(2).pipe {
    UInt8.parser(isSigned: false, radix: 16)
    End()
  }

  let hexColor = Parse(Color.init(red:green:blue:)) {
    "#".utf8
    hexPrimary
    hexPrimary
    hexPrimary
  }

  let input = "#FF0000"
  let expected = Color(red: 0xFF, green: 0x00, blue: 0x00)
  var output: Color!

  suite.benchmark("Parser") {
    var input = input[...].utf8
    output = try hexColor.parse(&input)
  } tearDown: {
    precondition(output == expected)
  }
}
