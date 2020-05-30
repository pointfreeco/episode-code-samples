import ComposableArchitecture
import XCTest
@testable import Todos

class TodosTests: XCTestCase {
  func testCompletingTodo() {
    let store = TestStore(
      initialState: AppState(
        todos: [
          Todo(
            description: "Milk",
            id: UUID(uuidString: "00000000-0000-0000-0000-000000000000")!,
            isComplete: false
          )
        ]
      ),
      reducer: appReducer,
      environment: AppEnvironment(
        uuid: { fatalError("unimplemented") }
      )
    )
    
    store.assert(
      .send(.todo(index: 0, action: .checkboxTapped)) {
        $0.todos[0].isComplete = true
      }
    )
  }
  
  func testAddTodo() {
    let store = TestStore(
      initialState: AppState(),
      reducer: appReducer,
      environment: AppEnvironment(
        uuid: { UUID(uuidString: "DEADBEEF-DEAD-BEEF-DEAD-DEADBEEFDEAD")! }
      )
    )
    
    store.assert(
      .send(.addButtonTapped) {
        $0.todos = [
          Todo(
            description: "",
            id: UUID(uuidString: "DEADBEEF-DEAD-BEEF-DEAD-DEADBEEFDEAD")!,
            isComplete: false
          )
        ]
      }
    )
  }
  
  func testTodoSorting() {
    let store = TestStore(
      initialState: AppState(
        todos: [
          Todo(
            description: "Milk",
            id: UUID(uuidString: "00000000-0000-0000-0000-000000000000")!,
            isComplete: false
          ),
          Todo(
            description: "Eggs",
            id: UUID(uuidString: "00000000-0000-0000-0000-000000000001")!,
            isComplete: false
          )
        ]
      ),
      reducer: appReducer,
      environment: AppEnvironment(
        uuid: { fatalError("unimplemented") }
      )
    )
    
    store.assert(
      .send(.todo(index: 0, action: .checkboxTapped)) {
        $0.todos[0].isComplete = true
//        $0.todos = [
//          $0.todos[1],
//          $0.todos[0],
//        ]
        $0.todos.swapAt(0, 1)
        
//        $0.todos = [
//          Todo(
//            description: "Eggs",
//            id: UUID(uuidString: "00000000-0000-0000-0000-000000000001")!,
//            isComplete: false
//          ),
//
//          Todo(
//            description: "Milk",
//            id: UUID(uuidString: "00000000-0000-0000-0000-000000000000")!,
//            isComplete: true
//          ),
//        ]
      
      }
    )
  }
  
}
