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
      $0.factPrompt = .init(count: 1, fact: "1 is a good number.")
    }
    store.send(.factPrompt(.dismissButtonTapped)) {
      $0.factPrompt = nil
    }
    store.send(.counterRow(id: id, action: .removeButtonTapped)) {
      $0.counters = []
    }
  }
  
  func testViewModel() {
    let id = UUID(uuidString: "00000000-0000-0000-0000-000000000000")!
    let viewModel = AppViewModel(
      fact: FactClient(fetch: {
        .init(value: "\($0) is a good number.")
      }),
      mainQueue: .immediate,
      uuid: { id }
    )
    
    viewModel.addButtonTapped()
    XCTAssertEqual(
      viewModel.counters.count,
      1
    )
    XCTAssertEqual(viewModel.counters[0].counter.count, 0)
    
    viewModel.counters[0].counter.incrementButtonTapped()
    XCTAssertEqual(viewModel.counters[0].counter.count, 1)
    
    viewModel.counters[0].counter.factButtonTapped()
    XCTAssertNotNil(viewModel.factPrompt)
    XCTAssertEqual(viewModel.factPrompt?.count, 1)
    XCTAssertEqual(viewModel.factPrompt?.fact, "1 is a good number.")
    
    viewModel.dismissFactPrompt()
    XCTAssertNil(viewModel.factPrompt)
    
    viewModel.counters[0].removeButtonTapped()
    // TODO: assert analytics tracked
    viewModel.removeButtonTapped(id: id)
    XCTAssertEqual(viewModel.counters.count, 0)
  }
}
