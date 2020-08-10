import XCTest

#if !canImport(ObjectiveC)
public func allTests() -> [XCTestCaseEntry] {
    return [
        testCase(PathMonitorClientTests.allTests),
    ]
}
#endif
