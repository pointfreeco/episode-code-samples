import XCTest
@testable import PointFreeFramework

class PointFreeFrameworkTests: SnapshotTestCase {
  func testEpisodesView() {
    let episodesVC = EpisodeListViewController(episodes: episodes)

//    assertSnapshot(matching: episodesVC)

    assertSnapshot(matching: episodesVC, as: .controller)
    assertSnapshot(matching: episodesVC, as: .recursiveDescription)
  }

  func testGreeting() {
    let greeting = """
Welcome to Point-Free!
-----------------------------------------
A Swift video series exploring functional
programming and more.
"""

//    assertSnapshot(matching: greeting)

    assertSnapshot(matching: greeting, as: .lines)
  }
}

extension Snapshotting where A == UIImage, Snapshot == UIImage {
  static let image = Snapshotting(
    diffing: .image,
    pathExtension: "png",
    snapshot: { $0 }
  )
}

extension Snapshotting where A == CALayer, Snapshot == UIImage {
  static let layer: Snapshotting = Snapshotting<UIImage, UIImage>.image.pullback { layer in
    UIGraphicsImageRenderer(size: layer.bounds.size)
      .image { ctx in layer.render(in: ctx.cgContext) }
  }
//  static let layer = Snapshotting.init(
//    diffing: .image,
//    pathExtension: "png",
//    snapshot: { layer in
//      UIGraphicsImageRenderer(size: layer.bounds.size)
//        .image { ctx in layer.render(in: ctx.cgContext) }
//  })
}

import Overture

extension Snapshotting where A == UIView, Snapshot == UIImage {
  static let view: Snapshotting = Snapshotting<CALayer, UIImage>.layer
    .pullback(get(\.layer))
//  static let view = Snapshotting.init(
//    diffing: .image,
//    pathExtension: "png",
//    snapshot: { view in Snapshotting<CALayer, UIImage>.layer.snapshot(view.layer) })
}

extension Snapshotting where A == UIViewController, Snapshot == UIImage {
  static let controller: Snapshotting = Snapshotting<UIView, UIImage>.view.pullback(get(\.view))
//  static let controller = Snapshotting.init(
//    diffing: .image,
//    pathExtension: "png",
//    snapshot: { vc in Snapshotting<UIView, UIImage>.view.snapshot(vc.view) })
}








protocol Diffable {
  static func diff(old: Self, new: Self) -> (String, [XCTAttachment])?
  static func from(data: Data) -> Self
  var data: Data { get }
}

struct Diffing<A> {
  let diff: (A, A) -> (String, [XCTAttachment])?
  let from: (Data) -> A
  let data: (A) -> Data
}

extension String: Diffable {
  static func diff(old: String, new: String) -> (String, [XCTAttachment])? {
    guard let string = Diff.lines(old, new) else { return nil }
    return ("Difference:\n\n\(string)", [XCTAttachment(string: string)])
  }

  static func from(data: Data) -> String {
    return String(decoding: data, as: UTF8.self)
  }

  var data: Data {
    return Data(self.utf8)
  }
}

extension Diffing where A == String {
  static let lines = Diffing(
    diff: { old, new in
      guard let string = Diff.lines(old, new) else { return nil }
      return ("Difference:\n\n\(string)", [XCTAttachment(string: string)])
  },
    from: { data in
      return String(decoding: data, as: UTF8.self)
  },
    data: { string in
      return Data(string.utf8)
  }
  )
}

extension Diffing where A == UIImage {
  static let image = Diffing(
    diff: { old, new in
      guard let difference = Diff.images(old, new) else { return nil }
      return (
        "Expected old@\(old.size) to match new@\(new.size)",
        [old, new, difference].map(XCTAttachment.init)
      )
  },
    from: { data in UIImage(data: data, scale: UIScreen.main.scale)! },
    data: { image in image.pngData()! }
  )
}


protocol Snapshottable {
  associatedtype Snapshot: Diffable
  static var pathExtension: String { get }
  var snapshot: Snapshot { get }
}

struct Snapshotting<A, Snapshot> {
  let diffing: Diffing<Snapshot>
  let pathExtension: String
  let snapshot: (A) -> Snapshot

  func pullback<A0>(_ f: @escaping (A0) -> A) -> Snapshotting<A0, Snapshot> {
    return Snapshotting<A0, Snapshot>.init(
      diffing: self.diffing,
      pathExtension: self.pathExtension,
      snapshot: { a0 in self.snapshot(f(a0)) }
    )
  }
}

extension String: Snapshottable {
  typealias Snapshot = String
  static let pathExtension = "txt"

  var snapshot: String {
    return self
  }
}


extension Snapshotting where A == String, Snapshot == String {
  static let lines = Snapshotting(
    diffing: .lines,
    pathExtension: "txt",
    snapshot: { $0 }
  )
}












extension UIImage: Diffable {
  var data: Data {
    return self.pngData()!
  }

  static func from(data: Data) -> Self {
    return self.init(data: data, scale: UIScreen.main.scale)!
  }

  static func diff(old: UIImage, new: UIImage) -> (String, [XCTAttachment])? {
    guard let image = Diff.images(old, new) else { return nil }
    return ("Expected new@\(new.size) to match old@\(old.size)", [old, new, image].map(XCTAttachment.init))
  }
}

extension Snapshottable where Snapshot == UIImage {
  static var pathExtension: String {
    return "png"
  }
}

extension UIView: Snapshottable {
//  var snapshot: UIImage {
//    return self.layer.snapshot
//  }

  static let pathExtension = "txt"

  var snapshot: String {
    self.setNeedsLayout()
    self.layoutIfNeeded()

    return (self.perform(Selector(("recursiveDescription")))?
      .takeUnretainedValue() as! String)
    .replacingOccurrences(of: ":?\\s*0x[\\da-f]+(\\s*)", with: "$1", options: .regularExpression)
  }
}

extension Snapshotting where A == UIView, Snapshot == String {
  static let recursiveDescription: Snapshotting = Snapshotting<String, String>.lines.pullback { view in
    view.setNeedsLayout()
    view.layoutIfNeeded()

    return (view.perform(Selector(("recursiveDescription")))?
      .takeUnretainedValue() as! String)
      .replacingOccurrences(of: ":?\\s*0x[\\da-f]+(\\s*)", with: "$1", options: .regularExpression)
  }
//  static let recursiveDescription: Snapshotting = Snapshotting(
//    diffing: .lines,
//    pathExtension: "txt",
//    snapshot: { view in
//      view.setNeedsLayout()
//      view.layoutIfNeeded()
//
//      return (view.perform(Selector(("recursiveDescription")))?
//        .takeUnretainedValue() as! String)
//        .replacingOccurrences(of: ":?\\s*0x[\\da-f]+(\\s*)", with: "$1", options: .regularExpression)
//  }
//  )
}

extension Snapshotting where A == UIViewController, Snapshot == String {
  static let recursiveDescription: Snapshotting = Snapshotting<UIView, String>.recursiveDescription.pullback(get(\.view))
}

extension UIImage: Snapshottable {
  var snapshot: UIImage {
    return self
  }
}

extension CALayer: Snapshottable {
  var snapshot: UIImage {
    return UIGraphicsImageRenderer(size: self.bounds.size)
      .image { ctx in self.render(in: ctx.cgContext) }
  }
}

extension UIViewController: Snapshottable {
  static let pathExtension = "txt"
  var snapshot: String {
    return self.view.snapshot
  }
}

class SnapshotTestCase: XCTestCase {
  var record = false


  func assertSnapshot<A, Snapshot>(
    matching value: A,
    as witness: Snapshotting<A, Snapshot>,
    file: StaticString = #file,
    function: String = #function,
    line: UInt = #line) {

    let snapshot = witness.snapshot(value)
    let referenceUrl = snapshotUrl(file: file, function: function)
      .appendingPathExtension(witness.pathExtension)

    if !self.record, let referenceData = try? Data(contentsOf: referenceUrl) {
      let reference = witness.diffing.from(referenceData)
      guard let (failure, attachments) = witness.diffing.diff(reference, snapshot) else { return }
      XCTFail(failure, file: file, line: line)
      XCTContext.runActivity(named: "Attached failure diff") { activity in
        attachments
          .forEach { image in activity.add(image) }
      }
    } else {
      try! witness.diffing.data(snapshot).write(to: referenceUrl)
      XCTFail("Recorded: …\n\"\(referenceUrl.path)\"", file: file, line: line)
    }
  }

  func assertSnapshot<S: Snapshottable>(
    matching value: S,
    file: StaticString = #file,
    function: String = #function,
    line: UInt = #line) {

    let snapshot = value.snapshot
    let referenceUrl = snapshotUrl(file: file, function: function)
      .appendingPathExtension(S.pathExtension)

    if !self.record, let referenceData = try? Data(contentsOf: referenceUrl) {
      let reference = S.Snapshot.from(data: referenceData)
      guard let (failure, attachments) = S.Snapshot.diff(old: reference, new: snapshot) else { return }
      XCTFail(failure, file: file, line: line)
      XCTContext.runActivity(named: "Attached failure diff") { activity in
        attachments
          .forEach { image in activity.add(image) }
      }
    } else {
      try! snapshot.data.write(to: referenceUrl)
      XCTFail("Recorded: …\n\"\(referenceUrl.path)\"", file: file, line: line)
    }
  }
}
