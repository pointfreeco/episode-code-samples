import XCTest
@testable import FavoritePrimes

class FavoritePrimesTests: XCTestCase {
  func testDeleteFavoritePrimes() {
    var state = [2, 3, 5, 7]
    let effects = favoritePrimesReducer(state: &state, action: .deleteFavoritePrimes([2]))

    XCTAssertEqual(state, [2, 3, 7])
    XCTAssert(effects.isEmpty)
  }

  func testSaveButtonTapped() {
    var state = [2, 3, 5, 7]
    let effects = favoritePrimesReducer(state: &state, action: .saveButtonTapped)

    XCTAssertEqual(state, [2, 3, 5, 7])
    XCTAssertEqual(effects.count, 1)
  }

  func testLoadFavoritePrimesFlow() {
    var state = [2, 3, 5, 7]
    var effects = favoritePrimesReducer(state: &state, action: .loadButtonTapped)

    XCTAssertEqual(state, [2, 3, 5, 7])
    XCTAssertEqual(effects.count, 1)

    effects = favoritePrimesReducer(state: &state, action: .loadedFavoritePrimes([2, 31]))

    XCTAssertEqual(state, [2, 31])
    XCTAssert(effects.isEmpty)
  }

}
