import Clocks
import Dependencies
import XCTest

@testable import Standups

class RecordMeetingTests: XCTestCase {
  func testTimer() async {
    await DependencyValues.withTestValues {
      $0.continuousClock = ImmediateClock()
    } assert: { @MainActor in
      var standup = Standup.mock
      standup.duration = .seconds(6)
      let recordModel = RecordMeetingModel(
  //      clock: ImmediateClock(),
        standup: standup
      )
      let expectation = self.expectation(description: "onMeetingFinished")
      recordModel.onMeetingFinished = { _ in expectation.fulfill() }

      await recordModel.task()
      self.wait(for: [expectation], timeout: 0)
      XCTAssertEqual(recordModel.secondsElapsed, 6)
      XCTAssertEqual(recordModel.dismiss, true)
    }
  }
}
