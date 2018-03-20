
struct Food {
  var name: String
}

struct Location {
  var name: String
}

struct User {
  var favoriteFoods: [Food]
  var location: Location
  var name: String
}

let user = User(
  favoriteFoods: [Food(name: "Tacos"), Food(name: "Nachos")],
  location: Location(name: "Brooklyn"),
  name: "Blob"
)

User(
  favoriteFoods: user.favoriteFoods,
  location: Location(name: "Los Angeles"),
  name: user.name
)

func first<A, B, C>(_ f: @escaping (A) -> B) -> ((A, C)) -> (B, C) {
  return { pair in
    (f(pair.0), pair.1)
  }
}

func userLocationName(_ f: @escaping (String) -> String) -> (User) -> User {
  return { user in
    User(
      favoriteFoods: user.favoriteFoods,
      location: Location(name: f(user.location.name)),
      name: user.name
    )
  }
}

user
  |> userLocationName { _ in "Los Angeles" }

user
  |> userLocationName { $0 + "!" }

\User.name // WritableKeyPath<User, String>

user.name
user[keyPath: \User.name]

var copy = user
copy.name = "Blobbo"
copy[keyPath: \User.name] = "Blobbo"

func prop<Root, Value>(_ kp: WritableKeyPath<Root, Value>)
  -> (@escaping (Value) -> Value)
  -> (Root)
  -> Root {

    return { update in
      { root in
        var copy = root
        copy[keyPath: kp] = update(copy[keyPath: kp])
        return copy
      }
    }
}

prop(\User.name) // ((String) -> String) -> (User) -> User
(prop(\User.name)) { $0.uppercased() }

prop(\User.location) <<< prop(\.name)
prop(\User.location.name)

user
  |> (prop(\.name)) { $0.uppercased() }
  |> (prop(\.location.name)) { _ in "Los Angeles" }

(42, user)
  |> (second <<< prop(\.name)) { $0.uppercased() }
  |> first(incr)

user.favoriteFoods
  .map { Food(name: $0.name + " & Salad") }

let healthier = (prop(\User.favoriteFoods) <<< map <<< prop(\.name)) {
  $0 + " & Salad"
}

second(healthier)
  <> second(healthier)
  <> (second <<< prop(\.location.name)) { _ in "Miami" }
  <> (second <<< prop(\.name)) { "Healthy " + $0 }
  <> first(incr)

second(
  healthier
    <> healthier
    <> (prop(\.location.name)) { _ in "Miami" }
    <> (prop(\.name)) { "Healthy " + $0 }
  )
  <> first(incr)


public func map<A, B>(_ f: @escaping (A) -> B) -> (A?) -> B? {
  return { $0.map(f) }
}


var newUser = user
newUser.name = "Blobbo"
newUser.location.name = "Los Angeles"
newUser.favoriteFoods = copy.favoriteFoods.map { Food(name: $0.name + " & Salad") }

let xs = [1, 2, 3]
xs.map { $0 + 1 }

var ys = [Int]()
xs.forEach { x in
  ys.append(x + 1)
}

import Foundation

var request = URLRequest(url: URL(string: "https://www.pointfree.co/hello")!)

request.allHTTPHeaderFields = request.allHTTPHeaderFields ?? [:]

request.allHTTPHeaderFields?["Authorization"] = "Token deadbeef"
request.allHTTPHeaderFields?["Content-Type"] = "application/json; charset=utf-8"
request.allHTTPHeaderFields
request.httpMethod = "POST"

request.allHTTPHeaderFields

let guaranteeHeaders = (prop(\URLRequest.allHTTPHeaderFields)) { $0 ?? [:] }

let postJson =
  guaranteeHeaders
    <> (prop(\.httpMethod)) { _ in "POST" }
    <> (prop(\.allHTTPHeaderFields) <<< map <<< prop(\.["Content-Type"])) { _ in "application/json; charset=utf-8"}

let gitHubAccept =
  guaranteeHeaders
    <> (prop(\.allHTTPHeaderFields) <<< map <<< prop(\.["Accept"])) { _ in "application/vnd.github.v3+json" }

let attachAuthorization = { (token: String) in
  guaranteeHeaders
    <> (prop(\.allHTTPHeaderFields) <<< map <<< prop(\.["Authorization"])) { _ in "Token \(token)" }
}

URLRequest(url: URL(string: "https://www.pointfree.co/hello")!)
  |> attachAuthorization("deadbeef")
  |> gitHubAccept
  |> postJson


let noFavoriteFoods = (prop(\User.favoriteFoods)) { _ in [] }
let healthyEater = (prop(\User.favoriteFoods)) { _ in [Food(name: "Kale"), Food(name: "Broccoli")] }
let domestic = (prop(\User.location.name)) { _ in "Brooklyn" }
let international = (prop(\User.location.name)) { _ in "Copenhagen" }

extension User {
  static let template =
    User(
      favoriteFoods: [Food(name: "Tacos"), Food(name: "Nachos")],
      location: Location(name: "Brooklyn"),
      name: "Blob"
  )
}

User.template
  |> healthyEater
  |> international

let boringLocal = .template
  |> noFavoriteFoods
  |> domestic
//: [See the next page](@next) for exercises!

