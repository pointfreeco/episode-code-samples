import Benchmark
import Cache
import Foundation

let benchmarks: @Sendable () -> Void = {
  nonisolated(unsafe) var mutexCache: MutexCache<Int, Int>!
  nonisolated(unsafe) var actorCache: ActorCache<Int, Int>!

  let configuration = Benchmark.Configuration(
    metrics: [
      .throughput,
      .instructions,
      .wallClock,
      .cpuTotal
    ],
    warmupIterations: 10,
    setup: {
      mutexCache = MutexCache()
      actorCache = ActorCache()
    },
    teardown: {
      mutexCache = nil
      actorCache = nil
    }
  )

  Benchmark(
    "1.MutexCache.get",
    configuration: configuration
  ) { _ in
    for key in 1...10_000 {
      blackHole(mutexCache.get(key))
    }
  }
  Benchmark(
    "1.ActorCache.get",
    configuration: configuration
  ) { _ in
    for key in 1...10_000 {
      blackHole(await actorCache.get(key))
    }
  }


  Benchmark(
    "2.MutexCache.set",
    configuration: configuration
  ) { _ in
    for key in 1...1_000 {
      blackHole(mutexCache.set(key, value: key + 1))
    }
  }
  Benchmark(
    "2.ActorCache.set",
    configuration: configuration
  ) { _ in
    for key in 1...1_000 {
      blackHole(await actorCache.set(key, value: key + 1))
    }
  }

  Benchmark(
    "3.MutexCache.highConcurrency",
    configuration: configuration
  ) { benchmark in
    await withTaskGroup { group in
      for key in 1...100 {
        group.addTask {
          blackHole(mutexCache.get(key))
        }
        group.addTask {
          mutexCache.set(key, value: key + 1)
        }
      }
    }
  }
  Benchmark(
    "3.ActorCache.highConcurrency",
    configuration: configuration
  ) { benchmark in
    await withTaskGroup { group in
      for key in 1...100 {
        group.addTask {
          blackHole(await actorCache.get(key))
        }
        group.addTask {
          await actorCache.set(key, value: key + 1)
        }
      }
    }
  }
}
