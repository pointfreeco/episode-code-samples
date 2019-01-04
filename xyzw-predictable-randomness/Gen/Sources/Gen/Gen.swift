import UIKit

public struct AnyRandomNumberGenerator: RandomNumberGenerator {
  var rng: RandomNumberGenerator

  public init(_ rng: RandomNumberGenerator) {
    self.rng = rng
  }

  public mutating func next() -> UInt64 {
    return self.rng.next()
  }
}

public struct LCRNG: RandomNumberGenerator {
  public var seed: UInt64

  public init(seed: UInt64) {
    self.seed = seed
  }

  public mutating func next() -> UInt64 {
    seed = 2862933555777941757 &* seed &+ 3037000493
    return seed
  }
}

public struct Gen<A> {
  let gen: (inout AnyRandomNumberGenerator) -> A

  public func run<G: RandomNumberGenerator>(using rng: inout G) -> A {
    var arng = AnyRandomNumberGenerator(rng)
    defer { rng = arng.rng as! G }
    return self.gen(&arng)
  }

  public func run() -> A {
    var rng = SystemRandomNumberGenerator()
    return self.run(using: &rng)
  }
}

extension Gen {
  public func map<B>(_ f: @escaping (A) -> B) -> Gen<B> {
    return Gen<B> { rng in f(self.gen(&rng)) }
  }
}

public func zip<A, B>(_ ga: Gen<A>, _ gb: Gen<B>) -> Gen<(A, B)> {
  return Gen<(A, B)> { rng in
    (ga.gen(&rng), gb.gen(&rng))
  }
}

public func zip<A, B, C>(_ ga: Gen<A>, _ gb: Gen<B>, _ gc: Gen<C>) -> Gen<(A, B, C)> {
  return zip(zip(ga, gb), gc).map { ($0.0, $0.1, $1) }
}

public func zip<A, B, C, D>(_ ga: Gen<A>, _ gb: Gen<B>, _ gc: Gen<C>, _ gd: Gen<D>) -> Gen<(A, B, C, D)> {
  return zip(zip(ga, gb), gc, gd).map { ($0.0, $0.1, $1, $2) }
}

public func zip<A, B, C, D, E>(_ ga: Gen<A>, _ gb: Gen<B>, _ gc: Gen<C>, _ gd: Gen<D>, _ ge: Gen<E>) -> Gen<(A, B, C, D, E)> {
  return zip(zip(ga, gb), gc, gd, ge).map { ($0.0, $0.1, $1, $2, $3) }
}

extension Gen {
  public func flatMap<B>(_ f: @escaping (A) -> Gen<B>) -> Gen<B> {
    return Gen<B> { rng in
      f(self.run(using: &rng)).run(using: &rng)
    }
  }
}

extension Gen where A == Int {
  public static func int(in range: ClosedRange<Int>) -> Gen {
    return Gen { rng in Int.random(in: range, using: &rng) }
  }
}

extension Gen where A == CGFloat {
  public static func cgFloat(in range: ClosedRange<CGFloat>) -> Gen {
    return Gen { rng in CGFloat.random(in: range, using: &rng) }
  }
}

extension Gen where A == Double {
  public static func double(in range: ClosedRange<Double>) -> Gen {
    return Gen { rng in Double.random(in: range, using: &rng) }
  }
}

extension Gen where A == Bool {
  public static let bool = Gen { rng in Bool.random(using: &rng) }
}

extension Gen where A: Collection {
  public var element: Gen<A.Element?> {
    return Gen<A.Element?> { rng in
      self.gen(&rng).randomElement(using: &rng)
    }
  }
}

extension Gen {
  public static func always(_ a: A) -> Gen {
    return Gen { _ in a }
  }

  public func array(of count: Gen<Int>) -> Gen<[A]> {
    return count.flatMap { count in
      Gen<[A]> { rng in
        Array(repeating: (), count: count)
          .map { self.run(using: &rng) }
      }
    }
  }
}

extension Sequence {
  public func sequence<A>() -> Gen<[A]> where Element == Gen<A> {
    return Gen<[A]> { rng in
      self.map { $0.run(using: &rng) }
    }
  }
}
