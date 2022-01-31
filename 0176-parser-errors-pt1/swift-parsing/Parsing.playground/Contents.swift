import Parsing

"Hello".parse("123 Hello world")

Optionally
{
  Int.parser()
}
.parse("Hello") == .some(nil)

struct User {
  var id: Int
  var name: String
  var isAdmin: Bool
}

let user = Parse(User.init) {
  Int.parser()
  ","
  Prefix { $0 != "," }.map(String.init)
  ","
  Bool.parser()
}

user.parse("1,Blob,tru")
