import Parsing

let usersCsv = """
1, Blob, true
2, Blob Jr, false
3, Blob Sr, true
4, "Blob, Esq.", true
"""

struct User: Equatable {
  var id: Int
  var name: String
  var admin: Bool
}

//OneOf {
//  a.map(f)
//  b.map(f)
//  c.map(f)
//}
//==
//OneOf {
//  a
//  b
//  c
//}
//.map(f)

let field = OneOf {
  Parse {
    "\""
    Prefix { $0 != "\"" }
    "\""
  }

  Prefix { $0 != "," }
}
.map(String.init)

let zeroOrOneSpace = OneOf {
  " "
  ""
}

let user = Parse(User.init(id:name:admin:)) {
  Int.parser()
  Skip {
    ","
    zeroOrOneSpace
  }
  field
  Skip {
    ","
    zeroOrOneSpace
  }
  Bool.parser()
}

let users = Many {
  user
} separator: {
  "\n"
} terminator: {
  End()
}

var input = usersCsv[...]
let output = try users.parse(&input)
input

"，" == ","

func print(user: User) -> String {
  "\(user.id), \(user.name.contains(",") ? "\"\(user.name)\"" : "\(user.name)"), \(user.admin)"
}

print(user: .init(id: 42, name: "Blob", admin: true))

func print(users: [User]) -> String {
  users.map(print(user:)).joined(separator: "\n")
}

//users.print(output)

print(users: output)

input = usersCsv[...]
try print(users: users.parse(input)) == input
try users.parse(print(users: output)) == output
