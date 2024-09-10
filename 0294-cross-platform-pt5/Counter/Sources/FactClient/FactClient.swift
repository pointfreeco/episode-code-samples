import Dependencies
import DependenciesMacros

@DependencyClient
public struct FactClient: Sendable {
  public var fetch: @Sendable (Int) async throws -> String
}

extension FactClient: TestDependencyKey {
  public static let testValue = FactClient()
}
