struct AnyRandomNumberGenerator: RandomNumberGenerator {
  var rng: RandomNumberGenerator

  mutating func next() -> UInt64 {
    return self.rng.next()
  }
}

struct Gen<A> {
  let run: (inout AnyRandomNumberGenerator) -> A
}


import Darwin
//let random = Gen(run: arc4random)
//
//random.run()
//random.run()
//random.run()
//random.run()
//random.run()

//Int.random(in: <#T##ClosedRange<Int>#>, using: &<#T##RandomNumberGenerator#>)

Int.random(in: 1...10)

var srng = SystemRandomNumberGenerator()
Int.random(in: 1...10, using: &srng)

//RandomNumberGenerator

struct MockRandomNumberGenerator: RandomNumberGenerator {
  mutating func next() -> UInt64 {
    return 42
  }
}

var mrng = MockRandomNumberGenerator()
Int.random(in: 1...10, using: &mrng)
Int.random(in: 1...10, using: &mrng)
Int.random(in: 1...10, using: &mrng)
Int.random(in: 1...10, using: &mrng)
Int.random(in: 1...10, using: &mrng)


struct LCRNG: RandomNumberGenerator {
  var seed: UInt64

  init(seed: UInt64) {
    self.seed = seed
  }

  mutating func next() -> UInt64 {
    seed = 2862933555777941757 &* seed &+ 3037000493
    return seed
  }
}

var lcrng = LCRNG(seed: 0)
Int.random(in: 1...10, using: &lcrng)
Int.random(in: 1...10, using: &lcrng)
Int.random(in: 1...10, using: &lcrng)
Int.random(in: 1...10, using: &lcrng)
Int.random(in: 1...10, using: &lcrng)
lcrng.seed

//lcrng.seed = 0
Int.random(in: 1...10, using: &lcrng)
Int.random(in: 1...10, using: &lcrng)
Int.random(in: 1...10, using: &lcrng)
Int.random(in: 1...10, using: &lcrng)
Int.random(in: 1...10, using: &lcrng)



extension Gen {
  func map<B>(_ f: @escaping (A) -> B) -> Gen<B> {
    return Gen<B> { rng in f(self.run(&rng)) }
  }
}


//let uniform = random.map { Double($0) / Double(UInt32.max) }

// a * pow(2, n)

12345.0.significand
12345.0.exponent

//1.5069580078125 * pow(2, 13)


// extension BinaryFloatingPoint where Self.RawSignificand : FixedWidthInteger {
//     public static func random<T>(in range: Range<Self>, using generator: inout T) -> Self where T : RandomNumberGenerator
//     public static func random(in range: Range<Self>) -> Self
//     public static func random<T>(in range: ClosedRange<Self>, using generator: inout T) -> Self where T : RandomNumberGenerator
//     public static func random(in range: ClosedRange<Self>) -> Self
// }

extension Gen where A: BinaryFloatingPoint, A.RawSignificand: FixedWidthInteger {
  static func float(in range: ClosedRange<A>) -> Gen {
    return Gen { rng in .random(in: range, using: &rng) }
  }
}

import UIKit

Gen<CGFloat>.float(in: 0...1)

//let uint64 = Gen<UInt64> {
//  let lower = UInt64(random.run())
//  let upper = UInt64(random.run()) << 32
//  return lower + upper
//}

extension Gen where A: FixedWidthInteger {
  static func int(in range: ClosedRange<A>) -> Gen {
    return Gen { rng in .random(in: range, using: &rng) }
  }
}

//Gen<UInt64>.int(in: .min ... .max, using: lcrng)
//Gen<UInt64>.int(in: .min ... .max)
//
//Gen<UInt64>.int(in: .min ... .max, using: lcrng).map { "\($0)" }

extension Gen where A == Bool {
  static let bool = Gen { rng in .random(using: &rng) }
}

extension Gen {
  func element(of xs: [A]) -> Gen<A?> {
    return Gen<A?> { rng in xs.randomElement(using: &rng) }
  }
}


extension Gen {
  func array(of count: Gen<Int>) -> Gen<[A]> {
    return Gen<[A]> { rng in
      let _: Gen<Gen<[A]>> = count.map { count in
        var array: [A] = []
        for _ in 1...count {
//          array.append(self.run(&rng))
        }
        return array
      }
    }
  }
}


func zip<A, B>(_ ga: Gen<A>, _ gb: Gen<B>) -> Gen<(A, B)> {
  return Gen<(A, B)> { rng in
    (ga.run(&rng), gb.run(&rng))
  }
}

func zip4<A, B, C, D, Z>(
  with f: @escaping (A, B, C, D) -> Z
  ) -> (Gen<A>, Gen<B>, Gen<C>, Gen<D>) -> Gen<Z> {

  return { a, b, c, d in
    Gen<Z> { rng in f(a.run(&rng), b.run(&rng), c.run(&rng), d.run(&rng)) }
  }
}

extension Gen {
  static func always(_ a: A) -> Gen<A> {
    return Gen { _ in a }
  }
}

let randomColor = zip4(with: UIColor.init(red:green:blue:alpha:))(
  .float(in: 0...1),
  .float(in: 0...1),
  .float(in: 0...1),
  .always(1)
)

let randomPixel = randomColor.map { color -> UIImage in
  UIGraphicsImageRenderer(bounds: .init(x: 0, y: 0, width: 1, height: 1)).image { ctx in
    ctx.cgContext.setFillColor(color.cgColor)
    ctx.cgContext.fill(CGRect.init(x: 0, y: 0, width: 1, height: 1))
  }
}

//randomPixel.run()

let randomRect = zip4(with: CGRect.init(x:y:width:height:))(
  Gen<CGFloat>.always(0),
  .always(0),
  .float(in: 50...400),
  .float(in: 50...400)
)

let randomImageView = zip(randomPixel, randomRect).map { pixel, rect -> UIImageView in
  let imageView = UIImageView.init(frame: rect)
  imageView.image = pixel
  return imageView
}

import PlaygroundSupport
//PlaygroundPage.current.liveView = randomImageView.run()
