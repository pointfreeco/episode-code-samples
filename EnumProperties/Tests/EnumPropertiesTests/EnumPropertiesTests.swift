import XCTest
@testable import EnumProperties

final class EnumPropertiesTests: XCTestCase {
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.
        XCTAssertEqual(EnumProperties().text, "Hello, World!")
    }

    static var allTests = [
        ("testExample", testExample),
    ]
}
