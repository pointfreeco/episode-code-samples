import XCTest

import stdinTests

var tests = [XCTestCaseEntry]()
tests += stdinTests.allTests()
XCTMain(tests)
