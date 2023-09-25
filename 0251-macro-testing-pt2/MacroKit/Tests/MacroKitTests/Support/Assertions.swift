import SwiftParser
import SwiftSyntax
import SwiftSyntaxMacros
import SwiftSyntaxMacrosTestSupport
import XCTest

public func XCTAssertSyntaxEqual<S: SyntaxProtocol>(_ syntax: S, _ value: String, file: StaticString = #file, line: UInt = #line) {
    XCTAssertEqual(syntax.formatted().description, value, file: file, line: line)
}
