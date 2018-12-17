import Overture
import XCTest

struct Diffing<A> {
  let diff: (A, A) -> (String, [XCTAttachment])?
  let from: (Data) -> A
  let data: (A) -> Data
}

struct Parallel<A> {
  let run: (@escaping (A) -> Void) -> Void
}

struct Snapshotting<A, Snapshot> {
  let diffing: Diffing<Snapshot>
  let pathExtension: String
  let snapshot: (A) -> Parallel<Snapshot>

  func pullback<A0>(_ f: @escaping (A0) -> A) -> Snapshotting<A0, Snapshot> {
    return Snapshotting<A0, Snapshot>.init(
      diffing: self.diffing,
      pathExtension: self.pathExtension,
      snapshot: { a0 in self.snapshot(f(a0)) }
    )
  }

  func asyncPullback<A0>(_ f: @escaping (A0) -> Parallel<A>) -> Snapshotting<A0, Snapshot> {
    return Snapshotting<A0, Snapshot>(
      diffing: self.diffing,
      pathExtension: self.pathExtension,
      snapshot: { (a0) -> Parallel<Snapshot> in
        return Parallel<Snapshot> { callback in
//          callback // (Snapshot) -> Void
//          a0 // A0
//          f // (A0) -> Parallel<A>
//          self.snapshot // (A) -> Parallel<Snapshot>
          let parallelA = f(a0)
          parallelA.run { a in
            let parallelSnapshot = self.snapshot(a)
            parallelSnapshot.run { snapshot in
              callback(snapshot)
            }
          }
        }
    }
    )
  }
}

extension Snapshotting {
  init(diffing: Diffing<Snapshot>, pathExtension: String, snapshot: @escaping (A) -> Snapshot) {
    self.diffing = diffing
    self.pathExtension = pathExtension
    self.snapshot = { a in Parallel { callback in callback(snapshot(a)) } }
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

extension Snapshotting where A == UIImage, Snapshot == UIImage {
  static let image = Snapshotting(
    diffing: .image,
    pathExtension: "png",
    snapshot: { $0 }
  )
}

extension Snapshotting where A == CALayer, Snapshot == UIImage {
  static let image: Snapshotting = Snapshotting<UIImage, UIImage>.image.pullback { layer in
    UIGraphicsImageRenderer(size: layer.bounds.size)
      .image { ctx in layer.render(in: ctx.cgContext) }
  }
}

extension Snapshotting where A == UIView, Snapshot == UIImage {
  static let image: Snapshotting = Snapshotting<CALayer, UIImage>.image.pullback(get(\.layer))
}

extension Snapshotting where A == UIViewController, Snapshot == UIImage {
  static let image: Snapshotting = Snapshotting<UIView, UIImage>.image.pullback(get(\.view))
}

extension Snapshotting where A == String, Snapshot == String {
  static let lines = Snapshotting(
    diffing: .lines,
    pathExtension: "txt",
    snapshot: { $0 }
  )
}

extension Snapshotting where A == UIView, Snapshot == String {
  static let recursiveDescription: Snapshotting = Snapshotting<String, String>.lines.pullback { view in
    view.setNeedsLayout()
    view.layoutIfNeeded()

    return (view.perform(Selector(("recursiveDescription")))?
      .takeUnretainedValue() as! String)
      .replacingOccurrences(of: ":?\\s*0x[\\da-f]+(\\s*)", with: "$1", options: .regularExpression)
  }
}

extension Snapshotting where A == UIViewController, Snapshot == String {
  static let recursiveDescription: Snapshotting = Snapshotting<UIView, String>.recursiveDescription.pullback(get(\.view))
}

class SnapshotTestCase: XCTestCase {
  var record = false

  func assertSnapshot<A, Snapshot>(
    matching value: A,
    as witness: Snapshotting<A, Snapshot>,
    file: StaticString = #file,
    function: String = #function,
    line: UInt = #line) {

    let parallel = witness.snapshot(value)
    var snapshot: Snapshot!
    let loaded = expectation(description: "Loaded")
    parallel.run {
      snapshot = $0
      loaded.fulfill()
    }
    wait(for: [loaded], timeout: 5)

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
}
