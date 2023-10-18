import Foundation
import SwiftUI

struct User {
  let id: UUID
  var name: String
}

let kp1 = \User.id
let kp2 = \User.name

func f() {
  var user = User(id: UUID(), name: "Blob")
  let id = user[keyPath: \User.id]
  user[keyPath: \User.name] = "Blob, Jr"

  user.id
  user.name = "Blob, Jr"

  let users = [
    User(id: UUID(), name: "Blob"),
    User(id: UUID(), name: "Blob Jr."),
    User(id: UUID(), name: "Blob Sr."),
  ]
//  let names = users.map { $0.name }
  let names = users.map(\.name)

  let loadings = [Loading.inProgress, Loading.loaded("Blob")]
  let loadeds = loadings.compactMap(\.loaded)
}

extension Binding {
  subscript<Member>(
    dynamicMember keyPath: WritableKeyPath<Value, Member>
  ) -> Binding<Member> {
    Binding<Member>(
      get: { self.wrappedValue[keyPath: keyPath] },
      set: { self.wrappedValue[keyPath: keyPath] = $0 }
    )
  }
}

struct SomeView: View {
  @Binding var user: User

  var body: some View {
    let nameBinding = $user.name
    EmptyView()
      .environment(\.colorScheme, .dark)
  }
}

func g() {
  var user = User(id: UUID(), name: "Blob, Sr")
  withUnsafeMutablePointer(to: &user) { userPtr in
    let namePtr = userPtr.pointer(to: \.name)
    let idPtr = userPtr.pointer(to: \.id)
  }
}

let getUserID: (User) -> UUID = { $0.id }
let getUserName: (User) -> String = { $0.name }
let setUserName: (inout User, String) -> Void = { $0.name = $1 }

struct GetterAndSetter<Root, Value> {
  var get: (Root) -> Value
  var set: (inout Root, Value) -> Void
}

extension GetterAndSetter where Root == User, Value == String {
  static var name: Self {
    Self(get: { $0.name }, set: { $0.name = $1 })
  }
}

enum Loading {
  case inProgress
  case loaded(String)
}

let extractLoaded: (Loading) -> String? = {
  guard case let .loaded(value) = $0
  else { return nil }
  return value
}
let embedLoaded: (String) -> Loading = Loading.loaded

//struct CasePath<Root, Value> {
//  let extract: (Root) -> Value?
//  let embed: (Value) -> Root
//}

//\Loading.loaded  // WritableKeyPath<Loading, String?>

func h() {
  var value = Loading.inProgress
//  value[keyPath: \.loaded]  // nil
//
//  value[keyPath: \.loaded] = 1  // ???
//  value[keyPath: \.loaded] = nil  // ???
}

import CasePaths

let loadedCasePath = /Loading.loaded
let nameKeyPath = \User.name

func j() throws {
  var value = Loading.loaded("Hello")
  (/Loading.loaded).extract(from: value)      // "Hello"
  (/Loading.inProgress).extract(from: value)  // nil
  (/Loading.loaded).embed("Hello")

  //user[keyPath: \.name] = "Blob"

  try (/Loading.loaded).modify(&value) {
    $0 += "!!!"
  }

  if case let .loaded(string) = value {
    value = .loaded(string + "!!!")
  }
}

// CasePath<Loading, String>(Loading.loaded)

//CasePath(
//  embed: Loading.loaded,
//  extract: {
//    guard case let .loaded(value) = $0
//    else { return nil }
//    return value
//  }
//)
