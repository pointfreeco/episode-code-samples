import XCTest
@testable import FavoritePrimes
import ComposableArchitectureTestSupport

class FavoritePrimesTests: XCTestCase {
  override func setUp() {
    super.setUp()
    Current = .mock
  }

  func testDeleteFavoritePrimes() {
    assert(
      initialValue: [2, 3, 5, 7],
      reducer: favoritePrimesReducer,
      steps:
      Step(.send, .deleteFavoritePrimes([2])) { $0 = [2, 3, 7] }
    )
  }

  func testSaveButtonTapped() {
    var didSave = false
    Current.fileClient.save = { _, data in
      .fireAndForget {
        didSave = true
      }
    }

    var state = [2, 3, 5, 7]
    let effects = favoritePrimesReducer(state: &state, action: .saveButtonTapped)

    XCTAssertEqual(state, [2, 3, 5, 7])
    XCTAssertEqual(effects.count, 1)

    effects[0].sink { _ in XCTFail() }

    XCTAssert(didSave)
  }

  func testLoadFavoritePrimesFlow() {
    Current.fileClient.load = { _ in .sync { try! JSONEncoder().encode([2, 31]) } }

    assert(
      initialValue: [2, 3, 5, 7],
      reducer: favoritePrimesReducer,
      steps:
      Step(.send, .loadButtonTapped) { _ in },
      Step(.receive, FavoritePrimesAction.loadedFavoritePrimes([2, 31])) {
        $0 = [2, 31]
      }
    )
  }
}
