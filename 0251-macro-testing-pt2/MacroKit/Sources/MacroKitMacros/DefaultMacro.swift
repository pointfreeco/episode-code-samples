import SwiftCompilerPlugin
import SwiftDiagnostics
import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftSyntaxMacros

public struct DefaultMacro { }

extension DefaultMacro: PeerMacro {
    public static func expansion<Context: MacroExpansionContext, Declaration: DeclSyntaxProtocol>(
        of node: AttributeSyntax,
        providingPeersOf declaration: Declaration,
        in context: Context
    ) throws -> [DeclSyntax] {
        guard let variable = declaration.as(VariableDeclSyntax.self) else { fatalError() }
        guard variable.isStored else { fatalError() }
        guard variable.initializerValue == nil else { fatalError() }
        guard let value = node.argumentList?.first else { fatalError() }

        let defaultValue: DeclSyntax = """
        private enum _\(raw: variable.identifier)Default: DefaultValue {
            static var value = \(raw: value)
        }
        """

        let storageType: TypeSyntax = "Default<_\(raw: variable.identifier)Default>"
        let backingStore: DeclSyntax = """
        private var _\(raw: variable.identifier): \(raw: storageType)
        """
        return [defaultValue, backingStore]
    }
}

extension DefaultMacro: AccessorMacro {
    public static func expansion<Context : MacroExpansionContext, Declaration : DeclSyntaxProtocol>(
        of node: AttributeSyntax,
        providingAccessorsOf declaration: Declaration,
        in context: Context
    ) throws -> [AccessorDeclSyntax] {
        guard let variable = declaration.as(VariableDeclSyntax.self) else { fatalError() }
        guard variable.isStored else { fatalError() }

        return [
          """
          get { _\(variable.identifier).wrappedValue }
          """,
          """
          set { _\(variable.identifier).wrappedValue = newValue }
          """,
        ]
    }
}

extension AttributeSyntax {
  var argumentList: LabeledExprListSyntax? {
    switch arguments {
        case .argumentList(let value): return value
        default: return nil
        }
    }
}
