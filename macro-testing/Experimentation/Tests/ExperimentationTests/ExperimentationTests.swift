import MacroTesting
import InlineSnapshotTesting
import SwiftSyntaxMacros
import SwiftSyntaxMacrosTestSupport
import SwiftUI
import XCTest

// Macro implementations build for the host, so the corresponding module is not available when cross-compiling. Cross-compiled tests may still make use of the macro itself in end-to-end tests.
#if canImport(ExperimentationMacros)
import ExperimentationMacros

let testMacros: [String: Macro.Type] = [
  "stringify": StringifyMacro.self,
]
#endif

final class ExperimentationTests: XCTestCase {
  override func invokeTest() {
    withMacroTesting(
//      isRecording: true,
      macros: [StringifyMacro.self]
    ) {
      super.invokeTest()
    }
  }

  func testMacro() throws {
#if canImport(ExperimentationMacros)
    assertMacroExpansion(
      """
      #stringify(a + b)
      """,
      expandedSource: """
      (a + b, "a + b")
      """,
      macros: testMacros
    )
#else
    throw XCTSkip("macros are only supported when running tests for the host platform")
#endif
  }

  func testMacro_Improved() {
    assertMacro {
      "#stringify(a + b)"
    } matches: {
      """
      (a + b, "a + b")
      """
    }
    SnapshotTesting.diffTool = "ksdiff"
    assertSnapshot(
      of: Text("Bye")
        .frame(width: 200, height: 200)
        .background {
          Color.yellow.opacity(0.2)
        },
      as: .image
    )
    struct User: Codable {
      let id: Int
      var name: String
    }
    assertInlineSnapshot(of: User(id: 42, name: "Blob"), as: .json) {
      """
      {
        "id" : 42,
        "name" : "Blob"
      }
      """
    }
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

  func testMacro_LongArgumentDiagnostic_Improved() throws {
    assertMacro {
      """
      let (result, string) = #stringify((a + b) * (a - b) * (b - a))
      """
    } matches: {
      """
      let (result, string) = #stringify((a + b) * (a - b) * (b - a))
                             ┬──────────────────────────────────────
                             ╰─ 🛑 SomeError()
      """
    }
  }

  func testMacroWithStringLiteral() throws {
#if canImport(ExperimentationMacros)
    assertMacroExpansion(
      #"""
      #stringify("Hello, \(name)")
      """#,
      expandedSource: #"""
      ("Hello, \(name)", #""Hello, \(name)""#)
      """#,
      macros: testMacros
    )
#else
    throw XCTSkip("macros are only supported when running tests for the host platform")
#endif
  }
}
