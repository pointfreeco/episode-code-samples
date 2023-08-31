import SwiftSyntaxMacros
import SwiftSyntaxMacrosTestSupport
import XCTest
import MacroKitMacros

private let testMacros: [String: Macro.Type] = [
    "Default": DefaultMacro.self,
]

final class DefaultMacroTests: XCTestCase {
    func testDefault_HappyPath() {
        assertMacroExpansion(
            """
            struct Foo: Codable {
                @Default(true) var value: Bool
            }
            """,
            expandedSource: #"""
            struct Foo: Codable {
                var value: Bool {
                    get {
                        _value.wrappedValue
                    }
                    set {
                        _value.wrappedValue = newValue
                    }
                }

                private enum _valueDefault: DefaultValue {
                    static var value = true
                }
            
                private var _value: Default<_valueDefault>
            }
            """#,
            macros: testMacros
        )
    }
}
