import SwiftSyntaxMacros
import SwiftSyntaxMacrosTestSupport
import XCTest

// Macro implementations build for the host, so the corresponding module is not available when cross-compiling. Cross-compiled tests may still make use of the macro itself in end-to-end tests.
#if canImport(ExperimentationMacros)
import ExperimentationMacros

let testMacros: [String: Macro.Type] = [
  "stringify": StringifyMacro.self,
]
#endif

final class ExperimentationTests: XCTestCase {
  func testMacro() throws {
#if canImport(ExperimentationMacros)
    assertMacroExpansion(
            """
            #stringify(a + b)
            """,
            expandedSource: """
            (
                value: a + b,
                string: "a + b"
            )
            """,
            macros: testMacros
    )
#else
    throw XCTSkip("macros are only supported when running tests for the host platform")
#endif
  }

  func testMacro_LongArgumentDiagnostic() throws {
    assertMacroExpansion(
      """
      #stringify((a + b) * (a - b) * (b - a))
      """,
      expandedSource: """
      #stringify((a + b) * (a - b) * (b - a))
      """,
      diagnostics: [
        DiagnosticSpec(message: "SomeError()", line: 1, column: 1),
        DiagnosticSpec(message: "SomeError()", line: 1, column: 1),
      ],
      macros: testMacros
    )
  }

  func testMacroWithStringLiteral() throws {
#if canImport(ExperimentationMacros)
    assertMacroExpansion(
            #"""
            #stringify("Hello, \(name)")
            """#,
            expandedSource: #"""
            (
                value: "Hello, \(name)",
                string: #""Hello, \(name)""#
            )
            """#,
            macros: testMacros
    )
#else
    throw XCTSkip("macros are only supported when running tests for the host platform")
#endif
  }
}
