import SwiftSyntax

public class Visitor: SyntaxVisitor {
  public private(set) var output: String = ""

  override public func visit(_ node: EnumDeclSyntax) -> SyntaxVisitorContinueKind {
    print(
      "extension \(node.identifier.withoutTrivia()) {",
      to: &self.output
    )

//    print(<#T##items: Any...##Any#>, to: &TextOutputStream)
    return .visitChildren
  }

  override public func visitPost(_ node: Syntax) {
    if node is EnumDeclSyntax {
      print("}", to: &self.output)
    }
  }

  override public func visit(_ node: EnumCaseElementSyntax) -> SyntaxVisitorContinueKind {
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

    print("  var \(node.identifier): \(propertyType)? {", to: &self.output)
    print("    \(pattern) = self else { return nil }", to: &self.output)
    print("    return \(returnString)", to: &self.output)
    print("  }", to: &self.output)
    let identifier = "\(node.identifier)"
    let capitalizedIdentifier = "\(identifier.first!.uppercased())\(identifier.dropFirst())"
    print("  var is\(capitalizedIdentifier): Bool {", to: &self.output)
    print("    return self.\(node.identifier) != nil", to: &self.output)
    print("  }", to: &self.output)
    return .skipChildren
  }
}
