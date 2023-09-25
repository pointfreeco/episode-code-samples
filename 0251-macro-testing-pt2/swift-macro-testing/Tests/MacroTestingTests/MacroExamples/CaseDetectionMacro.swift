import SwiftSyntax
import SwiftSyntaxMacros

extension TokenSyntax {
  fileprivate var initialUppercased: String {
    let name = self.text
    guard let initial = name.first else {
      return name
    }

    return "\(initial.uppercased())\(name.dropFirst())"
  }
}

public struct CaseDetectionMacro: MemberMacro {
  public static func expansion<
    Declaration: DeclGroupSyntax, Context: MacroExpansionContext
  >(
    of node: AttributeSyntax,
    providingMembersOf declaration: Declaration,
    in context: Context
  ) throws -> [DeclSyntax] {
    declaration.memberBlock.members
      .compactMap { $0.decl.as(EnumCaseDeclSyntax.self) }
      .map { $0.elements.first!.name }
      .map { ($0, $0.initialUppercased) }
      .map { original, uppercased in
        """
        var is\(raw: uppercased): Bool {
          if case .\(raw: original) = self {
            return true
          }

          return false
        }
        """
      }
  }
}
