public struct StaticMemberIterableMacro: MemberMacro {
    public static func expansion<Declaration: DeclGroupSyntax, Context: MacroExpansionContext>(
        of node: AttributeSyntax,
        providingMembersOf declaration: Declaration,
        in context: Context
    ) throws -> [DeclSyntax] {
        let properties = declaration.properties
            .filter { $0.accessLevel >= declaration.declAccessLevel && $0.isStatic }

        guard !properties.isEmpty else { return [] }

        let allStaticMembers: DeclSyntax = """
        \(raw: declaration.declAccessLevel) static var allStaticMembers = [\(raw: properties.map(\.identifier.text).joined(separator: ", "))]
        """

        return [allStaticMembers]
    }
}
