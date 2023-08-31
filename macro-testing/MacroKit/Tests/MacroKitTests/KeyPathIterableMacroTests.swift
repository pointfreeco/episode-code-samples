import SwiftSyntaxMacros
import SwiftSyntaxMacrosTestSupport
import XCTest
import MacroKitMacros

private let testMacros: [String: Macro.Type] = [
    "KeyPathIterable": KeyPathIterableMacro.self,
]

final class KeyPathIterableMacroTests: XCTestCase {
    func testKeyPathIterable_HappyPath() {
        assertMacroExpansion(
            """
            @KeyPathIterable
            struct Foo {
                var a: String
                var b: Int
                var c: Int { b + 1 }
                private var d: Bool = true
                var e = false
                func hello() { }
                func world() -> Int { 0 }
            }
            """,
            expandedSource: #"""
            struct Foo {
                var a: String
                var b: Int
                var c: Int { b + 1 }
                private var d: Bool = true
                var e = false
                func hello() { }
                func world() -> Int { 0 }

                internal static var allKeyPaths: [PartialKeyPath<Foo>] {
                    return [\Foo.a, \Foo.b, \Foo.c, \Foo.e]
                }
            }
            """#,
            macros: testMacros
        )
    }
}
