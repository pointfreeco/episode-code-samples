import XCTest
@testable import FavoritePrimes

class FavoritePrimesTests: XCTestCase {
//  var environment:

  override func setUp() {
    super.setUp()
//    Current = .mock

//    self.environment = (
//    )
  }

  func testDeleteFavoritePrimes() {
    var state = [2, 3, 5, 7]
    let effects = favoritePrimesReducer(state: &state, action: .deleteFavoritePrimes([2]), environment: .mock)

    XCTAssertEqual(state, [2, 3, 7])
    XCTAssert(effects.isEmpty)
  }

  func testSaveButtonTapped() {
    var didSave = false
    var environment = FileClient.mock
    environment.save = { _, data in
      .fireAndForget {
        didSave = true
      }
    }

    var state = [2, 3, 5, 7]
    let effects = favoritePrimesReducer(state: &state, action: .saveButtonTapped, environment: environment)

    XCTAssertEqual(state, [2, 3, 5, 7])
    XCTAssertEqual(effects.count, 1)

    effects[0].sink { _ in XCTFail() }

    XCTAssert(didSave)
  }

  func testLoadFavoritePrimesFlow() {
    var environment = FileClient.mock
    environment.load = { _ in .sync { try! JSONEncoder().encode([2, 31]) } }

    var state = [2, 3, 5, 7]
    var effects = favoritePrimesReducer(state: &state, action: .loadButtonTapped, environment: environment)

    XCTAssertEqual(state, [2, 3, 5, 7])
    XCTAssertEqual(effects.count, 1)

    var nextAction: FavoritePrimesAction!
    let receivedCompletion = self.expectation(description: "receivedCompletion")
    effects[0].sink(
      receiveCompletion: { _ in
        receivedCompletion.fulfill()
    },
      receiveValue: { action in
        XCTAssertEqual(action, .loadedFavoritePrimes([2, 31]))
        nextAction = action
    })
    self.wait(for: [receivedCompletion], timeout: 0)

    effects = favoritePrimesReducer(state: &state, action: nextAction, environment: environment)

    XCTAssertEqual(state, [2, 31])
    XCTAssert(effects.isEmpty)
  }

}
