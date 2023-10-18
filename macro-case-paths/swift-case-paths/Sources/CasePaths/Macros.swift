//@CasePathable
//enum Loading {
//  case loaded(String)
//  case inProgress
//
////  struct Cases
////  static let cases
//}

@attached(member)
public macro CasePathable() = #externalMacro(
  module: "CasePathsMacros", type: "CasePathableMacro"
)
