import SwiftSyntaxMacros
import SwiftSyntaxMacrosTestSupport
import XCTest
import MacroKitMacros

private let testMacros: [String: Macro.Type] = [
    "UnkeyedCodable": UnkeyedCodableMacro.self,
]

final class UnkeyedCodableMacroTests: XCTestCase {
    func testUnkeyedCodable_HappyPath() {
        assertMacroExpansion(
            """
            @UnkeyedCodable
            public struct Foo {
                var a: String
                private var b: Int = 42
                var c = true {
                  didSet {}
                  willSet {}
                }
                var b2: Int {
                    return b + 1
                }
            }
            """,
            expandedSource: """
            
            public struct Foo {
                var a: String
                private var b: Int = 42
                var c = true {
                  didSet {}
                  willSet {}
                }
                var b2: Int {
                    return b + 1
                }

                public init(from decoder: Decoder) throws {
                    var container = try decoder.unkeyedContainer()
                    self.a = try container.decode(String.self)
                    self.b = try container.decode(Int.self)
                }

                public func encode(to encoder: Encoder) throws {
                    var container = encoder.unkeyedContainer()
                    try container.encode(self.a)
                    try container.encode(self.b)
                }
            }
            """,
            diagnostics: [
                .init(message: "@UnkeyedCodable requires stored properties provide explicit type annotations", line: 5, column: 5),
                .init(message: "@UnkeyedCodable requires stored properties provide explicit type annotations", line: 5, column: 5),
            ],
            macros: testMacros
        )
    }
}

