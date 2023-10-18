import SwiftSyntax
import SwiftSyntaxMacros

public enum CasePathableMacro: MemberMacro {
  public static func expansion(
    of node: AttributeSyntax,
    providingMembersOf declaration: some DeclGroupSyntax,
    in context: some MacroExpansionContext
  ) throws -> [DeclSyntax] {
    [
      """
      struct Cases {
      }
      static let cases = Cases()
      """
    ]
  }
}
