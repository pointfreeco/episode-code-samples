import Overture
import XCTest
import UIKit

class ViewTests: SnapshotTestCase {
  func testView() {
//    record = true
    let episodesVC = EpisodeListViewController()
    assertSnapshot(of: .viewController, matching: episodesVC)
    assertSnapshot(of: .recursiveDescription, matching: episodesVC)
  }

  func testString() {
    assertSnapshot(matching: "Welcome to Point-Free!")
  }
}

protocol Diffable {
  static var pathExtension: String { get }
  static func diff(_ old: Self, _ new: Self) -> (String, [XCTAttachment])?
  static func from(data: Data) -> Self
  var to: Data { get }
}

struct Diffing<A> {
  let pathExtension: String
  let diff: (A, A) -> (String, [XCTAttachment])?
  let from: (Data) -> A
  let to: (A) -> Data
}

extension String: Diffable {
  static let pathExtension = "txt"

  static func diff(_ old: String, _ new: String) -> (String, [XCTAttachment])? {
    guard let difference = Diff.lines(old, new) else { return nil }
    return (
      "Diff:\n\(difference)",
      [XCTAttachment(string: difference)]
    )
  }

  static func from(data: Data) -> String {
    return String(decoding: data, as: UTF8.self)
  }

  var to: Data {
    return Data(self.utf8)
  }
}

extension Diffing where A == String {
  static let lines = Diffing(
    pathExtension: "txt",
    diff: { old, new in
      guard let difference = Diff.lines(old, new) else { return nil }
      return (
        "Diff:\n\(difference)",
        [XCTAttachment(string: difference)]
      )
  },
    from: { data in String(decoding: data, as: UTF8.self) },
    to: { string in Data(string.utf8) }
  )
}

extension UIImage: Diffable {
  static let pathExtension = "png"

  static func diff(_ old: UIImage, _ new: UIImage) -> (String, [XCTAttachment])? {
    guard let difference = Diff.images(old, new) else { return nil }
    return (
      "Expected old@\(old.size) to match new@\(new.size)",
      [old, new, difference].map(XCTAttachment.init)
    )
  }

  static func from(data: Data) -> Self {
    return self.init(data: data, scale: UIScreen.main.scale)!
  }

  var to: Data {
    return self.pngData()!
  }
}

extension Diffing where A == UIImage {
  static let image = Diffing(
    pathExtension: "png",
    diff: { old, new in
      guard let difference = Diff.images(old, new) else { return nil }
      return (
        "Expected old@\(old.size) to match new@\(new.size)",
        [old, new, difference].map(XCTAttachment.init)
      )
  },
    from: { data in UIImage(data: data)! },
    to: { image in image.pngData()! }
  )
}

protocol Snapshottable {
  associatedtype Snapshot: Diffable
  static var pathExtension: String { get }
  var snapshot: Snapshot { get }
}

extension Snapshottable {
  static var pathExtension: String {
    return Snapshot.pathExtension
  }
}

struct Snapshotting<A, B> {
  let diffing: Diffing<B>
  let to: (A) -> B
}

extension String: Snapshottable {
  var snapshot: String {
    return self
  }
}

extension Snapshotting where A == String, B == String {
  static let lines = Snapshotting(
    diffing: .lines,
    to: { $0 }
  )
}

extension UIImage: Snapshottable {
  var snapshot: UIImage {
    return self
  }
}

extension Snapshotting where A == UIImage, B == UIImage {
  static let image = Snapshotting(
    diffing: .image,
    to: { $0 }
  )
}

extension Snapshotting {
  func pullback<C>(_ f: @escaping (C) -> A) -> Snapshotting<C, B> {
    return Snapshotting<C, B>(
      diffing: self.diffing,
      to: { self.to(f($0)) }
    )
  }
}

extension CALayer: Snapshottable {
  var snapshot: UIImage {
    return UIGraphicsImageRenderer(size: self.bounds.size)
      .image { ctx in self.render(in: ctx.cgContext) }
  }
}

extension Snapshotting where A == CALayer, B == UIImage {
  static let layer = Snapshotting<UIImage, UIImage>.image.pullback { (layer: CALayer) in
    return UIGraphicsImageRenderer(size: layer.bounds.size)
      .image { ctx in layer.render(in: ctx.cgContext) }
  }
}

//extension UIView: Snapshottable {
//  var snapshot: UIImage {
//    return self.layer.snapshot
//  }
//}

extension UIView: Snapshottable {
  var snapshot: String {
    return (self.perform(Selector(("recursiveDescription"))).takeUnretainedValue() as! String)
      .replacingOccurrences(of: ":?\\s*0x[\\da-f]+(\\s*)", with: "$1", options: .regularExpression)
  }
}

extension Snapshotting where A == UIView, B == UIImage {
  static let view = Snapshotting<CALayer, UIImage>.layer.pullback(get(\UIView.layer))
}

extension Snapshotting where A == UIView, B == String {
  static let recursiveDescription = Snapshotting<String, String>.lines.pullback { (view: UIView) in
    view.setNeedsLayout()
    view.layoutIfNeeded()
    return (view.perform(Selector(("recursiveDescription"))).takeUnretainedValue() as! String)
      .replacingOccurrences(of: ":?\\s*0x[\\da-f]+(\\s*)", with: "$1", options: .regularExpression)
  }
}

extension UIViewController: Snapshottable {
//  var snapshot: UIImage {
  var snapshot: String {
    return self.view.snapshot
  }
}

extension Snapshotting where A == UIViewController, B == UIImage {
  static let viewController = Snapshotting<UIView, UIImage>.view.pullback(get(\UIViewController.view))
}

extension Snapshotting where A == UIViewController, B == String {
  static let recursiveDescription = Snapshotting<UIView, String>.recursiveDescription.pullback(get(\UIViewController.view))
}

class SnapshotTestCase: XCTestCase {
  var record = false

  func assertSnapshot<S: Snapshottable>(
    matching value: S,
    file: StaticString = #file,
    function: String = #function,
    line: UInt = #line) {

    let snapshot = value.snapshot
    let referenceUrl = snapshotUrl(file: file, function: function)
      .appendingPathExtension(S.Snapshot.pathExtension)

    if !self.record, let referenceData = try? Data(contentsOf: referenceUrl) {
      let reference = S.Snapshot.from(data: referenceData)
      guard let (message, attachments) = S.Snapshot.diff(reference, snapshot) else { return }
      XCTFail(message, file: file, line: line)
      XCTContext.runActivity(named: "Attached failure diff") { activity in
        attachments.forEach { activity.add($0) }
      }
    } else {
      try! snapshot.to.write(to: referenceUrl)
      XCTFail("Recorded: …\n\"\(referenceUrl.path)\"", file: file, line: line)
    }
  }

  func assertSnapshot<A, B>(
    of snapshotting: Snapshotting<A, B>,
    matching value: A,
    file: StaticString = #file,
    function: String = #function,
    line: UInt = #line) {

    let snapshot = snapshotting.to(value)
    let referenceUrl = snapshotUrl(file: file, function: function)
      .appendingPathExtension(snapshotting.diffing.pathExtension)

    if !self.record, let referenceData = try? Data(contentsOf: referenceUrl) {
      let reference = snapshotting.diffing.from(referenceData)
      guard let (message, attachments) = snapshotting.diffing.diff(reference, snapshot) else { return }
      XCTFail(message, file: file, line: line)
      XCTContext.runActivity(named: "Attached failure diff") { activity in
        attachments.forEach { activity.add($0) }
      }
    } else {
      try! snapshotting.diffing.to(snapshot).write(to: referenceUrl)
      XCTFail("Recorded: …\n\"\(referenceUrl.path)\"", file: file, line: line)
    }
  }
}
