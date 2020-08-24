import XCTest
@testable import LocationClient

final class LocationClientTests: XCTestCase {
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.
        XCTAssertEqual(LocationClient().text, "Hello, World!")
    }

    static var allTests = [
        ("testExample", testExample),
    ]
}
