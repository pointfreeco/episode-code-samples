import SwiftCompilerPlugin
import SwiftSyntaxMacros

@main
struct MacrosPlugin: CompilerPlugin {
  let providingMacros: [Macro.Type] = [
    ReducerMacro.self,
    ObservableStateMacro.self,
    ObservationStateTrackedMacro.self,
    ObservationStateIgnoredMacro.self,
  ]
}
