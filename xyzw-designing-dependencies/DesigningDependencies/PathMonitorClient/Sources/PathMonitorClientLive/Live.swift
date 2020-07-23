import Combine
import Network
import PathMonitorClient

extension PathMonitorClient {
  public static func live(queue: DispatchQueue) -> Self {
    let monitor = NWPathMonitor()
    let subject = PassthroughSubject<NWPath, Never>()
    monitor.pathUpdateHandler = subject.send

    return Self(
//      cancel: { monitor.cancel() },
//      setPathUpdateHandler: { callback in
//        monitor.pathUpdateHandler = { path in
//          callback(NetworkPath(rawValue: path))
//        }
//      },
//      start: monitor.start(queue:)
      networkPathPublisher: subject
        .handleEvents(
          receiveSubscription: { _ in monitor.start(queue: queue) },
          receiveCancel: monitor.cancel
        )
        .map(NetworkPath.init(rawValue:))
        .eraseToAnyPublisher()
    )
  }
}
