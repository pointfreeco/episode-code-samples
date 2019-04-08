import SwiftSyntax
import Foundation

let url = Bundle.main.url(forResource: "Enums", withExtension: "swift")!

let tree = try SyntaxTreeParser.parse(url)

// extension Validated {
//   var valid: Valid? {
//     guard case let .valid(value) = self else { return nil }
//     return value
//   }
//   var invalid: [Invalid?] {
//     guard case let .valid(value) = self else { return nil }
//     return value
//   }
// }

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
    print("  var \(node.identifier): \(node.associatedValue!.parameterList)? {")
    print("    guard case let .\(node.identifier)(value) = self else { return nil }")
    print("    return value")
    print("  }")
    return .skipChildren
  }
}

let visitor = Visitor()
tree.walk(visitor)

enum Validated<Valid, Invalid> {
  case valid(Valid)
  case invalid([Invalid])
}

extension Validated {
  var valid: Valid? {
    guard case let .valid(value) = self else { return nil }
    return value
  }
  var invalid: [Invalid]? {
    guard case let .invalid(value) = self else { return nil }
    return value
  }
}

let validatedValues: [Validated<Int, String>] = [
  .valid(1),
  .invalid(["Failed to calculate value"]),
  .valid(42),
]

validatedValues
  .compactMap { $0.valid }

validatedValues
  .compactMap { $0.invalid }
