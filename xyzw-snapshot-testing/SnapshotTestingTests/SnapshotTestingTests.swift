import XCTest
import UIKit

class ViewTests: SnapshotTestCase {
  func testView() {
    let titleLabel = UILabel()
    titleLabel.backgroundColor = .white
    titleLabel.font = .systemFont(ofSize: 22, weight: .bold)
    titleLabel.text = "Welcome to Point-Free!"
    titleLabel.sizeToFit()

//    record = true
    assertSnapshot(matching: titleLabel)
  }

  func testString() {
    assertSnapshot(matching: "Welcome to Point-Free.")
  }
}

protocol Diffable {
  static var pathExtension: String { get }
  static func diff(_ old: Self, _ new: Self) -> [XCTAttachment]
  static func from(data: Data) -> Self
  var to: Data { get }
}

extension String: Diffable {
  static let pathExtension = "txt"

  static func diff(_ old: String, _ new: String) -> [XCTAttachment] {
    guard let difference = Diff.strings(old, new) else { return [] }
    return [XCTAttachment(string: difference)]
  }

  static func from(data: Data) -> String {
    return String(decoding: data, as: UTF8.self)
  }

  var to: Data {
    return Data(self.utf8)
  }
}

extension UIImage: Diffable {
  static let pathExtension = "png"

  static func diff(_ old: UIImage, _ new: UIImage) -> [XCTAttachment] {
    guard let difference = Diff.images(old, new) else { return [] }
    return [old, new, difference].map(XCTAttachment.init)
  }

  static func from(data: Data) -> Self {
    return self.init(data: data)!
  }

  var to: Data {
    return self.pngData()!
  }
}

protocol Snapshottable {
  associatedtype Snapshot: Diffable
  var snapshot: Snapshot { get }
}

extension String: Snapshottable {
  var snapshot: String {
    return self
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
      .appendingPathExtension(S.Snapshot.pathExtension)

    if !self.record, let referenceData = try? Data(contentsOf: referenceUrl) {
      let reference = S.Snapshot.from(data: referenceData)
      let attachments = S.Snapshot.diff(reference, snapshot)
      guard !attachments.isEmpty else { return }
      XCTFail("Snapshot didn't match reference", file: file, line: line)
      XCTContext.runActivity(named: "Attached failure diff") { activity in
        attachments.forEach { activity.add($0) }
      }
    } else {
      try! snapshot.to.write(to: referenceUrl)
      XCTFail("Recorded: …\n\"\(referenceUrl.path)\"", file: file, line: line)
    }
  }
}
