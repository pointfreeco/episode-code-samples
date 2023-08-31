import SwiftDiagnostics
import SwiftSyntax
import SwiftSyntaxMacros
import SwiftSyntaxBuilder

public struct MetaEnumMacro {
  let parentTypeName: TokenSyntax
  let childCases: [EnumCaseElementSyntax]
  let access: DeclModifierListSyntax.Element?
  let parentParamName: TokenSyntax

  init(node: AttributeSyntax, declaration: some DeclGroupSyntax, context: some MacroExpansionContext) throws {
    guard let enumDecl = declaration.as(EnumDeclSyntax.self) else {

      if let structDecl = declaration.as(StructDeclSyntax.self) {
        throw DiagnosticsError(diagnostics: [
          CaseMacroDiagnostic.notAnEnum(declaration).diagnose(at: Syntax(structDecl.structKeyword))
        ])
      }
      if let classDecl = declaration.as(ClassDeclSyntax.self) {
        throw DiagnosticsError(diagnostics: [
          CaseMacroDiagnostic.notAnEnum(declaration).diagnose(at: Syntax(classDecl.classKeyword))
        ])
      }
      if let actorDecl = declaration.as(ActorDeclSyntax.self) {
        throw DiagnosticsError(diagnostics: [
          CaseMacroDiagnostic.notAnEnum(declaration).diagnose(at: Syntax(actorDecl.actorKeyword))
        ])
      }
      throw DiagnosticsError(diagnostics: [
        CaseMacroDiagnostic.notAnEnum(declaration).diagnose(at: Syntax(node))
      ])
    }

    let enumCaseDecls = enumDecl.memberBlock.members
      .compactMap { $0.decl.as(EnumCaseDeclSyntax.self) }
      .flatMap(\.elements)
    var seenCaseNames: Set<String> = []
    for enumCaseDecl in enumCaseDecls {
      let name = enumCaseDecl.name.text
      defer { seenCaseNames.insert(name) }
      if seenCaseNames.contains(name) {
        throw DiagnosticsError(diagnostics: [
          CaseMacroDiagnostic.overloadedCase.diagnose(at: Syntax(enumCaseDecl.name))
        ])
      }
    }

    parentTypeName = enumDecl.name.with(\.trailingTrivia, [])

    access = enumDecl.modifiers.first(where: \.isNeededAccessLevelModifier)

    childCases = enumDecl.caseElements.map { parentCase in
      parentCase.with(\.parameterClause, nil)
    }

    parentParamName = context.makeUniqueName("parent")
  }

  func makeMetaEnum() -> DeclSyntax {
    // FIXME: Why does this need to be a string to make trailing trivia work properly?
    let caseDecls = childCases.map { childCase in
      "case \(childCase.name)"
    }.joined(separator: "\n")

    return """
      \(access)enum Meta {
      \(raw: caseDecls)
      \(makeMetaInit())
      }
      """
  }

  func makeMetaInit() -> DeclSyntax {
    let caseStatements = childCases.map { childCase in
      """
      case .\(childCase.name):
      self = .\(childCase.name)
      """
    }.joined(separator: "\n")

    return """
      \(access)init(_ \(parentParamName): \(parentTypeName)) {
      switch \(parentParamName) {
      \(raw: caseStatements)
      }
      }
      """
  }
}

struct OverloadedCaseError: Error {}

extension MetaEnumMacro: MemberMacro {
  public static func expansion(
    of node: AttributeSyntax,
    providingMembersOf declaration: some DeclGroupSyntax,
    in context: some MacroExpansionContext
  ) throws -> [DeclSyntax] {
    let macro = try MetaEnumMacro(node: node, declaration: declaration, context: context)

    return [ macro.makeMetaEnum() ]
  }
}

extension EnumDeclSyntax {
  var caseElements: [EnumCaseElementSyntax] {
    memberBlock.members.flatMap { member in
      guard let caseDecl = member.decl.as(EnumCaseDeclSyntax.self) else {
        return Array<EnumCaseElementSyntax>()
      }

      return Array(caseDecl.elements)
    }
  }
}

enum CaseMacroDiagnostic {
  case overloadedCase
  case notAnEnum(DeclGroupSyntax)
}

extension CaseMacroDiagnostic: DiagnosticMessage {
  var message: String {
    switch self {
    case .overloadedCase:
      return "'@MetaEnum' cannot be applied to enums with overloaded case names."
    case .notAnEnum(let decl):
      return "'@MetaEnum' can only be attached to an enum, not \(decl.descriptiveDeclKind(withArticle: true))"
    }
  }

  var diagnosticID: MessageID {
    switch self {
    case .overloadedCase:
      return MessageID(domain: "MetaEnumDiagnostic", id: "overloadedCase")
    case .notAnEnum:
      return MessageID(domain: "MetaEnumDiagnostic", id: "notAnEnum")
    }
  }

  var severity: DiagnosticSeverity {
    switch self {
    case .notAnEnum, .overloadedCase:
      return .error
    }
  }

  func diagnose(at node: Syntax) -> Diagnostic {
    Diagnostic(node: node, message: self)
  }
}

extension DeclGroupSyntax {
  func descriptiveDeclKind(withArticle article: Bool = false) -> String {
    switch self {
    case is ActorDeclSyntax:
      return article ? "an actor" : "actor"
    case is ClassDeclSyntax:
      return article ? "a class" : "class"
    case is ExtensionDeclSyntax:
      return article ? "an extension" : "extension"
    case is ProtocolDeclSyntax:
      return article ? "a protocol" : "protocol"
    case is StructDeclSyntax:
      return article ? "a struct" : "struct"
    case is EnumDeclSyntax:
      return article ? "an enum" : "enum"
    default:
      fatalError("Unknown DeclGroupSyntax")
    }
  }
}

