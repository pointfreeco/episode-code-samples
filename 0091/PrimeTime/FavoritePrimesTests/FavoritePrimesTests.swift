import XCTest
@testable import FavoritePrimes

class FavoritePrimesTests: XCTestCase {
  func testDeleteFavoritePrimes() {
    let environment = FavoritePrimesEnvironment(fileClient: .mock, nthPrime: { _ in .sync { 17 } })
    var state = FavoritePrimesState(alertNthPrime: nil, favoritePrimes: [2, 3, 5, 7])
    let effects = favoritePrimesReducer(state: &state, action: .deleteFavoritePrimes([2]), environment: environment)

    XCTAssertNil(state.alertNthPrime)
    XCTAssertEqual(state.favoritePrimes, [2, 3, 7])
    XCTAssert(effects.isEmpty)
  }

  func testSaveButtonTapped() {
    var didSave = false
    var fileClient = FileClient.mock
    fileClient.save = { _, data in
      .fireAndForget {
        didSave = true
      }
    }

    let environment = FavoritePrimesEnvironment(fileClient: fileClient, nthPrime: { _ in .sync { 17 } })
    var state = FavoritePrimesState(alertNthPrime: nil, favoritePrimes: [2, 3, 5, 7])
    let effects = favoritePrimesReducer(state: &state, action: .saveButtonTapped, environment: environment)

    XCTAssertNil(state.alertNthPrime)
    XCTAssertEqual(state.favoritePrimes, [2, 3, 5, 7])
    XCTAssertEqual(effects.count, 1)

    _ = effects[0].sink { _ in XCTFail() }

    XCTAssert(didSave)
  }

  func testLoadFavoritePrimesFlow() {
    var fileClient = FileClient.mock
    fileClient.load = { _ in .sync { try! JSONEncoder().encode([2, 31]) } }

    let environment = FavoritePrimesEnvironment(fileClient: fileClient, nthPrime: { _ in .sync { 17 } })
    var state = FavoritePrimesState(alertNthPrime: nil, favoritePrimes: [2, 3, 5, 7])
    var effects = favoritePrimesReducer(state: &state, action: .loadButtonTapped, environment: environment)

    XCTAssertNil(state.alertNthPrime)
    XCTAssertEqual(state.favoritePrimes, [2, 3, 5, 7])
    XCTAssertEqual(effects.count, 1)

    var nextAction: FavoritePrimesAction!
    let receivedCompletion = self.expectation(description: "receivedCompletion")
    _ = effects[0].sink(
      receiveCompletion: { _ in
        receivedCompletion.fulfill()
    },
      receiveValue: { action in
        XCTAssertEqual(action, .loadedFavoritePrimes([2, 31]))
        nextAction = action
    })
    self.wait(for: [receivedCompletion], timeout: 0)

    effects = favoritePrimesReducer(state: &state, action: nextAction, environment: environment)

    XCTAssertNil(state.alertNthPrime)
    XCTAssertEqual(state.favoritePrimes, [2, 31])
    XCTAssert(effects.isEmpty)
  }

}
