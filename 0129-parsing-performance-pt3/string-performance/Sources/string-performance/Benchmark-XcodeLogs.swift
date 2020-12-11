import Benchmark

let xcodeLogsSuite = BenchmarkSuite(name: "Xcode Logs") { suite in
  suite.benchmark("Substring") {
    var input = xcodeLogs[...]
    precondition(testResults.run(&input)?.count == 283)
  }
  
  suite.benchmark("UTF8") {
    var input = xcodeLogs[...].utf8
    precondition(testResultsUtf8.run(&input)?.count == 283)
  }
}
