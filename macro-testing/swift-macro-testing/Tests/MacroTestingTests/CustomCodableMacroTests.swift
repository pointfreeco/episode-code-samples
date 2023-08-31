import MacroTesting
import XCTest

final class CustomCodableMacroTests: BaseTestCase {
  override func invokeTest() {
    withMacroTesting(macros: [CodableKey.self, CustomCodable.self]) {
      super.invokeTest()
    }
  }

  func testCustomCodable() {
    assertMacro {
      """
      @CustomCodable
      struct CustomCodableString: Codable {
        @CodableKey(name: "OtherName")
        var propertyWithOtherName: String
        var propertyWithSameName: Bool
        func randomFunction() {}
      }
      """
    } matches: {
      """
      struct CustomCodableString: Codable {
        var propertyWithOtherName: String
        var propertyWithSameName: Bool
        func randomFunction() {}

        enum CodingKeys: String, CodingKey {
          case propertyWithOtherName = "OtherName"
          case propertyWithSameName
        }
      }
      """
    }
  }
}
