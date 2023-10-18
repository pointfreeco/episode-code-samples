import CasePathsMacros
import MacroTesting
import XCTest

final class CasePathableMacroTests: XCTestCase {
  override func invokeTest() {
    withMacroTesting(
      //isRecording: true,
      macros: [CasePathableMacro.self]
    ) {
      super.invokeTest()
    }
  }

  func testBasics() {
    assertMacro {
      """
      @CasePathable
      enum Action {
        case feature1(Feature1.Action)
        case feature2(Feature2.Action)
      }
      """
    } expansion: {
      """
      enum Action {
        case feature1(Feature1.Action)
        case feature2(Feature2.Action)

        struct Cases {
          var feature1: CasePath<Action, Feature1.Action> {
            CasePath(
              embed: Action.feature1,
              extract: {
                guard case let .feature1(value) = $0
                else {
                  return nil
                }
                return value
              }
            )
          }
          var feature2: CasePath<Action, Feature2.Action> {
            CasePath(
              embed: Action.feature2,
              extract: {
                guard case let .feature2(value) = $0
                else {
                  return nil
                }
                return value
              }
            )
          }
        }
        static let cases = Cases()
      }

      extension Action: CasePathable {
      }
      """
    }
  }
}

import CasePaths

@CasePathable
enum Action {
  case feature1(Int)
  case feature2(String)
}
