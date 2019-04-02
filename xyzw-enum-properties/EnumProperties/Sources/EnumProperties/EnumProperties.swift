import SwiftSyntax

public class Visitor: SyntaxVisitor {
  public private(set) var output = ""
  private var cases: [
    (
    identifier: String,
    label: String,
    propertyType: String,
    pattern: String,
    returnValue: String
    )
    ] = []

  override public func visitPost(_ node: Syntax) {
    if node is EnumDeclSyntax {
      print("  func fold<A>(", to: &self.output)
      print(
        cases.map { "    \($0.label): \($0.propertyType) -> A" }.joined(separator: ",\n"),
        to: &self.output
      )
      print("  ) -> A {", to: &self.output)
      print("    switch self {", to: &self.output)
      cases.forEach {
        print("    \($0.pattern):", to: &self.output)
        print("      return \($0.label)\($0.returnValue)", to: &self.output)
      }
      print("    }", to: &self.output)
      print("  }", to: &self.output)
      print("}", to: &self.output)
      self.cases.removeAll()
    }
  }

  override public func visit(_ node: EnumDeclSyntax) -> SyntaxVisitorContinueKind {
    print("extension \(node.identifier.withoutTrivia()) {", to: &self.output)
    return .visitChildren
  }

  override public func visit(_ node: EnumCaseElementSyntax) -> SyntaxVisitorContinueKind {
    let propertyType: String
    let pattern: String
    let returnValue: String
    if let associatedValue = node.associatedValue {
      propertyType = associatedValue.parameterList.count == 1
        ? "\(associatedValue.parameterList[0].type!)"
        : "\(associatedValue)"
      pattern = "let .\(node.identifier)(value)"
      returnValue = "value"
    } else {
      propertyType = "Void"
      pattern = ".\(node.identifier)"
      returnValue = "()"
    }
    print("  var \(node.identifier): \(propertyType)? {", to: &self.output)
    print("    guard case \(pattern) = self else { return nil }", to: &self.output)
    print("    return \(returnValue)", to: &self.output)
    print("  }", to: &self.output)
    let identifier = "\(node.identifier)"
    let capitalizedIdentifier = "\(identifier.first!.uppercased())\(identifier.dropFirst())"
    print("  var is\(capitalizedIdentifier): Bool {", to: &self.output)
    print("    return self.\(node.identifier) != nil", to: &self.output)
    print("  }", to: &self.output)
    self.cases.append(
      (
        identifier,
        "if\(capitalizedIdentifier)",
        propertyType,
        pattern,
        returnValue == "()" ? returnValue : "(\(returnValue))"
      )
    )
    return .skipChildren
  }
}
