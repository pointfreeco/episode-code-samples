import SwiftSyntax

public enum AccessLevelModifier: String, Comparable, CaseIterable {
    case `private`
    case `fileprivate`
    case `internal`
    case `public`
    case `open`

    public var keyword: Keyword {
        switch self {
        case .private: return .private
        case .fileprivate: return .fileprivate
        case .internal: return .internal
        case .public: return .public
        case .open: return .open
        }
    }

    public static func <(lhs: AccessLevelModifier, rhs: AccessLevelModifier) -> Bool {
        let lhs = Self.allCases.firstIndex(of: lhs)!
        let rhs = Self.allCases.firstIndex(of: rhs)!
        return lhs < rhs
    }
}

public protocol AccessLevelSyntax {
    var modifiers: DeclModifierListSyntax { get set }
}

extension AccessLevelSyntax {
    public var accessLevel: AccessLevelModifier {
        get { return modifiers.lazy.compactMap({ AccessLevelModifier(rawValue: $0.name.text) }).first ?? .internal }
        set {
            let new = DeclModifierSyntax(name: .keyword(newValue.keyword))
            var newModifiers: [DeclModifierListSyntax.Element] = []
            newModifiers.append(contentsOf: modifiers.filter({ AccessLevelModifier(rawValue: $0.name.text) == nil }))
            newModifiers.append(new)
            modifiers = .init(newModifiers)
        }
    }
}

extension StructDeclSyntax: AccessLevelSyntax { }
extension ClassDeclSyntax: AccessLevelSyntax { }
extension EnumDeclSyntax: AccessLevelSyntax { }
extension ActorDeclSyntax: AccessLevelSyntax { }

extension FunctionDeclSyntax: AccessLevelSyntax { }
extension VariableDeclSyntax: AccessLevelSyntax { }

extension DeclGroupSyntax {
    public var declAccessLevel: AccessLevelModifier {
        get { (self as? AccessLevelSyntax)?.accessLevel ?? .internal }
    }
}
