import SwiftCompilerPlugin
import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftSyntaxMacros

/// Implementation of the `stringify` macro, which takes an expression
/// of any type and produces a tuple containing the value of that expression
/// and the source code that produced the value. For example
///
///     #stringify(x + y)
///
///  will expand to
///
///     (x + y, "x + y")
public struct StringifyMacro: ExpressionMacro {
  public static func expansion<F: FreestandingMacroExpansionSyntax, C: MacroExpansionContext>(
    of node: F,
    in context: C
  ) throws -> ExprSyntax {
    guard let argument = node.argumentList.first?.expression else {
      fatalError("compiler bug: the macro does not have any arguments")
    }

    guard argument.description.count < 20
    else {
      throw SomeError()
    }

    return "(\(argument), \(literal: argument.description))"
  }
}

struct SomeError: Error {}

@main
struct ExperimentationPlugin: CompilerPlugin {
  let providingMacros: [Macro.Type] = [
    StringifyMacro.self,
  ]
}
