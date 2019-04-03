import SwiftSyntax
import Foundation

let url = Bundle.main.url(forResource: "Enums", withExtension: "swift")!

let tree = try SyntaxTreeParser.parse(url)

class Visitor: SyntaxVisitor {
  override func visit(_ node: EnumDeclSyntax) -> SyntaxVisitorContinueKind {
    print("extension \(node.identifier.withoutTrivia()) {")
    return .visitChildren
  }

  override func visitPost(_ node: Syntax) {
    if node is EnumDeclSyntax {
      print("}")
    }
  }

  override func visit(_ node: EnumCaseElementSyntax) -> SyntaxVisitorContinueKind {
    let propertyType: String
    let pattern: String
    let returnString: String
    if let associatedValue = node.associatedValue {
      propertyType = associatedValue.parameterList.count == 1
      ? "\(associatedValue.parameterList[0].type!)"
      : "(\(associatedValue.parameterList))"
      pattern = "guard case let .\(node.identifier)(value)"
      returnString = "value"
    } else {
      propertyType = "Void"
      pattern = "guard case .\(node.identifier)"
      returnString = "()"
    }

    print("  var \(node.identifier): \(propertyType)? {")
    print("    \(pattern) = self else { return nil }")
    print("    return \(returnString)")
    print("  }")
//    let capitalizedIdentifier = "\(node.identifier)".capitalized
    let identifier = "\(node.identifier)"
    let capitalizedIdentifier = "\(identifier.first!.uppercased())\(identifier.dropFirst())"
    print("  var is\(capitalizedIdentifier): Bool {")
    print("    return self.\(node.identifier) != nil")
    print("  }")
    return .skipChildren
  }
}

let visitor = Visitor()

tree.walk(visitor)

enum Fetched<A> {
  case cancelled
  case data(A)
  case failed
  case loading
}

extension Fetched {
  var cancelled: Void? {
    guard case .cancelled = self else { return nil }
    return ()
  }
  var isCancelled: Bool {
    return self.cancelled != nil
  }
  var data: A? {
    guard case let .data(value) = self else { return nil }
    return value
  }
  var isData: Bool {
    return self.data != nil
  }
  var failed: Void? {
    guard case .failed = self else { return nil }
    return ()
  }
  var isFailed: Bool {
    return self.failed != nil
  }
  var loading: Void? {
    guard case .loading = self else { return nil }
    return ()
  }
  var isLoading: Bool {
    return self.loading != nil
  }
}


let data = Fetched<Int>.data(42)

data.loading
data.cancelled
data.data

let requests: [Fetched<String>] = [
  .cancelled,
  .data("Blob's Travel Blog"),
  .failed,
  .loading,
  .data("Blob's Food Blog"),
  .loading,
]

requests
  .compactMap { $0.data }
requests
  .filter { $0.isFailed }
//  .filter { $0.failed != nil }
  .count

//data == .failed

