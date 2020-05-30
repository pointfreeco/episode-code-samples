import Combine
import XCTest
@testable import CombineSchedulers

class CombineSchedulersTests: XCTestCase {
  var cancellables: Set<AnyCancellable> = []

  func testHappyPath() {
    let viewModel = RegisterViewModel(
      login: { _, _ in Just(true).eraseToAnyPublisher() }
    )

    var expectedOutput: [Bool] = []
    viewModel.$isLoginSuccessful
      .sink { expectedOutput.append($0) }
      .store(in: &self.cancellables)

    XCTAssertEqual(expectedOutput, [false, ])
    viewModel.email = "blob@pointfree.co"
    viewModel.password = "blob is awesome"
    viewModel.loginButtonTapped()
    _ = XCTWaiter.wait(for: [XCTestExpectation()], timeout: 0.01)
    XCTAssertEqual(viewModel.isLoginSuccessful, true)
    XCTAssertEqual(expectedOutput, [false, true])
  }

}
