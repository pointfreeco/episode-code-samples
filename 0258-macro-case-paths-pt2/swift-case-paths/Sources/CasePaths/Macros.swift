//@CasePathable
//enum Loading {
//  case loaded(String)
//  case inProgress
//
////  struct Cases
////  static let cases
//}

@attached(member, names: named(Cases), named(cases))
@attached(extension, conformances: CasePathable)
public macro CasePathable() = #externalMacro(
  module: "CasePathsMacros", type: "CasePathableMacro"
)
