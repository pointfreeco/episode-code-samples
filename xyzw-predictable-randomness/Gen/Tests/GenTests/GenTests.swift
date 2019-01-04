import XCTest
@testable import Gen

final class GenTests: XCTestCase {
  func testExample() {
    var lcrng = LCRNG(seed: 0)
    measure {
      _ = image.run(using: &lcrng)
    }
  }
}

let canvas = CGRect(x: 0, y: 0, width: 625, height: 594)

let xMin: CGFloat = 140
let xMax = canvas.width - xMin
let yMin: CGFloat = 100
let yMax = canvas.height - yMin

let nPoints = 100
let nLines = 80

let dx = (xMax - xMin) / CGFloat(nPoints)
let dy = (yMax - yMin) / CGFloat(nLines)

func normal(mu: CGFloat, sigma: CGFloat) -> Gen<CGFloat> {
  return Gen.cgFloat(in: -1...1).array(of: .always(6))
    .map { mu + sigma * ($0.reduce(into: 0, +=) / 6) }
}

func normalPdf(_ x: CGFloat, mu: CGFloat, sigma: CGFloat) -> CGFloat {
  let sigma2 = pow(sigma, 2)
  let numerator = exp(-pow(x - mu, 2) / (2 * sigma2))
  let denominator = sqrt(2 * .pi * sigma2)
  return numerator / denominator
}

let mx = (xMin + xMax) / 2

let mu = normal(mu: mx, sigma: 50)
let sigma = normal(mu: 30, sigma: 30)

let modes = zip(
  .cgFloat(in: mx - 50...mx + 50),
  normal(mu: 24, sigma: 30))
  .array(of: .int(in: 1...4)
)

func noise(_ x: CGFloat) -> Gen<CGFloat> {
  return modes.map {
    $0.reduce(into: 0) { noise, ms in
      noise += normalPdf(x, mu: ms.0, sigma: ms.1)
    }
  }
}

//func path(from min: CGFloat, to max: CGFloat, by step: CGFloat) -> (CGFloat) -> Gen<CGPath> {
//
//  return { y -> Gen<CGPath> in
//    zip(mu, sigma).flatMap { mu, sigma -> Gen<CGPath> in
//      Gen<CGPath> { rng in
//        var w = y
//        return stride(from: min, to: max, by: step)
//          .map { x -> CGPoint in
//            let yy = zip(noise(x), Gen.cgFloat(in: 0...1), Gen.cgFloat(in: 0...1))
//              .map { 0.3 * w + 0.7 * (y - 600 * $0 + $0 * $1 * 200 * $2) }
//              .run(using: &rng)
//            defer { w = yy }
//            return CGPoint(x: x, y: yy)
//          }
//          .reduce(into: CGMutablePath()) { path, point in
//            point.x == xMin
//              ? path.move(to: point)
//              : path.addLine(to: point)
//        }
//      }
//    }
//  }
//}

func path(from min: CGFloat, to max: CGFloat, by step: CGFloat) -> (CGFloat) -> Gen<CGPath> {

  return { y -> Gen<CGPath> in
    let nModes = (1...Gen.int(in: 1...4).run())
      .map { _ in (Gen.double(in: (Double(mx) - 50)...(Double(mx) + 50)).map { CGFloat($0) }.run(), normal(mu: 24, sigma: 30).run()) }
    return zip(mu, sigma).flatMap { mu, sigma -> Gen<CGPath> in
      Gen<CGPath> { rng in
        var w = y
        return stride(from: min, to: max, by: step)
          .map { x -> CGPoint in
            var noise: CGFloat = 0
            nModes.forEach { mu, sigma in noise += normalPdf(x, mu: mu, sigma: sigma) }
            var yy = 0.3 * w + 0.7 * (y - 600 * noise + noise * CGFloat.random(in: 0...1) * 200 * CGFloat.random(in: 0...1)) + CGFloat.random(in: -0.5...0.5)
            defer { w = yy }
            return CGPoint(x: x, y: yy)
          }
          .reduce(into: CGMutablePath()) { path, point in
            point.x == xMin
              ? path.move(to: point)
              : path.addLine(to: point)
        }
      }
    }
  }
}

let paths = Gen<[CGPath]> { rng in
  stride(from: yMin, to: yMax, by: dy)
    .map(path(from: xMin, to: xMax, by: dx))
    .map { gen -> CGPath in gen.run(using: &rng) }
}

let image = paths.map { paths in
  UIGraphicsImageRenderer(bounds: canvas).image { ctx in
    let ctx = ctx.cgContext

    ctx.setFillColor(UIColor.black.cgColor)
    ctx.fill(canvas)

    ctx.setLineWidth(1.2)
    ctx.setStrokeColor(UIColor.white.cgColor)

    paths.forEach {
      ctx.addPath($0)
      ctx.drawPath(using: .fillStroke)
    }
  }
}
