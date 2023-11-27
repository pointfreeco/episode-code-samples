#if DEBUG && (os(iOS) || os(macOS) || os(tvOS) || os(watchOS))
  @_spi(Internals) import CasePaths
  import XCTest

  final class XCTModifyTests: XCTestCase {
    func testXCTModifyFailure() throws {
      try XCTSkipIf(ProcessInfo.processInfo.environment["CI"] != nil)

      XCTExpectFailure {
        $0.compactDescription == """
          XCTModify failed: expected to extract value of type "Int" from "Result<Int, Error>" …

            Actual:
              failure(CasePathsTests.SomeError())
          """
      }

      var result = Result<Int, Error>.failure(SomeError())
      XCTModify(&result, case: /Result.success) {
        $0 += 1
      }
    }

    func testXCTModifyFailure_OptionalPromotion() throws {
      try XCTSkipIf(ProcessInfo.processInfo.environment["CI"] != nil)

      XCTExpectFailure {
        $0.compactDescription == """
          XCTModify failed: expected to extract value of type "Sheet.State" from \
          "Destination.State?" …

            Actual:
              Optional(CasePathsTests.Destination.State.alert)
          """
      }

      var result = Optional(Destination.State.alert)
      XCTModify(&result, case: /Destination.State.sheet) {
        $0.count += 1
      }
    }

    func testXCTModifyFailure_Nil_OptionalPromotion() throws {
      try XCTSkipIf(ProcessInfo.processInfo.environment["CI"] != nil)

      XCTExpectFailure {
        $0.compactDescription == """
          XCTModify failed: expected to extract value of type "Int" from \
          "Optional<Result<Int, Error>>" …

            Actual:
              nil
          """
      }

      var result = Optional<Result<Int, Error>>.none
      XCTModify(&result, case: /Result.success) {
        $0 += 1
      }
    }

    func testXCTModifyFailure_WithMessage() throws {
      try XCTSkipIf(ProcessInfo.processInfo.environment["CI"] != nil)

      XCTExpectFailure {
        $0.compactDescription == """
          XCTModify failed: expected to extract value of type "Int" from "Result<Int, Error>" - \
          Should be success …

            Actual:
              failure(CasePathsTests.SomeError())
          """
      }

      var result = Result<Int, Error>.failure(SomeError())
      XCTModify(&result, case: /Result.success, "Should be success") {
        $0 += 1
      }
    }

    func testXCTModifyPass() throws {
      try XCTSkipIf(ProcessInfo.processInfo.environment["CI"] != nil)

      var result = Result<Int, SomeError>.success(2)
      XCTModify(&result, case: /Result.success) {
        $0 += 1
      }
      XCTAssertEqual(result, .success(3))
    }

    func testXCTModifyPass_OptionalPromotion() throws {
      try XCTSkipIf(ProcessInfo.processInfo.environment["CI"] != nil)

      var result = Optional(Result<Int, SomeError>.success(2))
      XCTModify(&result, case: /Result.success) {
        $0 += 1
      }
      XCTAssertEqual(result, .success(3))
    }

    func testXCTModifyFailUnchangedEquatable() throws {
      try XCTSkipIf(ProcessInfo.processInfo.environment["CI"] != nil)

      XCTExpectFailure {
        $0.compactDescription == """
          XCTModify failed: expected "Int" value to be modified but it was unchanged.
          """
      }

      var result = Result<Int, SomeError>.success(2)
      XCTModify(&result, case: /Result.success) {
        _ = $0
      }
      XCTAssertEqual(result, .success(2))
    }

    func testXCTModify_BodyThrowsError() throws {
      try XCTSkipIf(ProcessInfo.processInfo.environment["CI"] != nil)

      XCTExpectFailure {
        $0.compactDescription == """
          Threw error: SomeError()
          """
      }

      var result = Result<Int, SomeError>.success(2)
      XCTModify(&result, case: /Result.success) { _ in
        throw SomeError()
      }
      XCTAssertEqual(result, .success(2))
    }

    func testXCTModifyFailUnchangedEquatable_NonExhaustive() throws {
      try XCTSkipIf(ProcessInfo.processInfo.environment["CI"] != nil)

      var result = Result<Int, SomeError>.success(2)
      XCTModifyLocals.$isExhaustive.withValue(false) {
        XCTModify(&result, case: /Result.success) {
          _ = $0
        }
      }
      XCTAssertEqual(result, .success(2))
    }
  }

  struct SomeError: Error, Equatable {}

  struct Sheet {
    struct State {
      var count = 0
    }
  }
  struct Destination {
    enum State {
      case alert
      case sheet(Sheet.State)
    }
  }
#endif
