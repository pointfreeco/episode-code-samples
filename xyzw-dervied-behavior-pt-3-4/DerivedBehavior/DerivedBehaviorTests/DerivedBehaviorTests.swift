import ComposableArchitecture
import XCTest
@testable import DerivedBehavior

class DerivedBehaviorTests: XCTestCase {
  func testBasics() {
    let id = UUID(uuidString: "00000000-0000-0000-0000-000000000000")!
    let store = TestStore(
      initialState: AppState(counters: []),
      reducer: appReducer,
      environment: AppEnvironment(
        fact: FactClient(fetch: {
          .init(value: "\($0) is a good number.")
        }),
        mainQueue: .immediate,
        uuid: { id }
      )
    )
    store.send(.addButtonTapped) {
      $0.counters = [
        .init(counter: .init(), id: id)
      ]
    }
    store.send(.counterRow(id: id, action: .counter(.incrementButtonTapped))) {
      $0.counters[id: id]?.counter.count = 1
    }
    store.send(.counterRow(id: id, action: .counter(.factButtonTapped)))
    store.receive(.counterRow(id: id, action: .counter(.factResponse(.success("1 is a good number."))))) {
//      $0.counters[id: id]?.counter.alert = .init(message: "1 is a good number.", title: "Fact")
      $0.factPrompt = .init(count: 1, fact: "1 is a good number.")
    }
//    store.send(.counterRow(id: id, action: .counter(.dismissAlert))) {
//      $0.counters[id: id]?.counter.alert = nil
//    }
    store.send(.factPrompt(.dismissButtonTapped)) {
      $0.factPrompt = nil
    }
    store.send(.counterRow(id: id, action: .removeButtonTapped)) {
      $0.counters = []
    }
  }
}
