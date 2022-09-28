import SwiftUI

public struct ImmediateClock: Clock {
  public func sleep(until deadline: Instant, tolerance: Duration?) async throws {
  }

  public var now = Instant()
  public var minimumResolution = Duration.zero

  public typealias Duration = Swift.Duration
  public struct Instant: InstantProtocol {
    private var offset: Duration = .zero

    public func advanced(by duration: Duration) -> Self {
      .init(offset: self.offset + duration)
    }

    public func duration(to other: Self) -> Duration {
      other.offset - self.offset
    }

    public static func < (lhs: Self, rhs: Self) -> Bool {
      lhs.offset < rhs.offset
    }

    public typealias Duration = Swift.Duration
  }
}

import XCTestDynamicOverlay
public struct UnimplementedClock: Clock {
  public func sleep(until deadline: Instant, tolerance: Duration?) async throws {
    XCTFail("Clock.sleep is unimplemented")
  }

  public var now: Instant {
    XCTFail("Clock.now is unimplemented")
    return Instant()
  }
  public var minimumResolution = Duration.zero

  public typealias Duration = Swift.Duration
  public struct Instant: InstantProtocol {
    private var offset: Duration = .zero

    public func advanced(by duration: Duration) -> Self {
      .init(offset: self.offset + duration)
    }

    public func duration(to other: Self) -> Duration {
      other.offset - self.offset
    }

    public static func < (lhs: Self, rhs: Self) -> Bool {
      lhs.offset < rhs.offset
    }

    public typealias Duration = Swift.Duration
  }

}

// any Sequence<Int>
// any Sequence<any Iterator<Int>>

extension Clock {
  /// Suspends for the given duration.
  public func sleep(
    for duration: Duration,
    tolerance: Duration? = nil
  ) async throws {
    try await self.sleep(until: self.now.advanced(by: duration), tolerance: tolerance)
  }
}

@MainActor
class FeatureModel: ObservableObject {
  @Published var message = ""
  @Published var count = 0

  let clock: any Clock<Duration>

  init(
    clock: any Clock<Duration>,
    count: Int = 0
  ) {
    self.clock = clock
    self.count = count
  }

  func task() async {
    do {
//      try await Task.sleep(for: .seconds(5))
      try await self.clock.sleep(for: .seconds(5))
      withAnimation {
        self.message = "Welcome!"
      }
    } catch {}
  }

  func incrementButtonTapped() {
    self.count += 1
  }
  func decrementButtonTapped() {
    self.count -= 1
  }

  func nthPrimeButtonTapped() async {
    let duration = await self.clock.measure {
      var primeCount = 0
      var prime = 2
      while primeCount < self.count {
        defer { prime += 1 }
        if isPrime(prime) {
          primeCount += 1
        } else if prime.isMultiple(of: 1_000) {
          await Task.yield()
        }
      }
      self.message = "\(self.count)th prime is \(prime - 1)"
    }
    // TODO: track this duration with our analytics backend
    _ = duration
  }
  private func isPrime(_ p: Int) -> Bool {
    if p <= 1 { return false }
    if p <= 3 { return true }
    for i in 2...Int(sqrtf(Float(p))) {
      if p % i == 0 { return false }
    }
    return true
  }
}

struct ContentView: View {
  @ObservedObject var model: FeatureModel

  var body: some View {
    VStack {
      Text(model.message)
        .font(.largeTitle.bold())
        .foregroundStyle(
          LinearGradient(
            colors: [.mint, .yellow, .orange],
            startPoint: .leading,
            endPoint: .trailing
          )
        )

      HStack {
        Button("-") { self.model.decrementButtonTapped() }
        Text("\(self.model.count)")
        Button("+") { self.model.incrementButtonTapped() }
      }
      Button("\(self.model.count)th prime") {
        Task { await self.model.nthPrimeButtonTapped() }
      }
    }
    .task {
      await model.task()
    }
  }
}

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    ContentView(model: FeatureModel(clock: ImmediateClock()))
  }
}
