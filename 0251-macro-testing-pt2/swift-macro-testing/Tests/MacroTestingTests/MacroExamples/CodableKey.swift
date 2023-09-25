import SwiftSyntax
import SwiftSyntaxMacros

public struct CodableKey: MemberMacro {
  public static func expansion(
    of node: AttributeSyntax,
    providingMembersOf declaration: some DeclGroupSyntax,
    in context: some MacroExpansionContext
  ) throws -> [DeclSyntax] {
      // Does nothing, used only to decorate members with data
      return []
  }


}
