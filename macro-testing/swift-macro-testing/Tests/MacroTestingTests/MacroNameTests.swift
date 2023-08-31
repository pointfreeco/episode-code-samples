import XCTest

@testable import MacroTesting

final class MacroNameTests: BaseTestCase {
  func testBasics() {
    XCTAssertEqual(
      macroName(className: "AddAsyncHandler", isExpression: false),
      "AddAsyncHandler"
    )
    XCTAssertEqual(
      macroName(className: "AddAsyncHandlerMacro", isExpression: false),
      "AddAsyncHandler"
    )
    XCTAssertEqual(
      macroName(className: "URL", isExpression: false),
      "URL"
    )
    XCTAssertEqual(
      macroName(className: "URLMacro", isExpression: false),
      "URL"
    )
    XCTAssertEqual(
      macroName(className: "URL", isExpression: true),
      "url"
    )
    XCTAssertEqual(
      macroName(className: "URLMacro", isExpression: true),
      "url"
    )
    XCTAssertEqual(
      macroName(className: "URLComponents", isExpression: true),
      "urlComponents"
    )
    XCTAssertEqual(
      macroName(className: "URLComponentsMacro", isExpression: true),
      "urlComponents"
    )
    XCTAssertEqual(
      macroName(className: "FontLiteral", isExpression: true),
      "fontLiteral"
    )
    XCTAssertEqual(
      macroName(className: "FontLiteralMacro", isExpression: true),
      "fontLiteral"
    )
  }
}
