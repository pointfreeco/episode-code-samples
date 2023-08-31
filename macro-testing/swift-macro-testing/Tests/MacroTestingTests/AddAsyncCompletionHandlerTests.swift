import MacroTesting
import XCTest

final class AddAsyncCompletionHandlerMacroTests: BaseTestCase {
  override func invokeTest() {
    withMacroTesting(macros: [AddAsyncMacro.self, AddCompletionHandlerMacro.self]) {
      super.invokeTest()
    }
  }

  func testAddAsyncCompletionHandler() {
    assertMacro {
      #"""
      struct MyStruct {
        @AddCompletionHandler
        func f(a: Int, for b: String, _ value: Double) async -> String {
          return b
        }

        @AddAsync
        func c(a: Int, for b: String, _ value: Double, completionBlock: @escaping (Result<String, Error>) -> Void) -> Void {
          completionBlock(.success("a: \(a), b: \(b), value: \(value)"))
        }

        @AddAsync
        func d(a: Int, for b: String, _ value: Double, completionBlock: @escaping (Bool) -> Void) -> Void {
          completionBlock(true)
        }
      }
      """#
    } matches: {
      #"""
      struct MyStruct {
        func f(a: Int, for b: String, _ value: Double) async -> String {
          return b
        }

        func f(a: Int, for b: String, _ value: Double, completionHandler: @escaping (String) -> Void) {
          Task {
            completionHandler(await f(a: a, for: b, value))
          }
        }
        func c(a: Int, for b: String, _ value: Double, completionBlock: @escaping (Result<String, Error>) -> Void) -> Void {
          completionBlock(.success("a: \(a), b: \(b), value: \(value)"))
        }

        func c(a: Int, for b: String, _ value: Double) async  throws -> String {
          try await withCheckedThrowingContinuation { continuation in
            c(a: a, for: b, value) { returnValue in

              switch returnValue {
              case .success(let value):
                  continuation.resume(returning: value)
              case .failure(let error):
                  continuation.resume(throwing: error)
              }

            }
          }
        }
        func d(a: Int, for b: String, _ value: Double, completionBlock: @escaping (Bool) -> Void) -> Void {
          completionBlock(true)
        }

        func d(a: Int, for b: String, _ value: Double) async -> Bool {
          await withCheckedContinuation { continuation in
            d(a: a, for: b, value) { returnValue in

            continuation.resume(returning: returnValue)

            }
          }
        }
      }
      """#
    }
  }

  func testNonFunctionDiagnostic() {
    assertMacro {
      """
      @AddCompletionHandler
      struct Foo {}
      """
    } matches: {
      """
      @AddCompletionHandler
      ┬────────────────────
      ╰─ 🛑 @addCompletionHandler only works on functions
      struct Foo {}
      """
    }
  }

  func testNonAsyncFunctionDiagnostic() {
    let source = """
      @AddCompletionHandler
      func f(a: Int, for b: String, _ value: Double) -> String {
        return b
      }
      """
    assertMacro { source } matches: {
      """
      @AddCompletionHandler
      func f(a: Int, for b: String, _ value: Double) -> String {
      ╰─ 🛑 can only add a completion-handler variant to an 'async' function
         ✏️ add 'async'
        return b
      }
      """
    }
    assertMacro(applyFixIts: true) { source } matches: {
      """
      @AddCompletionHandler
      func f(a: Int, for b: String, _ value: Double) async -> String {
        return b
      }
      """
    }
  }
}
