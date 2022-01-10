import Network
import PathMonitorClient

extension PathMonitorClient {
  public static func live(queue: DispatchQueue) -> Self {
    Self(
      networkPathUpdates: .init { continuation in
        let monitor = NWPathMonitor()
        monitor.start(queue: queue) // TODO: To make lazy, add `PathMonitorClient.start/cancel`
        monitor.pathUpdateHandler = { path in
          continuation.yield(NetworkPath(rawValue: path))
        }
        continuation.onTermination = { @Sendable [cancel = monitor.cancel] _ in
          cancel()
        }
      }
    )
  }
}
