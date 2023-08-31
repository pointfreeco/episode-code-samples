import MacroTesting
import XCTest

final class WarningMacroTests: BaseTestCase {
  override func invokeTest() {
    withMacroTesting(macros: ["myWarning": WarningMacro.self]) {
      super.invokeTest()
    }
  }

  func testWarning() {
    assertMacro {
      #"""
      #myWarning("remember to pass a string literal here")
      """#
    } matches: {
      """
      #myWarning("remember to pass a string literal here")
      ┬───────────────────────────────────────────────────
      ╰─ ⚠️ remember to pass a string literal here
      """
    }
  }

  func testNonLiteral() {
    // NB: This doubled diagnostic seems to be a bug in swift-syntax macro expansion
    assertMacro {
      """
      let text = "oops"
      #myWarning(text)
      """
    } matches: {
      """
      let text = "oops"
      #myWarning(text)
      ├─ 🛑 #myWarning macro requires a string literal
      ╰─ 🛑 #myWarning macro requires a string literal
      """
    }
  }
}
