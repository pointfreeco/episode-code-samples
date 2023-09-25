import MacroTesting
import XCTest

final class WrapStoredPropertiesMacroTests: BaseTestCase {
  override func invokeTest() {
    withMacroTesting(macros: ["wrapStoredProperties": WrapStoredPropertiesMacro.self]) {
      super.invokeTest()
    }
  }

  func testWrapStoredProperties() {
    assertMacro {
      """
      @wrapStoredProperties(#"available(*, deprecated, message: "hands off my data")"#)
      struct OldStorage {
        var x: Int
      }
      """
    } matches: {
      """
      struct OldStorage {
        @available(*, deprecated, message: "hands off my data")
        var x: Int
      }
      """
    }
  }
}
