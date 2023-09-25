import MacroTesting
import SwiftSyntaxMacros
import XCTest

final class FailureTests: BaseTestCase {
  func testApplyFixIts_NoFixIts() {
    struct MyMacro: Macro {}
    XCTExpectFailure {
      $0.compactDescription == "failed - No fix-its to apply."
    }
    assertMacro(["MyMacro": MyMacro.self], applyFixIts: true) {
      """
      let foo = "bar"
      """
    } matches: {
      """
      let foo = "bar"
      """
    }
  }

  func testApplyFixIts_Unfixable() {
    XCTExpectFailure {
      $0.compactDescription == "failed - Not all diagnostics are fixable."
    }
    assertMacro(["MetaEnum": MetaEnumMacro.self], applyFixIts: true) {
      """
      @MetaEnum struct Cell {
        let integer: Int
        let text: String
        let boolean: Bool
      }
      """
    } matches: {
      """
      @MetaEnum struct Cell {
      ┬────────
      ╰─ 🛑 '@MetaEnum' can only be attached to an enum, not a struct
        let integer: Int
        let text: String
        let boolean: Bool
      }
      """
    }
  }

}
