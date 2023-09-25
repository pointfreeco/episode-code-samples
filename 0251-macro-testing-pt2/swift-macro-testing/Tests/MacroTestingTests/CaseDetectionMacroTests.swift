import MacroTesting
import XCTest

final class CaseDetectionMacroTests: BaseTestCase {
  override func invokeTest() {
    withMacroTesting(macros: [CaseDetectionMacro.self]) {
      super.invokeTest()
    }
  }

  func testCaseDetection() {
    assertMacro {
      #"""
      @CaseDetection
      enum Pet {
        case dog
        case cat(curious: Bool)
        case parrot
        case snake
      }
      """#
    } matches: {
      """
      enum Pet {
        case dog
        case cat(curious: Bool)
        case parrot
        case snake

        var isDog: Bool {
          if case .dog = self {
            return true
          }

          return false
        }

        var isCat: Bool {
          if case .cat = self {
            return true
          }

          return false
        }

        var isParrot: Bool {
          if case .parrot = self {
            return true
          }

          return false
        }

        var isSnake: Bool {
          if case .snake = self {
            return true
          }

          return false
        }
      }
      """
    }
  }
}
