import Network

public struct NetworkPath {
  public var status: NWPath.Status

  public init(status: NWPath.Status) {
    self.status = status
  }
}

extension NetworkPath {
  public init(rawValue: NWPath) {
    self.status = rawValue.status
  }
}

public struct PathMonitorClient {
  public var cancel: () -> Void
  public var setPathUpdateHandler: (@escaping (NetworkPath) -> Void) -> Void
  public var start: (DispatchQueue) -> Void

  public init(
    cancel: @escaping () -> Void,
    setPathUpdateHandler: @escaping (@escaping (NetworkPath) -> Void) -> Void,
    start: @escaping (DispatchQueue) -> Void
  ) {
    self.cancel = cancel
    self.setPathUpdateHandler = setPathUpdateHandler
    self.start = start
  }
}
