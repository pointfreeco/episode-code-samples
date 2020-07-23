import Foundation
import Network

extension PathMonitorClient {
  public static let satisfied = Self(
    cancel: { },
    setPathUpdateHandler: { callback in
      callback(NetworkPath(status: .satisfied))
    },
    start: { _ in }
  )

  public static let unsatisfied = Self(
    cancel: { },
    setPathUpdateHandler: { callback in
      callback(NetworkPath(status: .unsatisfied))
    },
    start: { _ in }
  )

  public static let flakey = Self(
    cancel: { },
    setPathUpdateHandler: { callback in
      var status = NWPath.Status.satisfied

      Timer.scheduledTimer(withTimeInterval: 2, repeats: true) { _ in
        callback(.init(status: status))
        status = status == .satisfied ? .unsatisfied : .satisfied
      }
    },
    start: { _ in }
  )
}
