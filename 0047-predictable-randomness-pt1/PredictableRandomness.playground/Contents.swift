
struct AnyRandomNumberGenerator: RandomNumberGenerator {
  var rng: RandomNumberGenerator
  mutating func next() -> UInt64 {
    return rng.next()
  }
}

do {
  let a = 1
  _ = a + 1
}

struct Gen<A> {
  let run: (inout AnyRandomNumberGenerator) -> A

  func run<RNG: RandomNumberGenerator>(using rng: inout RNG) -> A {
    var arng = AnyRandomNumberGenerator(rng: rng)
    let result = self.run(&arng)
    rng = arng.rng as! RNG
    return result
  }
}


//import Darwin
//let random = Gen(run: arc4random)
//
//random.run()
//random.run()
//random.run()
//random.run()
//random.run()


extension Gen {
  func map<B>(_ f: @escaping (A) -> B) -> Gen<B> {
    return Gen<B> { rng in f(self.run(&rng)) }
  }
}


//let uniform = random.map { Double($0) / Double(UInt32.max) }


// extension BinaryFloatingPoint where Self.RawSignificand : FixedWidthInteger {
//     public static func random<T>(in range: Range<Self>, using generator: inout T) -> Self where T : RandomNumberGenerator
//     public static func random(in range: Range<Self>) -> Self
//     public static func random<T>(in range: ClosedRange<Self>, using generator: inout T) -> Self where T : RandomNumberGenerator
//     public static func random(in range: ClosedRange<Self>) -> Self
// }


extension Gen where A: BinaryFloatingPoint, A.RawSignificand: FixedWidthInteger {
  static func float(in range: ClosedRange<A>) -> Gen {
  //  return uniform.map { t in
  //    t * (range.upperBound - range.lowerBound) + range.lowerBound
  //  }
    return Gen { rng in .random(in: range, using: &rng) }
  }
}

import UIKit
var srng = SystemRandomNumberGenerator()

Gen<CGFloat>.float(in: 0...1).run(using: &srng)
Gen<CGFloat>.float(in: 0...1).run(using: &srng)
Gen<CGFloat>.float(in: 0...1).run(using: &srng)
Gen<CGFloat>.float(in: 0...1).run(using: &srng)
Gen<CGFloat>.float(in: 0...1).run(using: &srng)

// a * pow(2, n)
12345.0.significand
12345.0.exponent

1.5069580078125 * pow(2 as Double, 13)


//let uint64 = Gen<UInt64> {
//  let lower = UInt64(random.run())
//  let upper = UInt64(random.run()) << 32
//  return lower + upper
//}

//Int.random(in: <#T##ClosedRange<Int>#>, using: &<#T##RandomNumberGenerator#>)

Int.random(in: 1...10, using: &srng)

Int.random(in: 1...10)

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
//lcrng.seed = 0
Int.random(in: 1...10, using: &lcrng)
Int.random(in: 1...10, using: &lcrng)
Int.random(in: 1...10, using: &lcrng)
Int.random(in: 1...10, using: &lcrng)
Int.random(in: 1...10, using: &lcrng)

struct Environment {
  var rng = AnyRandomNumberGenerator(rng: SystemRandomNumberGenerator())
}
var Current = Environment()

Int.random(in: 0...100, using: &Current.rng)
Int.random(in: 0...100, using: &Current.rng)
Int.random(in: 0...100, using: &Current.rng)
Int.random(in: 0...100, using: &Current.rng)

Current.rng = AnyRandomNumberGenerator(rng: LCRNG(seed: 0))

Int.random(in: 0...100, using: &Current.rng)
Int.random(in: 0...100, using: &Current.rng)
Int.random(in: 0...100, using: &Current.rng)
Int.random(in: 0...100, using: &Current.rng)
//Current.rng = SystemRandomNumberGenerator()


var globalRng = AnyRandomNumberGenerator(rng: SystemRandomNumberGenerator())

extension Gen where A: FixedWidthInteger {
  static func int(in range: ClosedRange<A>) -> Gen {
    return Gen { rng in .random(in: range, using: &rng) }
  }

//  static func int<RNG: RandomNumberGenerator>(in range: ClosedRange<A>, using rng: RNG) -> Gen {
//  return Gen<Int> {
//    var delta = UInt64(truncatingIfNeeded: range.upperBound &- range.lowerBound)
//    if delta == UInt64.max {
//      return Int(truncatingIfNeeded: uint64.run())
//    }
//    delta += 1
//    let tmp = UInt64.max % delta + 1
//    let upperBound = tmp == delta ? 0 : tmp
//    var random: UInt64 = 0
//    repeat {
//      random = uint64.run()
//    } while random < upperBound
//    return Int(
//      truncatingIfNeeded: UInt64(truncatingIfNeeded: range.lowerBound)
//        &+ random % delta
//    )
//  }
//    return Gen {
//      var rng = rng
//      return A.random(in: range, using: &rng)
//    }
//  }
}

let numbers = Gen<Int>.int(in: 1...10)
let stringNumbers = numbers.map(String.init)

globalRng = AnyRandomNumberGenerator(rng: LCRNG(seed: 0))
Gen<UInt64>.int(in: .min ... .max).run(using: &srng)
Gen<UInt64>.int(in: .min ... .max).run(using: &srng)
Gen<UInt64>.int(in: .min ... .max).run(using: &srng)
Gen<UInt64>.int(in: .min ... .max).run(using: &srng)
Gen<UInt64>.int(in: .min ... .max).run(using: &srng)

globalRng = AnyRandomNumberGenerator(rng: LCRNG(seed: 0))
Gen<UInt64>.int(in: .min ... .max).run(using: &srng)
Gen<UInt64>.int(in: .min ... .max).run(using: &srng)
Gen<UInt64>.int(in: .min ... .max).run(using: &srng)
Gen<UInt64>.int(in: .min ... .max).run(using: &srng)
Gen<UInt64>.int(in: .min ... .max).run(using: &srng)



extension Gen where A == Bool {
  //let bool = int(in: 0...1).map { $0 == 1 }
  static let bool = Gen { rng in .random(using: &rng) }
}


extension Gen {
  static func element(of xs: [A]) -> Gen<A?> {
  //  return int(in: 0...(xs.count - 1)).map { idx in
  //    guard !xs.isEmpty else { return nil }
  //    return xs[idx]
  //  }
    return Gen<A?> { rng in xs.randomElement(using: &rng) }
  }
}

extension Gen {
  func flatMap<B>(_ f: @escaping (A) -> Gen<B>) -> Gen<B> {
    return Gen<B> { rng in
      let a = self.run(&rng)
      let genB = f(a)
      let b = genB.run(&rng)
      return b
    }
  }
}

extension Gen {
  func array(of count: Gen<Int>) -> Gen<[A]> {
    return count.flatMap { count in
      Gen<[A]> { rng -> [A] in
        var array: [A] = []
        for _ in 1...count {
          array.append(self.run(&rng))
        }
        return array
      }
    }

    return Gen<[A]> { rng in
      let numberOfElements = count.run(&rng)
      var result: [A] = []
      (0..<numberOfElements).forEach { idx in
        result.append(self.run(&rng))
      }
      return result
    }
  }
}


func zip<A, B>(_ ga: Gen<A>, _ gb: Gen<B>) -> Gen<(A, B)> {
  return Gen<(A, B)> { rng in
    (ga.run(&rng), gb.run(&rng))
  }
}

func zip<A, B, C>(with f: @escaping (A, B) -> C) -> (Gen<A>, Gen<B>) -> Gen<C> {
  return { zip($0, $1).map(f) }
}


func zip4<A, B, C, D, Z>(
  with f: @escaping (A, B, C, D) -> Z
  ) -> (Gen<A>, Gen<B>, Gen<C>, Gen<D>) -> Gen<Z> {

  return { a, b, c, d in
    Gen<Z> { rng in
      f(a.run(&rng), b.run(&rng), c.run(&rng), d.run(&rng)) }
  }
}

//Gen<UIColor>

extension Gen {
  static func always(_ a: A) -> Gen<A> {
    return Gen { _ in a }
  }
}

let color = zip4(with: UIColor.init(red:green:blue:alpha:))(
  .float(in: 0...1),
  .float(in: 0...1),
  .float(in: 0...1),
  .always(1)
)

color.run(using: &srng)
color.run(using: &srng)
color.run(using: &srng)
color.run(using: &srng)
color.run(using: &srng)

let pixel: Gen<UIImage> = color.map { color -> UIImage in
  let rect = CGRect.init(x: 0, y: 0, width: 1, height: 1)
  return UIGraphicsImageRenderer.init(bounds: rect).image { ctx in
    ctx.cgContext.setFillColor(color.cgColor)
    ctx.cgContext.fill(rect)
  }
}

pixel.run(using: &srng)
pixel.run(using: &srng)
pixel.run(using: &srng)
pixel.run(using: &srng)

let rect = zip4(with: CGRect.init(x:y:width:height:))(
  Gen<CGFloat>.always(0),
  .always(0),
  .float(in: 50...400),
  .float(in: 50...400)
)

rect.run(using: &srng)
rect.run(using: &srng)
rect.run(using: &srng)
rect.run(using: &srng)

let pixelImageView = zip(pixel, rect).map { pixel, rect -> UIImageView in
  let imageView = UIImageView(image: pixel)
  imageView.bounds = rect
  return imageView
}

//var anylcrng = AnyRandomNumberGenerator(rng: LCRNG(seed: 0))

lcrng.seed
pixelImageView.run(using: &lcrng)
pixelImageView.run(using: &lcrng)
pixelImageView.run(using: &lcrng)
pixelImageView.run(using: &lcrng)
lcrng.seed
