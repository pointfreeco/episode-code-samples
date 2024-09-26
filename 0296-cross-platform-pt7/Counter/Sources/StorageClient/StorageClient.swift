import Foundation
import Dependencies
import DependenciesMacros

@DependencyClient
public struct StorageClient: Sendable {
  public var load: @Sendable (String) throws -> Data
  public var save: @Sendable (Data, _ to: String) throws -> Void
}

extension StorageClient: TestDependencyKey {
  public static let testValue = StorageClient()
}
