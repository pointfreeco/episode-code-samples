import Benchmark

let csvSuite = BenchmarkSuite(name: "CSV") { suite in
  let rowCount = 1 + csvSample.reduce(into: 0) {
    $0 += $1 == "\n" || $1 == "\r\n" ? 1 : 0
  }

  suite.benchmark("Parser: Substring") {
    var input = csvSample[...]
    let output = csvSubstring.run(&input)
    precondition(output!.count == rowCount)
    precondition(output!.allSatisfy { $0.count == 5 && $0.last?.last != "\r" })
  }

  suite.benchmark("Parser: UTF8") {
    var input = csvSample[...].utf8
    let output = csvUtf8.run(&input)
    precondition(output!.count == rowCount)
    precondition(output!.allSatisfy { $0.count == 5 && $0.last?.last != .init(ascii: "\r") })
  }

  suite.benchmark("Protocol") {
    var input = csvSample[...].utf8
    let output = csvProtocol.parse(&input)
    precondition(output!.count == rowCount)
    precondition(output!.allSatisfy { $0.count == 5 && $0.last?.last != .init(ascii: "\r") })
  }

  suite.benchmark("Mutating methods") {
    var input = csvSample[...].utf8
    let output = input.parseCSV()
    precondition(output.count == rowCount)
    precondition(output.allSatisfy { $0.count == 5 && $0.last?.last != .init(ascii: "\r") })
  }

  suite.benchmark("Imperative") {
    let output = loopParseCSV(csvSample)
    precondition(output.count == rowCount)
    precondition(output.allSatisfy { $0.count == 5 && $0.last?.last != .init(ascii: "\r") })
  }
}
