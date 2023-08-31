import Foundation

@attached(accessor)
@attached(peer, names: arbitrary)
public macro Default<T: Codable>(_ value: T) = #externalMacro(module: "MacroKitMacros", type: "DefaultMacro")

public protocol DefaultValue {
    associatedtype Value: Codable

    static var value: Value { get }
}

@propertyWrapper
public struct Default<Default: DefaultValue>: Codable {
    public var wrappedValue: Default.Value

    public init(wrappedValue: Default.Value) {
        self.wrappedValue = wrappedValue
    }
    public init(value: Default.Value?) {
        self.wrappedValue = value ?? Default.value
    }
    public func encode(to encoder: Encoder) throws {
        try wrappedValue.encode(to: encoder)
    }
}

extension Default: Equatable where Default.Value: Equatable {
    public static func ==(lhs: Self, rhs: Self) -> Bool {
        return lhs.wrappedValue == rhs.wrappedValue
    }
}

extension Default: Hashable where Default.Value: Hashable {
    public func hash(into hasher: inout Hasher) {
        wrappedValue.hash(into: &hasher)
    }
}

extension KeyedDecodingContainer {
    public func decode<T: DefaultValue>(_ type: Default<T>.Type, forKey key: KeyedDecodingContainer.Key) throws -> Default<T> {
        return Default<T>(value: try decodeIfPresent(T.Value.self, forKey: key))
    }
}

