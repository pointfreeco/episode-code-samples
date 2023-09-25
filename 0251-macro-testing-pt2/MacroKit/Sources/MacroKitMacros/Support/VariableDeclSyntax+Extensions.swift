extension VariableDeclSyntax {
  public var isComputed: Bool {

    return bindings.contains {
      switch $0.accessorBlock?.accessors {
      case .none:
        return false
      case let .some(.accessors(list)):
        return !list.allSatisfy {
          $0.accessorSpecifier.trimmed.text == "willSet"
          || $0.accessorSpecifier.trimmed.text == "didSet"
        }
      case .getter:
        return true
      }
    }

    //return bindings.contains(where: { $0.accessorBlock?.is(CodeBlockSyntax.self) == true })
  }
  public var isStored: Bool {
    return !isComputed
  }
  public var isStatic: Bool {
    return modifiers.lazy.contains(where: { $0.name.tokenKind == .keyword(.static) }) == true
  }
  public var identifier: TokenSyntax {
    return bindings.lazy.compactMap({ $0.pattern.as(IdentifierPatternSyntax.self) }).first!
      .identifier
  }

  public var type: TypeAnnotationSyntax? {
    return bindings.lazy.compactMap(\.typeAnnotation).first
  }

  public var initializerValue: ExprSyntax? {
    return bindings.lazy.compactMap(\.initializer).first?.value
  }

  public var effectSpecifiers: AccessorEffectSpecifiersSyntax? {
    return bindings
      .lazy
      .compactMap(\.accessorBlock?.accessors)
      .compactMap({ accessor in
        switch accessor {
        case .accessors(let syntax):
          return syntax.lazy.compactMap(\.effectSpecifiers).first
        case .getter:
          return nil
        }
      })
      .first
  }
  public var isThrowing: Bool {
    return
      bindings
      .compactMap(\.accessorBlock?.accessors)
      .contains(where: { accessor in
        switch accessor {
        case .accessors(let syntax):
          return syntax.contains(where: { $0.effectSpecifiers?.throwsSpecifier != nil })
        case .getter:
          return false
        }
      })
  }
  public var isAsync: Bool {
    return
      bindings
      .compactMap(\.accessorBlock?.accessors)
      .contains(where: { accessor in
        switch accessor {
        case .accessors(let syntax):
          return syntax.lazy.contains(where: { $0.effectSpecifiers?.asyncSpecifier != nil })
        case .getter:
          return false
        }
      })
  }
}
