import Benchmark

let protocolSuite = BenchmarkSuite(name: "Protocol") { suite in
  let string = "1234567890"

//  suite.benchmark("Parser.int") {
//    var string = string[...].utf8
//    precondition(Parser.int.run(&string) == 1234567890)
//  }
//
//  suite.benchmark("IntParser") {
//    var input = string[...].utf8
//    _ = IntParser().parse(&input)
//  }

  let p1 = Parser<Substring.UTF8View, Int>.int
    .take(.first)
    .take(.int)
    .take(.first)
    .take(.int)
    .take(.first)
    .take(.int)
    .take(.first)
    .take(.int)
  suite.benchmark("Deeply nested: Parser") {
    var input = "1-2-3-4-5"[...].utf8
    let output = p1.run(&input)
    precondition(output != nil)
    precondition(input.isEmpty)
  }

  suite.benchmark("Deeply nested: ParserProtocol") {
    var input = "1-2-3-4-5"[...].utf8
    let output = IntParser()
      .take(First())
      .take(IntParser())
      .take(First())
      .take(IntParser())
      .take(First())
      .take(IntParser())
      .take(First())
      .take(IntParser())
      .parse(&input)

    precondition(output != nil)
    precondition(input.isEmpty)
  }
}
