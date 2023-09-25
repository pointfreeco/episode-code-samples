import MacroTesting
import XCTest

final class FontLiteralMacroTests: BaseTestCase {
  override func invokeTest() {
    withMacroTesting(macros: [FontLiteralMacro.self]) {
      super.invokeTest()
    }
  }

  func testFontLiteral() {
    assertMacro {
      """
      struct Font: ExpressibleByFontLiteral {
        init(fontLiteralName: String, size: Int, weight: MacroExamplesLib.FontWeight) {
        }
      }

      let _: Font = #fontLiteral(name: "Comic Sans", size: 14, weight: .thin)
      """
    } matches: {
      """
      struct Font: ExpressibleByFontLiteral {
        init(fontLiteralName: String, size: Int, weight: MacroExamplesLib.FontWeight) {
        }
      }

      let _: Font = .init(fontLiteralName: "Comic Sans", size: 14, weight: .thin)
      """
    }
  }
}
