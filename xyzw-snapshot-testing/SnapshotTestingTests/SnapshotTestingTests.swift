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

    let snapshot = view.image

    let referenceUrl = snapshotUrl(file: file, function: function)
      .appendingPathExtension("png")

    guard
      !self.record,
      let referenceData = try? Data(contentsOf: referenceUrl),
      let reference = UIImage(data: referenceData)
      else {
        try? snapshot.pngData()?.write(to: referenceUrl)
        XCTFail("Recorded: …\n\"\(referenceUrl.path)\"", file: file, line: line)
        return
    }

    guard !compare(reference, snapshot) else { return }

    let difference = diff(reference, snapshot)
    XCTFail("Snapshot mismatch", file: file, line: line)
    XCTContext.runActivity(named: "Attached failure diff") { activity  in
      activity.add(XCTAttachment(image: reference))
      activity.add(XCTAttachment(image: snapshot))
      activity.add(XCTAttachment(image: difference))
    }
  }
}
