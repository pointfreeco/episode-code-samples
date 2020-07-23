import Combine
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
  public var networkPathPublisher: AnyPublisher<NetworkPath, Never>

  public init(
    networkPathPublisher: AnyPublisher<NetworkPath, Never>
  ) {
    self.networkPathPublisher = networkPathPublisher
  }
}
