import SwiftSyntax
import Foundation

let tree = try SyntaxTreeParser.parse(Bundle.main.url(forResource: "Validated", withExtension: "swift")!)

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
  override func visit(_ node: EnumDeclSyntax) {
    print("extension \(node.identifier) {")
    super.visit(node)
    print("}")
  }

  override func visit(_ node: EnumCaseDeclSyntax) {
    node.elements.forEach {
      print("  var \($0.identifier): \($0.associatedValue!.parameterList[0])? {")
      print("    guard case let .\($0.identifier)(value) = self else { return nil }")
      print("    return value")
      print("  }")
    }
  }
}

Visitor().visit(tree)
