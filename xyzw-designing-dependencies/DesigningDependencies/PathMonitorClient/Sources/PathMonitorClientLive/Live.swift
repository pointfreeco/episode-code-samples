import Network
import PathMonitorClient

extension PathMonitorClient {
  public static var live: Self {
    let monitor = NWPathMonitor()

    return Self(
      cancel: { monitor.cancel() },
      setPathUpdateHandler: { callback in
        monitor.pathUpdateHandler = { path in
          callback(NetworkPath(rawValue: path))
        }
      },
      start: monitor.start(queue:)
    )
  }
}
