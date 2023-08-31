@_exported import SwiftCompilerPlugin
@_exported import SwiftDiagnostics
@_exported import SwiftSyntax
@_exported import SwiftSyntaxBuilder
@_exported import SwiftSyntaxMacros

@main
struct MacroKitPlugin: CompilerPlugin {
    let providingMacros: [Macro.Type] = [
        PublicInitMacro.self,
        KeyPathIterableMacro.self,
        StaticMemberIterableMacro.self,
        GenerateMockMacro.self,
        DefaultMacro.self,
        UnkeyedCodableMacro.self,
        UnkeyedDecodableMacro.self,
        UnkeyedEncodableMacro.self,
    ]
}
