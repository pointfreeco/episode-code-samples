import ConcurrencyExtensions
import Foundation
import Network

extension PathMonitorClient {
  public static let satisfied = Self(
    networkPathUpdates: .yielding(NetworkPath(status: .satisfied))
  )

  public static let unsatisfied = Self(
    networkPathUpdates: .yielding(NetworkPath(status: .unsatisfied))
  )

  public static var flakey: Self {
    Self(
      networkPathUpdates: .init { continuation in
//        var status = NWPath.Status.unsatisfied
//        let timer = Timer.scheduledTimer(withTimeInterval: 2, repeats: true) { _ in
//          status = status == .satisfied ? .unsatisfied : .satisfied
//          continuation.yield(NetworkPath(status: status))
//        }
//        continuation.onTermination = { @Sendable _ in
//          timer.invalidate()
//        }
        var status = NWPath.Status.unsatisfied
        while !Task.isCancelled {
          try? await Task.sleep(nanoseconds: 2 * NSEC_PER_SEC)
          if Task.isCancelled { break }
          status = status == .satisfied ? .unsatisfied : .satisfied
          continuation.yield(NetworkPath(status: status))
        }
      }
    )
  }
}
