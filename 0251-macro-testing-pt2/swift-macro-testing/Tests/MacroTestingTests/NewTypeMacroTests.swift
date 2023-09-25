import MacroTesting
import XCTest

final class NewTypeMacroTests: BaseTestCase {
  override func invokeTest() {
    withMacroTesting(macros: [NewTypeMacro.self]) {
      super.invokeTest()
    }
  }

  func testNewType() {
    assertMacro {
      """
      @NewType(String.self)
      public struct MyString {
      }
      """
    } matches: {
      """
      public struct MyString {

          public typealias RawValue = String

          public var rawValue: RawValue

          public init(_ rawValue: RawValue) {
              self.rawValue = rawValue
          }
      }
      """
    }
  }
}
