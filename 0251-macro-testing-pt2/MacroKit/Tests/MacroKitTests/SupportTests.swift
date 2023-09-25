import SwiftParser
import SwiftSyntaxMacros
import SwiftSyntaxMacrosTestSupport
import XCTest
import MacroKitMacros

final class VariableDeclSyntaxTests: XCTestCase {
    func testIdentifier() {
        var source = Parser
            .parse(source: "static var foo: Int")
            .statements.child(at: 0)!.item
            .as(VariableDeclSyntax.self)!

        XCTAssertEqual(source.accessLevel, .internal)
        source.accessLevel = .public
        XCTAssertEqual(source.accessLevel, .public)

        XCTAssertSyntaxEqual(source, "static public var foo: Int")
    }
}
