import MacroTesting
import XCTest

final class AddBlockerTests: BaseTestCase {
  override func invokeTest() {
    withMacroTesting(macros: [AddBlocker.self]) {
      super.invokeTest()
    }
  }

  func testAddBlocker() {
    let source = """
      let x = 1
      let y = 2
      let z = 3
      #addBlocker(x * y + z)
      """
    assertMacro { source } matches: {
      """
      let x = 1
      let y = 2
      let z = 3
      #addBlocker(x * y + z)
                        ╰─ ⚠️ blocked an add; did you mean to subtract?
                           ✏️ use '-'
      """
    }
    assertMacro(applyFixIts: true) { source } matches: {
      """
      let x = 1
      let y = 2
      let z = 3
      #addBlocker(x * y - z)
      """
    }
  }

  func testAddBlocker_Inline() {
    let source = """
      #addBlocker(1 * 2 + 3)
      """
    assertMacro { source } matches: {
      """
      #addBlocker(1 * 2 + 3)
                        ╰─ ⚠️ blocked an add; did you mean to subtract?
                           ✏️ use '-'
      """
    }
    assertMacro(applyFixIts: true) { source } matches: {
      """
      #addBlocker(1 * 2 - 3)
      """
    }
  }

  func testAddBlocker_Expanded() {
    assertMacro {
      """
      #addBlocker(1 * 2 - 3)
      """
    } matches: {
      """
      1 * 2 - 3
      """
    }
  }
}
