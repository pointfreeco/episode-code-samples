import Benchmark

let csvSuite = BenchmarkSuite(name: "CSV") { suite in
  suite.benchmark("Parser") {
    var input = csvSample[...].utf8
    let output = csv.run(&input)
    precondition(output!.count == 1_000)
    precondition(output!.allSatisfy { $0.count == 10 })
  }

  suite.benchmark("Mutating methods") {
    var input = csvSample[...].utf8
    let output = input.parseCsv()
    precondition(output.count == 1_000)
    precondition(output.allSatisfy { $0.count == 10 })
  }

  suite.benchmark("Imperative") {
    let output = csvSample.parseImperativeUtf8()
    precondition(output.count == 1_000)
    precondition(output.allSatisfy { $0.count == 10 })
  }
}
