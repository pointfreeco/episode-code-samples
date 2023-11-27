import Benchmark
import CasePaths

enum Enum {
  case associatedValue(Int)
  case anotherAssociatedValue(String)
}

let enumCase = Enum.associatedValue(42)
let anotherCase = Enum.anotherAssociatedValue("Blob")

let manual = CasePath(
  embed: Enum.associatedValue,
  extract: {
    guard case let .associatedValue(value) = $0 else { return nil }
    return value
  }
)
let reflection: CasePath<Enum, Int> = /Enum.associatedValue

let success = BenchmarkSuite(name: "Success") {
  $0.benchmark("Manual") {
    precondition(manual.extract(from: enumCase) == 42)
  }

  $0.benchmark("Reflection") {
    precondition(reflection.extract(from: enumCase) == 42)
  }

  $0.benchmark("Reflection (uncached)") {
    precondition((/Enum.associatedValue).extract(from: enumCase) == 42)
  }
}

let failure = BenchmarkSuite(name: "Failure") {
  $0.benchmark("Manual") {
    precondition(manual.extract(from: anotherCase) == nil)
  }

  $0.benchmark("Reflection") {
    precondition(reflection.extract(from: anotherCase) == nil)
  }

  $0.benchmark("Reflection (uncached)") {
    precondition((/Enum.associatedValue).extract(from: anotherCase) == nil)
  }
}

Benchmark.main([
  success,
  failure,
])
