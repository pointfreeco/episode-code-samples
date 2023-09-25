import SwiftSyntax
import SwiftSyntaxMacros

public struct DictionaryStorageMacro { }

extension DictionaryStorageMacro: AccessorMacro {
  public static func expansion<
    Context: MacroExpansionContext,
    Declaration: DeclSyntaxProtocol
  >(
    of node: AttributeSyntax,
    providingAccessorsOf declaration: Declaration,
    in context: Context
  ) throws -> [AccessorDeclSyntax] {
    guard let varDecl = declaration.as(VariableDeclSyntax.self),
      let binding = varDecl.bindings.first,
      let identifier = binding.pattern.as(IdentifierPatternSyntax.self)?.identifier,
      binding.accessorBlock == nil,
      let type = binding.typeAnnotation?.type
    else {
      return []
    }

    // Ignore the "_storage" variable.
    if identifier.text == "_storage" {
      return []
    }

    guard let defaultValue = binding.initializer?.value else {
      throw CustomError.message("stored property must have an initializer")
    }

    return [
      """
      get {
      _storage[\(literal: identifier.text), default: \(defaultValue)] as! \(type)
      }
      """,
      """
      set {
      _storage[\(literal: identifier.text)] = newValue
      }
      """,
    ]
  }
}

extension DictionaryStorageMacro: MemberMacro {
  public static func expansion(
    of node: AttributeSyntax,
    providingMembersOf declaration: some DeclGroupSyntax,
    in context: some MacroExpansionContext
  ) throws -> [DeclSyntax] {
    let storage: DeclSyntax = "var _storage: [String: Any] = [:]"
    return [
      storage.with(\.leadingTrivia, [.newlines(1), .spaces(2)])
    ]
  }
}

extension DictionaryStorageMacro: MemberAttributeMacro {
  public static func expansion(
    of node: AttributeSyntax, attachedTo declaration: some DeclGroupSyntax,
    providingAttributesFor member: some DeclSyntaxProtocol,
    in context: some MacroExpansionContext
  ) throws -> [AttributeSyntax] {
    guard let property = member.as(VariableDeclSyntax.self),
          property.isStoredProperty
    else {
      return []
    }

    return [
      AttributeSyntax(
        attributeName: IdentifierTypeSyntax(
          name: .identifier("DictionaryStorage")
        )
      )
      .with(\.leadingTrivia, [.newlines(1), .spaces(2)])
    ]
  }
}
