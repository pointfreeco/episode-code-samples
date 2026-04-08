import Benchmark
import Cache
import Foundation

let benchmarks: @Sendable () -> Void = {
  let configuration = Benchmark.Configuration(
    metrics: [
      .throughput,
      .instructions,
      .wallClock,
      .cpuTotal
    ],
    warmupIterations: 10
  )

  Benchmark(
    "Array map",
    configuration: configuration
  ) { _ in
    precondition(Array(1...100).map { $0 + 1 } == Array(2...101))
  }
}
