@attached(member, names: named(init(from:)), named(encode(to:)))
public macro UnkeyedCodable() = #externalMacro(module: "MacroKitMacros", type: "UnkeyedCodableMacro")

@attached(member, names: named(encode(to:)))
public macro UnkeyedEncodable() = #externalMacro(module: "MacroKitMacros", type: "UnkeyedEncodableMacro")

@attached(member, names: named(init(from:)))
public macro UnkeyedDecodable() = #externalMacro(module: "MacroKitMacros", type: "UnkeyedDecodableMacro")

