import MacroTesting
import XCTest

final class OptionSetMacroTests: BaseTestCase {
  override func invokeTest() {
    withMacroTesting(macros: ["MyOptionSet": OptionSetMacro.self]) {
      super.invokeTest()
    }
  }

  func testOptionSet() {
    assertMacro {
      """
      @MyOptionSet<UInt8>
      struct ShippingOptions {
        private enum Options: Int {
          case nextDay
          case secondDay
          case priority
          case standard
        }

        static let express: ShippingOptions = [.nextDay, .secondDay]
        static let all: ShippingOptions = [.express, .priority, .standard]
      }
      """
    } matches: {
      """
      struct ShippingOptions {
        private enum Options: Int {
          case nextDay
          case secondDay
          case priority
          case standard
        }

        static let express: ShippingOptions = [.nextDay, .secondDay]
        static let all: ShippingOptions = [.express, .priority, .standard]

        typealias RawValue = UInt8

        var rawValue: RawValue

        init() {
          self.rawValue = 0
        }

        init(rawValue: RawValue) {
          self.rawValue = rawValue
        }

        static let nextDay: Self =
          Self (rawValue: 1 << Options.nextDay.rawValue)

        static let secondDay: Self =
          Self (rawValue: 1 << Options.secondDay.rawValue)

        static let priority: Self =
          Self (rawValue: 1 << Options.priority.rawValue)

        static let standard: Self =
          Self (rawValue: 1 << Options.standard.rawValue)
      }

      extension ShippingOptions: OptionSet {
      }
      """
    }
  }
}
