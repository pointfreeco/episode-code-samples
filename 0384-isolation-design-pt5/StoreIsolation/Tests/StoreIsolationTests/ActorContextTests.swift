import Testing

@MainActor
@Test
func inheritActorContext() async throws {
  let task = Task {
    MainActor.assertIsolated()
  }
  await task.value
}

actor MyActor {
  @Test
  func inheritActorContext() async throws {
    let task = Task {
      self.assertIsolated()
    }
    await task.value
  }
}

@MainActor
@Test func inheritActorContext_Failure() async throws {
  await #expect(processExitsWith: .failure) {
    nonisolated(nonsending) func assert() async {
      MainActor.assertIsolated()
      let task = Task {
        MainActor.assertIsolated()
      }
      await task.value
    }
    await assert()
  }
}

@MainActor
@Test func inheritActorContext_Always() async throws {
  nonisolated(nonsending) func assert() async {
    MainActor.assertIsolated()
    let task = {
      MainActor.assumeIsolated { /*@MainActor*/
        Task.immediate {
          MainActor.assertIsolated()
          for _ in 1...100 {
            await Task.yield()
          }
          try! await Task.sleep(for: .seconds(1))
          MainActor.assertIsolated()
        }
      }
    }()
    await task.value
  }
  await assert()
}
