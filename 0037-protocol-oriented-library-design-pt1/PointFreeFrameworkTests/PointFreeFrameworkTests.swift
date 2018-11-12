import XCTest
@testable import PointFreeFramework

class PointFreeFrameworkTests: SnapshotTestCase {
  func testEpisodesView() {
    let episodesVC = EpisodeListViewController(episodes: episodes)

    assertSnapshot(matching: episodesVC)
  }
}















protocol Snapshottable {
  associatedtype Snapshot: Diffable
  var snapshot: Snapshot { get }
}

protocol Diffable {
  static func diff(old: Self, new: Self) -> [XCTAttachment]
  static func from(data: Data) -> Self
  var data: Data { get }
}

extension UIImage: Diffable {
  var data: Data {
    return self.pngData()!
  }

  static func from(data: Data) -> Self {
    return self.init(data: data, scale: UIScreen.main.scale)!
  }

  static func diff(old: UIImage, new: UIImage) -> [XCTAttachment] {
    guard let difference = Diff.images(old, new) else { return [] }
    return [old, new, difference].map(XCTAttachment.init(image:))
  }
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

extension UIView: Snapshottable {
  var snapshot: UIImage {
    return self.layer.snapshot
  }
}

extension UIViewController: Snapshottable {
  var snapshot: UIImage {
    return self.view.snapshot
  }
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
      .appendingPathExtension("png")

    if !self.record, let referenceData = try? Data(contentsOf: referenceUrl) {
      let reference = S.Snapshot.from(data: referenceData)
      let attachments = S.Snapshot.diff(old: reference, new: snapshot)
      guard !attachments.isEmpty else { return }
      XCTFail("Snapshot didn't match reference", file: file, line: line)
      XCTContext.runActivity(named: "Attached failure diff") { activity in
        attachments.forEach(activity.add)
      }
    } else {
      try! snapshot.data.write(to: referenceUrl)
      XCTFail("Recorded: …\n\"\(referenceUrl.path)\"", file: file, line: line)
    }
  }
}
