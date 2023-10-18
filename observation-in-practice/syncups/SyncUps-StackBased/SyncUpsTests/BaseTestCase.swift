import ConcurrencyExtras
import XCTest

class BaseTestCase: XCTestCase {
  override func invokeTest() {
    withMainSerialExecutor {
      super.invokeTest()
    }
  }
}
