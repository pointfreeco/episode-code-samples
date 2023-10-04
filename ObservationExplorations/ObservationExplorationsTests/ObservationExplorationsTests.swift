import ConcurrencyExtras
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

  func testObservableStruct() {
    var state = CounterState()
    var copy = state
    let stateChanges = LockIsolated<[String]>([])
    let copyChanges = LockIsolated<[String]>([])
    withObservationTracking {
      _ = state.count
    } onChange: {
      stateChanges.withValue { $0.append("State is changing") }
    }
    withObservationTracking {
      _ = copy.count
    } onChange: {
      copyChanges.withValue { $0.append("Copy is changing") }
    }
    state.count += 1
    XCTAssertEqual(stateChanges.value, ["State is changing"])
    XCTAssertEqual(copyChanges.value, [])
    copy.count += 1
    XCTAssertEqual(stateChanges.value, ["State is changing"])
    XCTAssertEqual(copyChanges.value, ["Copy is changing"])
  }

  func testObservableStruct_AssignCopy() {
    var state = CounterState()
    var copy = state
    let stateChanges = LockIsolated<[String]>([])
    let copyChanges = LockIsolated<[String]>([])
    withObservationTracking {
      _ = state.count
    } onChange: {
      stateChanges.withValue { $0.append("State is changing") }
    }
    withObservationTracking {
      _ = copy.count
    } onChange: {
      copyChanges.withValue { $0.append("Copy is changing") }
    }
    copy.count += 1
    XCTAssertEqual(stateChanges.value, [])
    XCTAssertEqual(copyChanges.value, ["Copy is changing"])
    state = copy
    XCTAssertEqual(stateChanges.value, ["State is changing"])
    XCTAssertEqual(copyChanges.value, ["Copy is changing"])
  }

}

//@Observable
struct CounterState: Observable {
  private var _count  = 0
  var count: Int {
    @storageRestrictions(initializes: _count )
    init(initialValue) {
      _count  = initialValue
    }

    get {
      access(keyPath: \.count )
      return _count
    }

    set {
      withMutation(keyPath: \.count ) {
        _count  = newValue
      }
    }
  }
  private let _$observationRegistrar = Observation.ObservationRegistrar()

  internal nonisolated func access<Member>(
      keyPath: KeyPath<CounterState , Member>
  ) {
    _$observationRegistrar.access(self, keyPath: keyPath)
  }

  internal nonisolated func withMutation<Member, MutationResult>(
    keyPath: KeyPath<CounterState , Member>,
    _ mutation: () throws -> MutationResult
  ) rethrows -> MutationResult {
    try _$observationRegistrar.withMutation(of: self, keyPath: keyPath, mutation)
  }
}
