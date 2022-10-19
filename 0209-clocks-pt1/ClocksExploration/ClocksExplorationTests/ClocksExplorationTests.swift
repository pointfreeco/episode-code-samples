import XCTest
@testable import ClocksExploration

@MainActor
final class ClocksExplorationTests: XCTestCase {
  func testWelcome() async {
    let model = FeatureModel(clock: ImmediateClock())

    XCTAssertEqual(model.message, "")
    await model.task()
    XCTAssertEqual(model.message, "Welcome!")
  }

  func testCount() async {
    let model = FeatureModel(
      clock: ContinuousClock(),
      count: 10_000
    )

    model.incrementButtonTapped()
    XCTAssertEqual(model.count, 10_001)
    model.decrementButtonTapped()
    XCTAssertEqual(model.count, 10_000)
    await model.nthPrimeButtonTapped()
    XCTAssertEqual(model.message, "10000th prime is 104729")

    // TODO: assertion on how the analytics event was tracked
  }
}
