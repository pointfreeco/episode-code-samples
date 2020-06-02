import Combine
import XCTest
@testable import CombineSchedulers

class CombineSchedulersTests: XCTestCase {
  var cancellables: Set<AnyCancellable> = []

  func testRegistrationSuccessful() {
    let viewModel = RegisterViewModel(
      register: { _, _ in
        Just((Data("true".utf8), URLResponse()))
          .setFailureType(to: URLError.self)
          .eraseToAnyPublisher()
    })

    var isRegistered: [Bool] = []
    viewModel.$isRegistered
      .sink { isRegistered.append($0) }
      .store(in: &self.cancellables)

//    XCTAssertEqual(viewModel.isRegistered, false)
    XCTAssertEqual(isRegistered, [false])

    viewModel.email = "blob@pointfree.co"
    XCTAssertEqual(isRegistered, [false])

    viewModel.password = "blob is awesome"
    XCTAssertEqual(isRegistered, [false])

    viewModel.registerButtonTapped()

//    XCTAssertEqual(viewModel.isRegistered, true)
    _ = XCTWaiter.wait(for: [XCTestExpectation()], timeout: 0.1)
    XCTAssertEqual(isRegistered, [false, true])
  }

  func testRegistrationFailure() {
    let viewModel = RegisterViewModel(
      register: { _, _ in
        Just((Data("false".utf8), URLResponse()))
          .setFailureType(to: URLError.self)
          .eraseToAnyPublisher()
    })

    XCTAssertEqual(viewModel.isRegistered, false)

    viewModel.email = "blob@pointfree.co"
    viewModel.password = "blob is awesome"
    viewModel.registerButtonTapped()

    _ = XCTWaiter.wait(for: [XCTestExpectation()], timeout: 0.01)
    XCTAssertEqual(viewModel.isRegistered, false)
    XCTAssertEqual(viewModel.errorAlert?.title, "Failed to register. Please try again.")
  }
}
