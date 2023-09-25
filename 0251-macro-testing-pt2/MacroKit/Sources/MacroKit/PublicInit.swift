@attached(member, names: named(init))
public macro PublicInit() = #externalMacro(module: "MacroKitMacros", type: "PublicInitMacro")
