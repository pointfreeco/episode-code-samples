import Benchmark

let raceSuite = BenchmarkSuite(name: "Race") { suite in
  suite.benchmark("Substring") {
    var input = upcomingRaces[...]
    precondition(races.run(&input)?.count == 4)
  }

  suite.benchmark("UTF8") {
    var input = upcomingRaces[...].utf8
    precondition(racesUtf8.run(&input)?.count == 4)
  }
}
