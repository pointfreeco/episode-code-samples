import SwiftSyntaxMacros
import SwiftSyntaxMacrosTestSupport
import XCTest
import MacroKitMacros

private let testMacros: [String: Macro.Type] = [
    "StaticMemberIterable": StaticMemberIterableMacro.self,
]

final class StaticMemberIterableMacroTests: XCTestCase {
    func testStaticMemberIterable_HappyPath() {
        assertMacroExpansion(
            """
            @StaticMemberIterable
            struct Foo {
                private static var foo: String
                static var bar: String
                var florp: Int = 42
                func qux() { }
            }
            """,
            expandedSource: #"""

            struct Foo {
                private static var foo: String
                static var bar: String
                var florp: Int = 42
                func qux() { }
            
                internal static var allStaticMembers = [bar]
            }
            """#,
            macros: testMacros
        )
    }
}
