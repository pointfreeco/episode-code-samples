import MacroTesting
import XCTest

final class MetaEnumMacroTests: BaseTestCase {
  override func invokeTest() {
    withMacroTesting(macros: [MetaEnumMacro.self]) {
      super.invokeTest()
    }
  }

  func testMetaEnum() {
    assertMacro {
      #"""
      @MetaEnum enum Value {
        case integer(Int)
        case text(String)
        case boolean(Bool)
        case null
      }
      """#
    }  matches: {
      """
      enum Value {
        case integer(Int)
        case text(String)
        case boolean(Bool)
        case null

        enum Meta {
          case integer
          case text
          case boolean
          case null
          init(_ __macro_local_6parentfMu_: Value) {
            switch __macro_local_6parentfMu_ {
            case .integer:
              self = .integer
            case .text:
              self = .text
            case .boolean:
              self = .boolean
            case .null:
              self = .null
            }
          }
        }
      }
      """
    }
  }

  func testAccess() {
    assertMacro {
      """
      @MetaEnum public enum Cell {
        case integer(Int)
        case text(String)
        case boolean(Bool)
      }
      """
    } matches: {
      """
      public enum Cell {
        case integer(Int)
        case text(String)
        case boolean(Bool)

        public enum Meta {
          case integer
          case text
          case boolean
          public init(_ __macro_local_6parentfMu_: Cell) {
            switch __macro_local_6parentfMu_ {
            case .integer:
              self = .integer
            case .text:
              self = .text
            case .boolean:
              self = .boolean
            }
          }
        }
      }
      """
    }
  }

  func testNonEnum() {
    assertMacro {
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
                ┬─────
                ╰─ 🛑 '@MetaEnum' can only be attached to an enum, not a struct
        let integer: Int
        let text: String
        let boolean: Bool
      }
      """
    }
  }

  func testOverloadedCaseName() {
    assertMacro {
      """
      @MetaEnum enum Foo {
        case bar(int: Int)
        case bar(string: String)
      }
      """
    } matches: {
      """
      @MetaEnum enum Foo {
        case bar(int: Int)
        case bar(string: String)
             ┬──
             ╰─ 🛑 '@MetaEnum' cannot be applied to enums with overloaded case names.
      }
      """
    }
  }

  func testOverloadedCaseName_SingleLine() {
    assertMacro {
      """
      @MetaEnum enum Foo {
        case bar(int: Int), bar(string: String)
      }
      """
    } matches: {
      """
      @MetaEnum enum Foo {
        case bar(int: Int), bar(string: String)
                            ┬──
                            ╰─ 🛑 '@MetaEnum' cannot be applied to enums with overloaded case names.
      }
      """
    }
  }
}
