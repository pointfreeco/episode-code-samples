import Foundation
import SnapshotTesting
import SwiftSyntax
import XCTest
@testable import EnumProperties

extension Snapshotting where Value == URL, Format == String {
//  static let visitor: Snapshotting = Snapshotting<String, String>.lines.pullback { url in
//    let tree = try SyntaxTreeParser.parse(url)
//    let visitor = Visitor()
//    tree.walk(visitor)
//    return visitor.output
//  }
  static let enumProperties: Snapshotting = {
    var snapshotting: Snapshotting = Snapshotting<String, String>.lines.pullback { url -> String in
      let tree = try! SyntaxTreeParser.parse(url)
      let visitor = Visitor()
      tree.walk(visitor)
      return visitor.output
    }
    snapshotting.pathExtension = "swift"
    return snapshotting
  }()
}

final class EnumPropertiesTests: XCTestCase {
  func testExample() throws {
    let url = URL(fileURLWithPath: String(#file))
      .deletingLastPathComponent()
      .appendingPathComponent("Fixtures")
      .appendingPathComponent("Enums.swift")
//    record=true
    assertSnapshot(matching: url, as: .enumProperties)
//    XCTAssertEqual("""
//extension Validated {
//  var valid: Valid? {
//    guard case let .valid(value) = self else { return nil }
//    return value
//  }
//  var isValid: Bool {
//    return self.valid != nil
//  }
//  var invalid: [Invalid]? {
//    guard case let .invalid(value) = self else { return nil }
//    return value
//  }
//  var isInvalid: Bool {
//    return self.invalid != nil
//  }
//}
//extension Node {
//  var element: (tag: String, attributes: [String: String], children: [Node])? {
//    guard case let .element(value) = self else { return nil }
//    return value
//  }
//  var isElement: Bool {
//    return self.element != nil
//  }
//  var text: String? {
//    guard case let .text(value) = self else { return nil }
//    return value
//  }
//  var isText: Bool {
//    return self.text != nil
//  }
//}
//extension Loading {
//  var loading: Void? {
//    guard case .loading = self else { return nil }
//    return ()
//  }
//  var isLoading: Bool {
//    return self.loading != nil
//  }
//  var loaded: A? {
//    guard case let .loaded(value) = self else { return nil }
//    return value
//  }
//  var isLoaded: Bool {
//    return self.loaded != nil
//  }
//  var cancelled: Void? {
//    guard case .cancelled = self else { return nil }
//    return ()
//  }
//  var isCancelled: Bool {
//    return self.cancelled != nil
//  }
//}
//""", visitor.output)
  }

  static var allTests = [
    ("testExample", testExample),
  ]
}
