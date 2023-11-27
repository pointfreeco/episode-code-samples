import SwiftSyntax
import SwiftSyntaxMacros

public enum CasePathableMacro: MemberMacro {
  public static func expansion<D: DeclGroupSyntax>(
    of node: AttributeSyntax,
    providingMembersOf declaration: D,
    in context: some MacroExpansionContext
  ) throws -> [DeclSyntax] {
    let elements = declaration.memberBlock.members
      .flatMap { $0.decl.as(EnumCaseDeclSyntax.self)?.elements ?? [] }

    let rootTypeName = declaration.as(EnumDeclSyntax.self)!.name.text

    let casePathProperties = elements.map { element in
      let valueType = element.parameterClause!.parameters.first!.type
      return """
      var \(element.name): CasePath<\(rootTypeName), \(valueType)> {
        CasePath(
          embed: \(rootTypeName).\(element.name),
          extract: {
            guard case let .\(element.name)(value) = $0
            else { return nil }
            return value
          }
        )
      }
      """
    }

    return [
      """
      struct Cases {
      \(raw: casePathProperties.joined(separator: "\n"))
      }
      static let cases = Cases()
      """
    ]
  }
}

extension CasePathableMacro: ExtensionMacro {
  public static func expansion(
    of node: SwiftSyntax.AttributeSyntax,
    attachedTo declaration: some SwiftSyntax.DeclGroupSyntax,
    providingExtensionsOf type: some SwiftSyntax.TypeSyntaxProtocol,
    conformingTo protocols: [SwiftSyntax.TypeSyntax],
    in context: some SwiftSyntaxMacros.MacroExpansionContext
  ) throws -> [SwiftSyntax.ExtensionDeclSyntax] {
    [
      try! ExtensionDeclSyntax(
        """
        extension \(type): CasePathable {}
        """
      )
    ]
  }
}
