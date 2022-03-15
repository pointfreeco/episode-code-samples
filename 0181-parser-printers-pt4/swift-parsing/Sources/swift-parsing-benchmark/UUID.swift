import Benchmark
import Foundation
import Parsing

/// This benchmark demonstrates how the UUID parser compares to `UUID`'s initializer.
let uuidSuite = BenchmarkSuite(name: "UUID") { suite in
  let input = "deadbeef-dead-beef-dead-beefdeadbeef"
  let expected = UUID(uuidString: "deadbeef-dead-beef-dead-beefdeadbeef")!
  var output: UUID!

  suite.benchmark("UUID.init") {
    output = UUID(uuidString: input)
  } tearDown: {
    precondition(output == expected)
  }

  suite.benchmark("UUID.parser") {
    var input = input[...].utf8
    output = try UUID.parser().parse(&input)
  } tearDown: {
    precondition(output == expected)
  }
}
