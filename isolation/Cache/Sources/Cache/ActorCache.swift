public actor ActorCache<Key: Hashable & Sendable, Value: Sendable> {
  private var cache: [Key: Value] = [:]

  public init(initialCache: [Key: Value]) {
    cache = initialCache
  }

  public init() where Key == Int, Value == Int {
    var initialCache: [Int: Int] = [:]
    initialCache.reserveCapacity(cacheSize)
    for value in 0..<cacheSize {
      initialCache[value] = value
    }
    cache = initialCache
  }

  public func keys() -> some Collection<Key> {
    cache.keys
  }

  public func get(_ key: Key) -> Value? {
    cache[key]
  }

  public func set(_ key: Key, value: Value) {
    cache[key] = value
  }

  public func remove(_ key: Key) {
    cache[key] = nil
  }
}
