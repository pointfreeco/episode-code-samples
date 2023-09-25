public struct GenerateMockMacro: PeerMacro {
  enum Error: String, Swift.Error, DiagnosticMessage {
    var diagnosticID: MessageID { .init(domain: "GenerateMockMacro", id: rawValue) }
    var severity: DiagnosticSeverity { .error }
    var message: String {
      switch self {
      case .notAProtocol: return "@GenerateMock can only be applied to protocols"
      }
    }

    case notAProtocol
  }

  public static func expansion<Context: MacroExpansionContext, Declaration: DeclSyntaxProtocol>(
    of node: AttributeSyntax,
    providingPeersOf declaration: Declaration,
    in context: Context
  ) throws -> [DeclSyntax] {
    guard let protoDecl = declaration.as(ProtocolDeclSyntax.self) else { throw Error.notAProtocol }

    // Instance properties
    let mockMemberProperties = protoDecl.properties
      .map {
        DeclSyntax(
          "public var \(raw: $0.identifier.text): MockMember<\(raw: $0.type!.type.trimmed), \(raw: $0.returnType)> = .init()"
        )
      }
      .compactMap { MemberBlockItemSyntax(decl: $0) }

    let properties = protoDecl.properties
      .map(\.mockProperty)
      .compactMap { MemberBlockItemSyntax(decl: $0) }

    // Instance functions
    let mockMemberFunctions = protoDecl.functions
      .map {
        DeclSyntax(
          "public var \(raw: $0.name.text): MockMember<(\(raw: $0.parameters.typesWithoutAttribues.map(\.description).joined(separator: ", "))), \(raw: $0.returnTypeOrVoid)> = .init()"
        )
      }
      .compactMap { MemberBlockItemSyntax(decl: $0) }

    let functions = protoDecl.functions
      .map(\.mockFunction)
      .compactMap { MemberBlockItemSyntax(decl: $0) }

    // Consolidation
    let mockMemberMembers: MemberBlockItemListSyntax = .init(mockMemberProperties + mockMemberFunctions)

    let mockMembers = ClassDeclSyntax(
      modifiers: DeclModifierListSyntax {
        DeclModifierSyntax(name: "public")
      },
      name: "Members",
      memberBlock: MemberBlockSyntax(members: mockMemberMembers)
    )

    // Associatedtypes
    var genericParams: GenericParameterClauseSyntax?
    let associatedTypes = protoDecl.associatedTypes
    if !associatedTypes.isEmpty {
      let params = protoDecl.associatedTypes.enumerated().map { x, type in
        return type.genericParameter.with(
          \.trailingComma, x == associatedTypes.count - 1 ? nil : .commaToken())
      }
      genericParams = GenericParameterClauseSyntax(parameters: .init(params))
    }


    let cls = try ClassDeclSyntax(
      modifiers: DeclModifierListSyntax {
        DeclModifierSyntax(name: "open")
      },
      name: "\(raw: protoDecl.name.text)Mock",
      genericParameterClause: genericParams,
      inheritanceClause: InheritanceClauseSyntax {
        InheritedTypeSyntax(type: TypeSyntax("\(raw: protoDecl.name.text)"))
        if let inheritance = protoDecl.inheritanceClause?.inheritedTypes {
          inheritance
        }
      },
      genericWhereClause: nil,
      memberBlockBuilder: {
        DeclSyntax("public let mocks = Members()")

        mockMembers

        let initializers = protoDecl.initializers
        if initializers.isEmpty {
          DeclSyntax("public init() {}")
        }
        for initializer in initializers {
          try InitializerDeclSyntax(validating: initializer)
            .with(
              \.body,
               CodeBlockSyntax {
                 DeclSyntax("// ")
               })
        }

        MemberBlockItemListSyntax(properties)
        MemberBlockItemListSyntax(functions)
      }
    )

    return [
      "#if DEBUG",
      DeclSyntax(cls),
      "#endif",
    ]
  }
}

extension VariableDeclSyntax {
  /// Take a `VariableDeclSyntax` from the source protocol and add `AccessorDeclSyntax`s for the getter and, if needed, setter
  fileprivate var mockProperty: VariableDeclSyntax {
    var newProperty = trimmed
    var binding = newProperty.bindings.first!
    let accessor = binding.accessorBlock!.as(AccessorBlockSyntax.self)!

    guard
      case var .accessors(accessors) = accessor.accessors.trimmed,
      var getter = accessors.first
    else { fatalError() }

    getter.body = CodeBlockSyntax {
      DeclSyntax(
        "\(raw: getter.effectSpecifiers?.throwsSpecifier != nil ? "try " : "")mocks.\(raw: newProperty.identifier.text).getter()"
      )
    }

    accessors = [getter]
    if getter.effectSpecifiers == nil {
      accessors.append("set { mocks.\(raw: identifier.text).setter(newValue) }")
    }

    binding.accessorBlock?.accessors = .accessors(accessors)
    newProperty.accessLevel = .open
    newProperty.bindings[newProperty.bindings.startIndex] = binding
    return newProperty.trimmed
  }
}

extension FunctionDeclSyntax {
  fileprivate var mockFunction: FunctionDeclSyntax {
    var newFunction = trimmed

    var newSignature = signature
    var params: [String] = []
    for (x, param) in signature.parameterClause.parameters.enumerated() {
      var newParam = param
      newParam.secondName = "arg\(raw: x)"
      newSignature.parameterClause.parameters[newSignature.parameterClause.parameters.index(newSignature.parameterClause.parameters.startIndex, offsetBy: x)] = newParam

      params.append("arg\(x)")
    }

    newFunction.signature = newSignature
    newFunction.accessLevel = .open
    newFunction.body = CodeBlockSyntax {
      DeclSyntax(
        "return \(raw: isThrowing ? "try " : "")mocks.\(raw: name.text).execute((\(raw: params.joined(separator: ", "))))"
      )
    }
    return newFunction
  }
}

extension VariableDeclSyntax {
  fileprivate var returnType: DeclSyntax {
    if isThrowing {
      return "\(raw: "Result<\(type!.type.trimmed), Error>")"
    } else {
      return "\(raw: type!.type.trimmed)"
    }
  }
}
extension FunctionDeclSyntax {
  fileprivate var returnTypeOrVoid: DeclSyntax {
    if isThrowing {
      return "Result<\(raw: returnOrVoid.type), Error>"
    } else {
      return "\(raw: returnOrVoid.type)"
    }
  }
}
extension AssociatedTypeDeclSyntax {
  fileprivate var genericParameter: GenericParameterSyntax {
    let type = self.inheritanceClause?.inheritedTypes.first

    return GenericParameterSyntax(
      attributes: attributes,
      name: name,
      colon: type.map { _ in .colonToken() },
      inheritedType: type.map { TypeSyntax("\(raw: $0)") }
    )
  }
}
