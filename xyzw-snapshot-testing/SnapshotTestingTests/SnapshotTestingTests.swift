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
    line: UInt = #line
    ) {

    let snapshot = UIGraphicsImageRenderer(size: view.bounds.size)
      .image { ctx in view.layer.render(in: ctx.cgContext) }

    let referenceUrl = snapshotUrl(file: file, function: function)
      .appendingPathExtension("png")
    guard
      !self.record,
      let referenceData = try? Data(contentsOf: referenceUrl)
      else {
        try! snapshot.pngData()!.write(to: referenceUrl)
        XCTFail("Recorded: …\n\"\(referenceUrl.path)\"", file: file, line: line)
        return
    }

    let reference = UIImage(data: referenceData)!
    if let difference = Diff.images(reference, snapshot) {
      XCTFail("Snapshot mismatch", file: file, line: line)
      XCTContext.runActivity(named: "Attached failure diff") { activity in
        [reference, snapshot, difference]
          .forEach { image in activity.add(XCTAttachment(image: image)) }
      }
    }
  }
}
