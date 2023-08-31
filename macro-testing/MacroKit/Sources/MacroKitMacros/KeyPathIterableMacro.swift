public struct KeyPathIterableMacro: MemberMacro {
    public static func expansion<Declaration: DeclGroupSyntax, Context: MacroExpansionContext>(
        of node: AttributeSyntax,
        providingMembersOf declaration: Declaration,
        in context: Context
    ) throws -> [DeclSyntax] {
        let properties = declaration.properties.filter { $0.accessLevel >= declaration.declAccessLevel }

        guard let identifier = declaration.identifier, !properties.isEmpty else { return [] }

        let typeName = identifier.text

        let allKeyPaths: DeclSyntax = """
        \(raw: declaration.declAccessLevel) static var allKeyPaths: [PartialKeyPath<\(raw: typeName)>] {
            return [\(raw: properties.map({ "\\\(typeName).\($0.identifier.text)" }).joined(separator: ","))]
        }
        """

        return [allKeyPaths]
    }
}
