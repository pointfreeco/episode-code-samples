import CasePathsMacros
import MacroTesting
import XCTest

final class CasePathableMacroTests: XCTestCase {
  override func invokeTest() {
    withMacroTesting(
      isRecording: true,
      macros: [CasePathableMacro.self]
    ) {
      super.invokeTest()
    }
  }

  func testBasics() {
    assertMacro {
      """
      @CasePathable
      enum Action {
        case feature1(Feature1.Action)
        case feature2(Feature2.Action)
      }
      """
    } expansion: {
      """
      enum Action {
        case feature1(Feature1.Action)
        case feature2(Feature2.Action)

        struct Cases {
        }
        static let cases = Cases()
      }
      """
    }
  }
}
