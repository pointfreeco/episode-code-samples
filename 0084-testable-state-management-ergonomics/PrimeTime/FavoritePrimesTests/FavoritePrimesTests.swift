import XCTest
@testable import FavoritePrimes

class FavoritePrimesTests: XCTestCase {
  func testDeleteFavoritePrimes() {
    var state = [2, 3, 5, 7]
    let effects = favoritePrimesReducer(&state, .deleteFavoritePrimes([2]), .mock)

    XCTAssertEqual(state, [2, 3, 7])
    XCTAssert(effects.isEmpty)
  }

  func testSaveButtonTapped() {
    var didSave = false
    var environment = FavoritePrimesEnvironment.mock
    environment.fileClient.save = { _, data in
      .fireAndForget {
        didSave = true
      }
    }

    var state = [2, 3, 5, 7]
    let effects = favoritePrimesReducer(&state, .saveButtonTapped, environment)

    XCTAssertEqual(state, [2, 3, 5, 7])
    XCTAssertEqual(effects.count, 1)

    effects[0].sink { _ in XCTFail() }

    XCTAssert(didSave)
  }

  func testLoadFavoritePrimesFlow() {
    var environment = FavoritePrimesEnvironment.mock
    environment.fileClient.load = { _ in .sync { try! JSONEncoder().encode([2, 31]) } }

    var state = [2, 3, 5, 7]
    var effects = favoritePrimesReducer(&state, .loadButtonTapped, environment)

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

    effects = favoritePrimesReducer(&state, nextAction, environment)

    XCTAssertEqual(state, [2, 31])
    XCTAssert(effects.isEmpty)
  }
}
