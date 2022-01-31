import Benchmark
import Foundation
import Parsing

let uuidSuite = BenchmarkSuite(name: "UUID") { suite in
  let input = "deadbeef-dead-beef-dead-beefdeadbeef"
  let expected = UUID(uuidString: "deadbeef-dead-beef-dead-beefdeadbeef")!
  var output: UUID!

  suite.benchmark(
    name: "UUID.init",
    run: { output = UUID(uuidString: input) },
    tearDown: { precondition(output == expected) }
  )

  suite.benchmark(
    name: "UUIDParser",
    run: { output = UUID.parser(of: Substring.UTF8View.self).parse(input) },
    tearDown: { precondition(output == expected) }
  )
}
