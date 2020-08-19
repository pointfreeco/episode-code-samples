import XCTest

#if !canImport(ObjectiveC)
public func allTests() -> [XCTestCaseEntry] {
    return [
        testCase(pretty_test_logsTests.allTests),
    ]
}
#endif
