import UIKit

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

struct AnyRandomNumberGenerator: RandomNumberGenerator {
  var rng: RandomNumberGenerator
  mutating func next() -> UInt64 {
    return rng.next()
  }
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

extension Gen {
  func map<B>(_ f: @escaping (A) -> B) -> Gen<B> {
    return Gen<B> { rng in f(self.run(&rng)) }
  }

  func flatMap<B>(_ f: @escaping (A) -> Gen<B>) -> Gen<B> {
    return Gen<B> { rng in
      f(self.run(&rng)).run(&rng)
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

extension Gen where A: BinaryFloatingPoint, A.RawSignificand: FixedWidthInteger {
  static func float(in range: ClosedRange<A>) -> Gen {
    return Gen { rng in .random(in: range, using: &rng) }
  }
}

extension Gen where A: FixedWidthInteger {
  static func int(in range: ClosedRange<A>) -> Gen {
    return Gen { rng in .random(in: range, using: &rng) }
  }
}

extension Gen where A == Bool {
  static let bool = Gen { rng in .random(using: &rng) }
}

extension Gen {
  static func element(of xs: [A]) -> Gen<A?> {
    return Gen<A?> { rng in xs.randomElement(using: &rng) }
  }

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
  }

  static func always(_ a: A) -> Gen<A> {
    return Gen { _ in a }
  }
}

let canvas = CGRect(x: 0, y: 0, width: 300, height: 300)
let mainArea = canvas.insetBy(dx: 65, dy: 50)
let numLines = 80
let numPointsPerLine = 80
let dx = mainArea.width / CGFloat(numPointsPerLine)
let dy = mainArea.height / CGFloat(numLines)

func collect<A>(_ gens: [Gen<A>]) -> Gen<[A]> {
  return Gen<[A]> { rng in
    gens.map { gen in gen.run(using: &rng) }
  }
}
func f(_ x: CGFloat) -> CGFloat {
  if x <= 0 { return 0 }
  return exp(-1 / x)
}
func g(_ x: CGFloat) -> CGFloat {
  return f(x) / (f(x) + f(1 - x))
}
func bump(_ x: CGFloat) -> CGFloat {
  return g(x * x)
}
func bump(
  amplitude: CGFloat,
  center: CGFloat,
  plateauSize: CGFloat,
  curveSize: CGFloat
  ) -> (CGFloat) -> CGFloat {
  return { x in
    let plateauSize = plateauSize / 2
    let curveSize = curveSize / 2
    let size = plateauSize + curveSize
    let x = x - center
    return amplitude * (1 - g((x * x - plateauSize * plateauSize) / (size * size - plateauSize * plateauSize)))
  }
}

func noisyBump(
  amplitude: CGFloat,
  center: CGFloat,
  plateauSize: CGFloat,
  curveSize: CGFloat
  ) -> (CGFloat) -> Gen<CGFloat> {

  let curve = bump(amplitude: amplitude, center: center, plateauSize: plateauSize, curveSize: curveSize)

  return { x in
    let y = curve(x)
    return Gen<CGFloat>.float(in: 0...1.5).map { $0 * (y / amplitude + 0.5) + y }
  }
}

func path(
  from min: CGFloat,
  to max: CGFloat,
  baseline: CGFloat,
  amplitude: CGFloat,
  center: CGFloat,
  plateauSize: CGFloat,
  curveSize: CGFloat
  ) -> Gen<CGPath> {
  return Gen<CGPath> { rng in

    let offset = (center - 0.5) * 100

    let curve = zip4(
      with: noisyBump(amplitude:center:plateauSize:curveSize:)
    )(
      Gen<CGFloat>.float(in: 1...(1 + 30 * amplitude)).map { -$0 },
      Gen<CGFloat>.float(in: (-30 + offset)...(30 + offset)).map { $0 + canvas.width / 2 },
      Gen<CGFloat>.float(in: 0...(60 * plateauSize)),
      Gen<CGFloat>.float(in: (10 * curveSize)...(60 * curveSize))
      )
//      .run(using: &rng)

    let bumps = curve.array(of: .int(in: 1...4))
      .run(using: &rng)

    let path = CGMutablePath()
    path.move(to: CGPoint(x: min, y: baseline))
    stride(from: min, to: max, by: dx).forEach { x in
      let ys = bumps.map { $0(x).run(using: &rng) }
      let average = ys.reduce(0, +) / CGFloat(ys.count)
      path.addLine(to: CGPoint(x: x, y: baseline + average))
    }
    path.addLine(to: CGPoint.init(x: max, y: baseline))
    return path
  }
}

func paths(
  amplitude: CGFloat,
  center: CGFloat,
  plateauSize: CGFloat,
  curveSize: CGFloat
  ) -> Gen<[CGPath]> {
  return collect(
    stride(from: mainArea.minY, to: mainArea.maxY, by: dy)
      .map { path(
        from: mainArea.minX,
        to: mainArea.maxX,
        baseline: $0,
        amplitude: amplitude,
        center: center,
        plateauSize: plateauSize,
        curveSize: curveSize
        ) }
  )
}

func image(
  amplitude: CGFloat,
  center: CGFloat,
  plateauSize: CGFloat,
  curveSize: CGFloat,
  isPointFreeAnniversary: Bool
  ) -> Gen<UIImage> {
  return paths(
    amplitude: amplitude,
    center: center,
    plateauSize: plateauSize,
    curveSize: curveSize
    ).map { paths in
      UIGraphicsImageRenderer(bounds: canvas).image { ctx in
        let ctx = ctx.cgContext

        ctx.setFillColor(UIColor.black.cgColor)
        ctx.fill(canvas)

        ctx.setLineWidth(1.2)
        ctx.setStrokeColor(UIColor.white.cgColor)

        paths.enumerated().forEach { idx, path in
          if isPointFreeAnniversary {
            ctx.setStrokeColor(
              pointFreeColors[pointFreeColors.count * idx / paths.count].cgColor
            )
          }
          ctx.addPath(path)
          ctx.drawPath(using: .fillStroke)
        }
      }
  }
}

let pointFreeColors = [
  UIColor(red: 0.47, green: 0.95, blue: 0.69, alpha: 1),
  UIColor(red: 1, green: 0.94, blue: 0.5, alpha: 1),
  UIColor(red: 0.3, green: 0.80, blue: 1, alpha: 1),
  UIColor(red: 0.59, green: 0.30, blue: 1, alpha: 1)
]
