import CustomDump
import XCTest
@testable import ObservationExplorations

struct User: Equatable {
  let id = UUID()
  var name = ""
  var bio = ""
  var age: Int?
  var friends: [User] = []
}

final class ObservationExplorationsTests: XCTestCase {
  func testBasics() {
    var before = User()
//    var after = before
//    after.name = "Blob"
//    XCTAssertNoDifference(before, after)

    func doSomething(_ user: inout User) {
      // Complex feature logic
      user.name = "Blob"
    }

    XCTAssertDifference(before) {
      doSomething(&before)
    } changes: {
      $0.name = "Blob"
    }

//    store.send(.incrementButtonTapped) {
//      $0.count = 1
//    }
  }

  func testReference() {
    let before = CounterModel()
//    let after = before
//    after.count = 1
//    XCTAssertNoDifference(before, after)

    before.incrementButtonTapped()
    XCTAssertEqual(before.count, 1)
  }
}
