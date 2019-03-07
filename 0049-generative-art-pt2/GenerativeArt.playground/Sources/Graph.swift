import UIKit

public func graph(_ f: (CGFloat) -> CGFloat) -> UIImage {
  let bounds = CGRect(x: 0, y: 0, width: 300, height: 300)
  return UIGraphicsImageRenderer(bounds: bounds).image { ctx in
    let ctx = ctx.cgContext

    ctx.setFillColor(UIColor.black.cgColor)
    ctx.setStrokeColor(UIColor.white.cgColor)
    ctx.fill(bounds)

    ctx.move(to: CGPoint.init(x: 0, y: 150))
    ctx.addLine(to: CGPoint.init(x: 300, y: 150))
    ctx.strokePath()

    ctx.move(to: CGPoint.init(x: 150, y: 0))
    ctx.addLine(to: CGPoint.init(x: 150, y: 300))
    ctx.strokePath()

    ctx.setStrokeColor(UIColor.red.cgColor)
    ctx.move(to: CGPoint.init(x: 0, y: (1 - f(-1)) * 150))
    stride(from: 0, to: 2, by: 0.001).forEach { x in
      ctx.addLine(to: CGPoint.init(x: x * 150, y: (1 - f(x - 1)) * 150))
    }
    ctx.strokePath()
  }
}
