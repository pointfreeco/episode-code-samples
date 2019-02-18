
struct AnyRandomNumberGenerator: RandomNumberGenerator {
  var rng: RandomNumberGenerator
  mutating func next() -> UInt64 {
    return rng.next()
  }
}

struct Gen<A> {
  let run: () -> A
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
    return Gen<B> { f(self.run()) }
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
    return Gen { .random(in: range) }
  }
}

import UIKit
var srng = SystemRandomNumberGenerator()

Gen<CGFloat>.float(in: 0...1).run()
Gen<CGFloat>.float(in: 0...1).run()
Gen<CGFloat>.float(in: 0...1).run()
Gen<CGFloat>.float(in: 0...1).run()
Gen<CGFloat>.float(in: 0...1).run()

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


extension Gen where A: FixedWidthInteger {
  static func int(in range: ClosedRange<A>) -> Gen {
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
    return Gen { .random(in: range) }
  }
}

Gen<UInt64>.int(in: .min ... .max).run()
Gen<UInt64>.int(in: .min ... .max).run()
Gen<UInt64>.int(in: .min ... .max).run()
Gen<UInt64>.int(in: .min ... .max).run()
Gen<UInt64>.int(in: .min ... .max).run()



extension Gen where A == Bool {
  //let bool = int(in: 0...1).map { $0 == 1 }
  static let bool = Gen { .random() }
}


extension Gen {
  static func element(of xs: [A]) -> Gen<A?> {
  //  return int(in: 0...(xs.count - 1)).map { idx in
  //    guard !xs.isEmpty else { return nil }
  //    return xs[idx]
  //  }
    return Gen<A?> { xs.randomElement() }
  }
}


extension Gen {
  func array(of count: Gen<Int>) -> Gen<[A]> {
    return count.map { count in
      var array: [A] = []
      for _ in 1...count {
        array.append(self.run())
      }
      return array
    }
  }
}


func zip<A, B>(_ ga: Gen<A>, _ gb: Gen<B>) -> Gen<(A, B)> {
  return Gen<(A, B)> {
    (ga.run(), gb.run())
  }
}

func zip<A, B, C>(with f: @escaping (A, B) -> C) -> (Gen<A>, Gen<B>) -> Gen<C> {
  return { zip($0, $1).map(f) }
}


func zip4<A, B, C, D, Z>(
  with f: @escaping (A, B, C, D) -> Z
  ) -> (Gen<A>, Gen<B>, Gen<C>, Gen<D>) -> Gen<Z> {

  return { a, b, c, d in
    Gen<Z> {
      f(a.run(), b.run(), c.run(), d.run()) }
  }
}

//Gen<UIColor>

extension Gen {
  static func always(_ a: A) -> Gen<A> {
    return Gen { a }
  }
}

let color = zip4(with: UIColor.init(red:green:blue:alpha:))(
  .float(in: 0...1),
  .float(in: 0...1),
  .float(in: 0...1),
  .always(1)
)

color.run()
color.run()
color.run()
color.run()
color.run()

let pixel: Gen<UIImage> = color.map { color -> UIImage in
  let rect = CGRect.init(x: 0, y: 0, width: 1, height: 1)
  return UIGraphicsImageRenderer.init(bounds: rect).image { ctx in
    ctx.cgContext.setFillColor(color.cgColor)
    ctx.cgContext.fill(rect)
  }
}

pixel.run()
pixel.run()
pixel.run()
pixel.run()

let rect = zip4(with: CGRect.init(x:y:width:height:))(
  Gen<CGFloat>.always(0),
  .always(0),
  .float(in: 50...400),
  .float(in: 50...400)
)

rect.run()
rect.run()
rect.run()
rect.run()

let pixelImageView = zip(pixel, rect).map { pixel, rect -> UIImageView in
  let imageView = UIImageView(image: pixel)
  imageView.bounds = rect
  return imageView
}

pixelImageView.run()
pixelImageView.run()
pixelImageView.run()
pixelImageView.run()
