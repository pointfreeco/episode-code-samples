import Benchmark
import Cache
import Foundation

let benchmarks: @Sendable () -> Void = {
  var mutexCache: MutexCache<Int, Int>!
  var actorCache: ActorCache<Int, Int>!
  
  let configuration = Benchmark.Configuration(
    metrics: [
      .throughput,
      .instructions,
      .wallClock,
      .cpuTotal
    ],
    warmupIterations: 10,
    setup: {
      actorCache = ActorCache()
      mutexCache = MutexCache()
    },
    teardown: {
      actorCache = nil
      mutexCache = nil
    }
  )

  Benchmark(
    "MutexCache.get",
    configuration: configuration
  ) { benchmark in
    for key in 1...10_000 {
      blackHole(mutexCache.get(key))
    }
  }

  Benchmark(
    "ActorCache.get",
    configuration: configuration
  ) { benchmark async in
    for key in 1...10_000 {
      blackHole(await actorCache.get(key))
    }
  }
}
