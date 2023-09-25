public struct UnkeyedCodableMacro: MemberMacro {
    enum Error: String, Swift.Error, DiagnosticMessage {
        var diagnosticID: MessageID { .init(domain: "UnkeyedCodableMacro", id: rawValue) }
        var severity: DiagnosticSeverity { .error }
        var message: String {
            switch self {
            case .notAStruct: return "@UnkeyedCodable can only be applied to structs"
            }
        }

        case notAStruct
    }

    struct InferenceDiagnostic: DiagnosticMessage {
        let diagnosticID = MessageID(domain: "UnkeyedCodableMacro", id: "inference")
        let severity: DiagnosticSeverity = .error
        let message: String = "@UnkeyedCodable requires stored properties provide explicit type annotations"
    }

    static func properties<Context: MacroExpansionContext>(_ structDecl: StructDeclSyntax, _ context: Context) -> [VariableDeclSyntax] {
        var included: [VariableDeclSyntax] = []

        for property in structDecl.storedProperties {
            if property.type != nil {
                included.append(property)
            } else {
                context.diagnose(.init(node: property._syntaxNode, message: InferenceDiagnostic()))
            }
        }

        return included
    }

    public static func expansion<Declaration: DeclGroupSyntax, Context: MacroExpansionContext>(
        of node: AttributeSyntax,
        providingMembersOf declaration: Declaration,
        in context: Context
    ) throws -> [DeclSyntax] {
        let decoder = try UnkeyedDecodableMacro.expansion(of: node, providingMembersOf: declaration, in: context)
        let encoder = try UnkeyedEncodableMacro.expansion(of: node, providingMembersOf: declaration, in: context)
        return [decoder, encoder].flatMap { $0 }
    }
}

public struct UnkeyedDecodableMacro: MemberMacro {
    public static func expansion<Declaration: DeclGroupSyntax, Context: MacroExpansionContext>(
        of node: AttributeSyntax,
        providingMembersOf declaration: Declaration,
        in context: Context
    ) throws -> [DeclSyntax] {
        guard let structDecl = declaration.as(StructDeclSyntax.self) else { throw UnkeyedCodableMacro.Error.notAStruct }

        let included = UnkeyedCodableMacro.properties(structDecl, context)
        guard !included.isEmpty else { return [] }

        let decoder: DeclSyntax = """
        \(raw: structDecl.accessLevel) init(from decoder: Decoder) throws {
        var container = try decoder.unkeyedContainer()
        \(raw: included.map({ "self.\($0.identifier.trimmed.text) = try container.decode(\($0.type!.type.trimmed).self)" }).joined(separator: "\n"))
        }
        """

        return [decoder]
    }
}

public struct UnkeyedEncodableMacro: MemberMacro {
    public static func expansion<Declaration: DeclGroupSyntax, Context: MacroExpansionContext>(
        of node: AttributeSyntax,
        providingMembersOf declaration: Declaration,
        in context: Context
    ) throws -> [DeclSyntax] {
        guard let structDecl = declaration.as(StructDeclSyntax.self) else { throw UnkeyedCodableMacro.Error.notAStruct }

        let included = UnkeyedCodableMacro.properties(structDecl, context)
        guard !included.isEmpty else { return [] }

        let encoder: DeclSyntax = """
        \(raw: structDecl.accessLevel) func encode(to encoder: Encoder) throws {
        var container = encoder.unkeyedContainer()
        \(raw: included.map({ "try container.encode(self.\($0.identifier.trimmed.text))" }).joined(separator: "\n"))
        }
        """

        return [encoder]
    }
}
