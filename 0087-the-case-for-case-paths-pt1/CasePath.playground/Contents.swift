import Foundation

struct User {
  var id: Int
  let isAdmin: Bool
  var name: String
}

\User.id as WritableKeyPath<User, Int>
\User.isAdmin as KeyPath<User, Bool>
\User.name

var user = User(id: 42, isAdmin: true, name: "Blob")

user[keyPath: \.id]

user[keyPath: \.id] = 57

user.id = 57
user.name = "Blob Jr."

class Label: NSObject {
  @objc dynamic var font = "Helvetica"
  @objc dynamic var fontSize = 12
  @objc dynamic var text = ""
}

class Model: NSObject {
  @objc dynamic var userName = ""
}

let model = Model()
let label = Label()

bind(model: model, \.userName, to: label, \.text)

//bind(model: model, get: { $0.userName }, to: label, get: { $0.text }, set: { $0.text = $1 })

label.text
model.userName = "blob"
label.text
model.userName = "XxFP_FANxX93"
label.text

import Combine

let subject = PassthroughSubject<String, Never>()
subject.assign(to: \.text, on: label)

subject.send("MaTh_FaN96")
label.text


typealias Reducer<Value, Action> = (inout Value, Action) -> Void

[1, 2, 3]
  .reduce(into: 0, { $0 += $1 })
[1, 2, 3]
  .reduce(into: 0, +=)


func pullback<GlobalValue, LocalValue, Action>(
  _ reducer: @escaping Reducer<LocalValue, Action>,
  value: WritableKeyPath<GlobalValue, LocalValue>
) -> Reducer<GlobalValue, Action> {

  return { globalValue, action in
//    var localValue = globalValue[keyPath: value]
//    reducer(&localValue, action)
//    globalValue[keyPath: value] = localValue
    reducer(&globalValue[keyPath: value], action)
  }
}

func pullback<GlobalValue, LocalValue, Action>(
  _ reducer: @escaping Reducer<LocalValue, Action>,
  getLocalValue: @escaping (GlobalValue) -> LocalValue,
  setLocalValue: @escaping (inout GlobalValue, LocalValue) -> Void
) -> Reducer<GlobalValue, Action> {

  return { globalValue, action in
    var localValue = getLocalValue(globalValue)
    reducer(&localValue, action)
    setLocalValue(&globalValue, localValue)
  }
}

let counterReducer: Reducer<Int, Void> = { count, _ in count += 1 }

pullback(counterReducer, value: \User.id)

[1, 2, 3]
  .map(String.init)

pullback(
  counterReducer,
  getLocalValue: { (user: User) in user.id },
  setLocalValue: { $0.id = $1 }
)


struct _WritableKeyPath<Root, Value> {
  let get: (Root) -> Value
  let set: (inout Root, Value) -> Void
}


// [user valueForKeyPath:@"location.city"]

struct CasePath<Root, Value> {
  let extract: (Root) -> Value?
  let embed: (Value) -> Root
}

extension Result {
  static var successCasePath: CasePath<Result, Success> {
    CasePath<Result, Success>(
      extract: { result -> Success? in
        if case let .success(value) = result {
          return value
        }
        return nil
    },
      embed: Result.success
    )
  }

  static var failureCasePath: CasePath<Result, Failure> {
    CasePath<Result, Failure>(
      extract: { result -> Failure? in
        if case let .failure(value) = result {
          return value
        }
        return nil
    },
      embed: Result.failure
    )
  }
}

Result<Int, Error>.successCasePath
Result<Int, Error>.failureCasePath
