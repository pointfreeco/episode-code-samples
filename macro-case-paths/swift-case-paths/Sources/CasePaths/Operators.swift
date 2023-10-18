prefix operator /

/// Returns whether or not a root value matches a particular case path.
///
/// ```swift
/// [Result<Int, Error>.success(1), .success(2), .failure(NSError()), .success(4)]
///   .prefix(while: { /Result.success ~= $0 })
/// // [.success(1), .success(2)]
/// ```
///
/// - Parameters:
///   - pattern: A case path.
///   - value: A root value.
/// - Returns: Whether or not a root value matches a particular case path
public func ~= <Root, Value>(pattern: CasePath<Root, Value>, value: Root) -> Bool {
  pattern.extract(from: value) != nil
}

/// Returns a case path for the given embed function.
///
/// - Note: This operator is only intended to be used with enum case initializers. Its behavior is
///   otherwise undefined.
/// - Parameter embed: An embed function.
/// - Returns: A case path.
public prefix func / <Root, Value>(
  embed: @escaping (Value) -> Root
) -> CasePath<Root, Value> {
  .init(embed: embed, extract: extractHelp(embed))
}

/// Returns a case path for the given embed function.
///
/// - Note: This operator is only intended to be used with enum case initializers. Its behavior is
///   otherwise undefined.
/// - Parameter embed: An embed function.
/// - Returns: A case path.
public prefix func / <Root, Value>(
  embed: @escaping (Value) -> Root?
) -> CasePath<Root?, Value> {
  .init(embed: embed, extract: optionalPromotedExtractHelp(embed))
}

/// Returns a void case path for a case with no associated value.
///
/// - Note: This operator is only intended to be used with enum cases that have no associated
///   values. Its behavior is otherwise undefined.
/// - Parameter root: A case with no an associated value.
/// - Returns: A void case path.
public prefix func / <Root>(
  root: Root
) -> CasePath<Root, Void> {
  .init(embed: { root }, extract: extractVoidHelp(root))
}

/// Returns a void case path for a case with no associated value.
///
/// - Note: This operator is only intended to be used with enum cases that have no associated
///   values. Its behavior is otherwise undefined.
/// - Parameter root: A case with no an associated value.
/// - Returns: A void case path.
public prefix func / <Root>(
  root: Root?
) -> CasePath<Root?, Void> {
  .init(embed: { root }, extract: optionalPromotedExtractVoidHelp(root))
}

/// Returns the identity case path for the given type. Enables `/MyType.self` syntax.
///
/// - Parameter type: A type for which to return the identity case path.
/// - Returns: An identity case path.
public prefix func / <Root>(
  type: Root.Type
) -> CasePath<Root, Root> {
  .self
}

/// Identifies and returns a given case path. Enables shorthand syntax on static case paths, _e.g._
/// `/.self`  instead of `.self`, and `/.some` instead of `.some`.
///
/// - Parameter path: A case path to return.
/// - Returns: The case path.
public prefix func / <Root, Value>(
  path: CasePath<Root, Value>
) -> CasePath<Root, Value> {
  path
}

/// Returns a function that can attempt to extract associated values from the given enum case
/// initializer.
///
/// Use this operator to create new transform functions to pass to higher-order methods like
/// `compactMap`:
///
/// ```swift
/// [Result<Int, Error>.success(42), .failure(MyError()]
///   .compactMap(/Result.success)
/// // [42]
/// ```
///
/// - Note: This operator is only intended to be used with enum case initializers. Its behavior is
///   otherwise undefined.
/// - Parameter embed: An enum case initializer.
/// - Returns: A function that can attempt to extract associated values from an enum.
@_disfavoredOverload
public prefix func / <Root, Value>(
  embed: @escaping (Value) -> Root
) -> (Root) -> Value? {
  (/embed).extract(from:)
}

/// Returns a function that can attempt to extract associated values from the given enum case
/// initializer.
///
/// Use this operator to create new transform functions to pass to higher-order methods like
/// `compactMap`:
///
/// ```swift
/// [Result<Int, Error>.success(42), .failure(MyError()]
///   .compactMap(/Result.success)
/// // [42]
/// ```
///
/// - Note: This operator is only intended to be used with enum case initializers. Its behavior is
///   otherwise undefined.
/// - Parameter embed: An enum case initializer.
/// - Returns: A function that can attempt to extract associated values from an enum.
@_disfavoredOverload
public prefix func / <Root, Value>(
  embed: @escaping (Value) -> Root?
) -> (Root?) -> Value? {
  (/embed).extract(from:)
}

/// Returns a void case path for a case with no associated value.
///
/// - Note: This operator is only intended to be used with enum cases that have no associated
///   values. Its behavior is otherwise undefined.
/// - Parameter root: A case with no an associated value.
/// - Returns: A void case path.
@_disfavoredOverload
public prefix func / <Root>(
  root: Root
) -> (Root) -> Void? {
  (/root).extract(from:)
}

/// Returns a void case path for a case with no associated value.
///
/// - Note: This operator is only intended to be used with enum cases that have no associated
///   values. Its behavior is otherwise undefined.
/// - Parameter root: A case with no an associated value.
/// - Returns: A void case path.
@_disfavoredOverload
public prefix func / <Root>(
  root: Root
) -> (Root?) -> Void? {
  (/root).extract(from:)
}

precedencegroup CasePathCompositionPrecedence {
  associativity: left
}

infix operator ..: CasePathCompositionPrecedence

extension CasePath {
  /// Returns a new case path created by appending the given case path to this one.
  ///
  /// The operator version of ``appending(path:)``. Use this method to extend this case path to the
  /// value type of another case path.
  ///
  /// - Parameters:
  ///   - lhs: A case path from a root to a value.
  ///   - rhs: A case path from the first case path's value to some other appended value.
  /// - Returns: A new case path from the first case path's root to the second case path's value.
  public static func .. <AppendedValue>(
    lhs: CasePath,
    rhs: CasePath<Value, AppendedValue>
  ) -> CasePath<Root, AppendedValue> {
    lhs.appending(path: rhs)
  }

  /// Returns a new case path created by appending the given embed function.
  ///
  /// - Parameters:
  ///   - lhs: A case path from a root to a value.
  ///   - rhs: An embed function from an appended value.
  /// - Returns: A new case path from the first case path's root to the second embed function's
  ///   value.
  public static func .. <AppendedValue>(
    lhs: CasePath,
    rhs: @escaping (AppendedValue) -> Value
  ) -> CasePath<Root, AppendedValue> {
    lhs.appending(path: /rhs)
  }
}

/// Returns a new extract function by appending the given extract function with an embed function.
///
/// Useful when composing extract functions together.
///
/// ```swift
/// [Result<Int?, Error>.success(.some(42)), .success(nil), .failure(MyError())]
///   .compactMap(/Result.success..Optional.some)
/// // [42]
/// ```
///
/// - Parameters:
///   - lhs: An extract function from a root to a value.
///   - rhs: An embed function from some other appended value to the extract function's value.
/// - Returns: A new extract function from the first extract function's root to the second embed
///   function's appended value.
public func .. <Root, Value, AppendedValue>(
  lhs: @escaping (Root) -> Value?,
  rhs: @escaping (AppendedValue) -> Value
) -> (Root) -> AppendedValue? {
  return { root in lhs(root).flatMap((/rhs).extract(from:)) }
}
