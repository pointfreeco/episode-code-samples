@testable import Joy
import SnapshotTesting
import XCTest

extension Environment {
  static let mock = Environment(
    calendar: Calendar(identifier: .gregorian),
    date: { Date.init(timeIntervalSince1970: 1234567890) },
    rng: AnyRandomNumberGenerator(rng: LCRNG(seed: 1))
  )
}

class JoyTests: XCTestCase {
  override func setUp() {
    super.setUp()
    Current = .mock
  }

  func testJoy() {
    let vc = ViewController()
    //    record=true
    assertSnapshot(matching: vc, as: .image(on: .iPhoneX))
  }

  func testJoy_PointFreeAnniversary() {
    Current.date = { Date.init(timeIntervalSince1970: 1517202000 + 60*60*24*365) }
    let vc = ViewController()
    //    record=true
    assertSnapshot(matching: vc, as: .image(on: .iPhoneX))
  }
}
