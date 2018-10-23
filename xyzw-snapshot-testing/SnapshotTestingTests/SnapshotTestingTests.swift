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
}

class SnapshotTestCase: XCTestCase {

  var record = false

  func assertSnapshot(
    matching view: UIView,
    file: StaticString = #file,
    function: String = #function,
    line: UInt = #line) {

    let snapshot = UIGraphicsImageRenderer(size: view.bounds.size)
      .image { ctx in view.layer.render(in: ctx.cgContext) }
    let referenceUrl = snapshotUrl(file: file, function: function)
      .appendingPathExtension("png")

    if !self.record, let referenceData = try? Data(contentsOf: referenceUrl) {
      let reference = UIImage(data: referenceData)!
      guard let difference = Diff.images(reference, snapshot) else { return }
      XCTFail("Snapshot doesn't match reference", file: file, line: line)
      XCTContext.runActivity(named: "Attached failure diff") { activity in
        [reference, snapshot, difference]
          .forEach { image in activity.add(XCTAttachment(image: image)) }
      }
    }

    try! snapshot.pngData()!.write(to: referenceUrl)
    XCTFail("Recorded: …\n\"\(referenceUrl.path)\"", file: file, line: line)
  }

}
