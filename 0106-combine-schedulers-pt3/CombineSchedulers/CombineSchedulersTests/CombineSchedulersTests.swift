import Combine
import XCTest
@testable import CombineSchedulers

class CombineSchedulersTests: XCTestCase {
  var cancellables: Set<AnyCancellable> = []
  let scheduler = DispatchQueue.testScheduler

  func testRegistrationSuccessful() {
    let viewModel = RegisterViewModel(
      register: { _, _ in
        Just((Data("true".utf8), URLResponse()))
          .setFailureType(to: URLError.self)
          .eraseToAnyPublisher()
    },
      validatePassword: { _ in Empty(completeImmediately: true).eraseToAnyPublisher() },
      scheduler: scheduler.eraseToAnyScheduler()
    )

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
//    _ = XCTWaiter.wait(for: [XCTestExpectation()], timeout: 0.1)
    scheduler.advance()
    XCTAssertEqual(isRegistered, [false, true])
  }

  func testRegistrationFailure() {
    let viewModel = RegisterViewModel(
      register: { _, _ in
        Just((Data("false".utf8), URLResponse()))
          .setFailureType(to: URLError.self)
          .eraseToAnyPublisher()
    },
      validatePassword: { _ in Empty(completeImmediately: true).eraseToAnyPublisher() },
      scheduler: scheduler.eraseToAnyScheduler()
    )

    XCTAssertEqual(viewModel.isRegistered, false)

    viewModel.email = "blob@pointfree.co"
    viewModel.password = "blob is awesome"
    viewModel.registerButtonTapped()

//    _ = XCTWaiter.wait(for: [XCTestExpectation()], timeout: 0.01)
    scheduler.advance()
    XCTAssertEqual(viewModel.isRegistered, false)
    XCTAssertEqual(viewModel.errorAlert?.title, "Failed to register. Please try again.")
  }
  
  func testValidatePassword() {
    let viewModel = RegisterViewModel(
      register: { _, _ in fatalError() },
      validatePassword: mockValidate(password:),
      scheduler: scheduler.eraseToAnyScheduler()
    )
    
    var passwordValidationMessage: [String] = []
    viewModel.$passwordValidationMessage
      .sink { passwordValidationMessage.append($0) }
      .store(in: &self.cancellables)
    
    XCTAssertEqual(passwordValidationMessage, [""])
    
    viewModel.password = "blob"
//    _ = XCTWaiter.wait(for: [XCTestExpectation()], timeout: 0.31)
    scheduler.advance(by: .milliseconds(300))
    XCTAssertEqual(passwordValidationMessage, ["", "Password is too short 👎"])

    viewModel.password = "blob is awesome"
//    _ = XCTWaiter.wait(for: [XCTestExpectation()], timeout: 0.21)
    scheduler.advance(by: .milliseconds(200))
    XCTAssertEqual(passwordValidationMessage, ["", "Password is too short 👎"])
    
    viewModel.password = "blob is awesome!!!!!!"
//    _ = XCTWaiter.wait(for: [XCTestExpectation()], timeout: 0.31)
    scheduler.advance(by: .milliseconds(300))
    XCTAssertEqual(passwordValidationMessage, ["", "Password is too short 👎", "Password is too long 👎"])
  }
    
  func testImmediateScheduledAction() {
    var isExecuted = false
    scheduler.schedule {
      isExecuted = true
    }
    
    XCTAssertEqual(isExecuted, false)
    scheduler.advance()
    XCTAssertEqual(isExecuted, true)
  }
  
  func testMultipleImmediateScheduledActions() {
    var executionCount = 0
    
    scheduler.schedule {
      executionCount += 1
    }
    scheduler.schedule {
      executionCount += 1
    }
    
    XCTAssertEqual(executionCount, 0)
    scheduler.advance()
    XCTAssertEqual(executionCount, 2)
  }
  
  func testImmedateScheduledActionWithPublisher() {
    var output: [Int] = []
    
    Just(1)
      .receive(on: scheduler)
      .sink { output.append($0) }
      .store(in: &self.cancellables)
    
    XCTAssertEqual(output, [])
    scheduler.advance()
    XCTAssertEqual(output, [1])
  }
  
  func testImmedateScheduledActionWithMultiplePublishers() {
    var output: [Int] = []
    
    Just(1)
      .receive(on: scheduler)
      .merge(with: Just(2).receive(on: scheduler))
      .sink { output.append($0) }
      .store(in: &self.cancellables)
    
    XCTAssertEqual(output, [])
    scheduler.advance()
    XCTAssertEqual(output, [1, 2])
  }

  func testScheduledAfterDelay() {
    var isExecuted = false
    scheduler.schedule(after: scheduler.now.advanced(by: 1)) {
      isExecuted = true
    }

    XCTAssertEqual(isExecuted, false)
    scheduler.advance(by: .milliseconds(500))
    XCTAssertEqual(isExecuted, false)
    scheduler.advance(by: .milliseconds(499))
    XCTAssertEqual(isExecuted, false)
    scheduler.advance(by: .microseconds(999))
    XCTAssertEqual(isExecuted, false)
    scheduler.advance(by: .microseconds(1))
    XCTAssertEqual(isExecuted, true)
  }

  func testScheduledAfterALongDelay() {
    var isExecuted = false
    scheduler.schedule(after: scheduler.now.advanced(by: 1_000_000)) {
      isExecuted = true
    }

    XCTAssertEqual(isExecuted, false)
    scheduler.advance(by: .seconds(1_000_000))
    XCTAssertEqual(isExecuted, true)

  }

  func testSchedulerInterval() {
    var executionCount = 0

    scheduler.schedule(after: scheduler.now, interval: 1) {
      executionCount += 1
    }
    .store(in: &self.cancellables)

    XCTAssertEqual(executionCount, 0)
    scheduler.advance()
    XCTAssertEqual(executionCount, 1)
    scheduler.advance(by: .milliseconds(500))
    XCTAssertEqual(executionCount, 1)
    scheduler.advance(by: .milliseconds(500))
    XCTAssertEqual(executionCount, 2)
    scheduler.advance(by: .seconds(1))
    XCTAssertEqual(executionCount, 3)

    scheduler.advance(by: .seconds(5))
    XCTAssertEqual(executionCount, 8)
  }
  
  func testScheduledTwoIntervals_Fail() {
    var values: [String] = []
    scheduler.schedule(after: scheduler.now.advanced(by: 1), interval: 1) {
      values.append("Hello")
    }
    .store(in: &self.cancellables)
    scheduler.schedule(after: scheduler.now.advanced(by: 2), interval: 2) {
      values.append("World")
    }
    .store(in: &self.cancellables)

    XCTAssertEqual(values, [])
    scheduler.advance(by: 2)
    XCTAssertEqual(values, ["Hello", "Hello", "World"])
  }
  
  func testSchedulerNow() {
    var times: [UInt64] = []
    scheduler.schedule(after: scheduler.now, interval: 1) {
      times.append(self.scheduler.now.dispatchTime.uptimeNanoseconds)
    }
    .store(in: &self.cancellables)
    
    XCTAssertEqual(times, [])
    scheduler.advance(by: 3)
    XCTAssertEqual(times, [1, 1_000_000_001, 2_000_000_001, 3_000_000_001])
  }
  
  func testScheduledIntervalCancellation() {
    var executionCount = 0

    scheduler.schedule(after: scheduler.now, interval: 1) {
      executionCount += 1
    }
    .store(in: &self.cancellables)

    XCTAssertEqual(executionCount, 0)
    scheduler.advance()
    XCTAssertEqual(executionCount, 1)
    scheduler.advance(by: .milliseconds(500))
    XCTAssertEqual(executionCount, 1)
    scheduler.advance(by: .milliseconds(500))
    XCTAssertEqual(executionCount, 2)
    
    self.cancellables.removeAll()
    
    scheduler.advance(by: .seconds(1))
    XCTAssertEqual(executionCount, 2)
  }

  func testFun() {
    var values: [Int] = []
    scheduler.schedule(after: scheduler.now, interval: 1) {
      values.append(values.count)
    }
    .store(in: &self.cancellables)

    XCTAssertEqual(values, [])
    scheduler.advance(by: 1000)
    XCTAssertEqual(values, Array(0...1_000))
  }

  func testFail() {
    let subject = PassthroughSubject<Void, Never>()

    var count = 0
    subject
      .debounce(for: 1, scheduler: scheduler)
      .receive(on: scheduler)
      .sink { count += 1 }
      .store(in: &self.cancellables)

    subject.send()
    scheduler.advance(by: 100)
    XCTAssertEqual(count, 1)
  }

  func testRace_CacheEmitsFirst() {
    var output: [Int] = []

    race(
      cached: Future<Int, Never> { callback in
        self.scheduler.schedule(after: self.scheduler.now.advanced(by: 1)) {
          callback(.success(2))
        }
      },
      fresh: Future<Int, Never> { callback in
        self.scheduler.schedule(after: self.scheduler.now.advanced(by: 2)) {
          callback(.success(42))
        }
      }
    )
      .sink { output.append($0) }
      .store(in: &self.cancellables)

    XCTAssertEqual(output, [])
    scheduler.advance(by: 2)
    XCTAssertEqual(output, [2, 42])
  }

  func testRace_FreshEmitsFirst() {
    var output: [Int] = []

    race(
      cached: Future<Int, Never> { callback in
        self.scheduler.schedule(after: self.scheduler.now.advanced(by: 2)) {
          callback(.success(2))
        }
      },
      fresh: Future<Int, Never> { callback in
        self.scheduler.schedule(after: self.scheduler.now.advanced(by: 1)) {
          callback(.success(42))
        }
      }
    )
      .sink { output.append($0) }
      .store(in: &self.cancellables)

    XCTAssertEqual(output, [])
    scheduler.advance(by: 2)
    XCTAssertEqual(output, [42])
  }
}

import Combine

func race<Output, Failure: Error>(
  cached: Future<Output, Failure>,
  fresh: Future<Output, Failure>
  ) -> AnyPublisher<Output, Failure> {

  Publishers.Merge(
    cached.map { (model: $0, isCached: true) },
    fresh.map { (model: $0, isCached: false) }
  )
    .scan((nil, nil)) { accum, output in
      (accum.1, output)
  }
  .prefix(while: { lhs, rhs in
    !(rhs?.isCached ?? true) || (lhs?.isCached ?? true)
  })
    .compactMap(\.1?.model)
    .eraseToAnyPublisher()
}
