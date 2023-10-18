import Foundation

/// A path that supports embedding a value in a root and attempting to extract a root's embedded
/// value.
///
/// This type defines key path-like semantics for enum cases.
public struct CasePath<Root, Value> {
  private let _embed: (Value) -> Root
  private let _extract: (Root) -> Value?

  /// Creates a case path with a pair of functions.
  ///
  /// - Parameters:
  ///   - embed: A function that always succeeds in embedding a value in a root.
  ///   - extract: A function that can optionally fail in extracting a value from a root.
  public init(
    embed: @escaping (Value) -> Root,
    extract: @escaping (Root) -> Value?
  ) {
    self._embed = {
      lock.lock()
      defer { lock.unlock() }
      return embed($0)
    }
    self._extract = {
      lock.lock()
      defer { lock.unlock() }
      return extract($0)
    }
  }

  /// Returns a root by embedding a value.
  ///
  /// - Parameter value: A value to embed.
  /// - Returns: A root that embeds `value`.
  public func embed(_ value: Value) -> Root {
    self._embed(value)
  }

  /// Attempts to extract a value from a root.
  ///
  /// - Parameter root: A root to extract from.
  /// - Returns: A value if it can be extracted from the given root, otherwise `nil`.
  public func extract(from root: Root) -> Value? {
    self._extract(root)
  }

  /// Attempts to modify a value in a root.
  ///
  /// - Parameters:
  ///   - root: A root to modify if the case path matches.
  ///   - body: A closure that can mutate the case's associated value. If the closure throws, the root
  ///     will be left unmodified.
  /// - Returns: The return value, if any, of the body closure.
  public func modify<Result>(
    _ root: inout Root,
    _ body: (inout Value) throws -> Result
  ) throws -> Result {
    guard var value = self.extract(from: root) else { throw ExtractionFailed() }
    let result = try body(&value)
    root = self.embed(value)
    return result
  }

  /// Returns a new case path created by appending the given case path to this one.
  ///
  /// Use this method to extend this case path to the value type of another case path.
  ///
  /// - Parameter path: The case path to append.
  /// - Returns: A case path from the root of this case path to the value type of `path`.
  public func appending<AppendedValue>(path: CasePath<Value, AppendedValue>) -> CasePath<
    Root, AppendedValue
  > {
    CasePath<Root, AppendedValue>(
      embed: { self.embed(path.embed($0)) },
      extract: { self.extract(from: $0).flatMap(path.extract) }
    )
  }
}

#if canImport(_Concurrency) && compiler(>=5.5.2)
  extension CasePath: @unchecked Sendable {}
#endif

extension CasePath: CustomStringConvertible {
  public var description: String {
    "CasePath<\(typeName(Root.self)), \(typeName(Value.self))>"
  }
}

struct ExtractionFailed: Error {}

private let lock = NSRecursiveLock()
