import SwiftCompilerPlugin
import SwiftSyntaxMacros

@main
struct CasePathsMacrosPlugin: CompilerPlugin {
  let providingMacros: [SwiftSyntaxMacros.Macro.Type] = [
    CasePathableMacro.self,
  ]
}
