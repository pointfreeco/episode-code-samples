import Foundation

@MainActor
class ViewModel: ObservableObject {
  @Published var count = 0

  func perform() async throws {
    await withThrowingTaskGroup(of: Void.self) { group in
      group.addTask { @MainActor in
        while true {
          try await Task.sleep(nanoseconds: NSEC_PER_SEC / 4)
          print(Thread.current, "Timer ticked")
        }
      }
      group.addTask { @MainActor in
        await asyncNthPrime(2_000_000)
      }
      for n in 0..<workCount {
        group.addTask { @MainActor in
          _ = try await URLSession.shared
            .data(from: .init(string: "http://ipv4.download.thinkbroadband.com/1MB.zip")!)
          print(Thread.current, "Download finished", n)
        }
      }
    }
  }
}

@main
struct Main {
  static func main() async throws {
    let viewModel = ViewModel()
    try await viewModel.perform()
    try await Task.sleep(nanoseconds: NSEC_PER_SEC)
  }
}
