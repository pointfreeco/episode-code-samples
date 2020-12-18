import XCTest

import string_performanceTests

var tests = [XCTestCaseEntry]()
tests += string_performanceTests.allTests()
XCTMain(tests)
