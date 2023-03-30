
struct Wrapper<Value> {
  var value: Value {
    get { self.storage.value }
    set {
      if Swift.isKnownUniquelyReferenced(&self.storage) {
        self.storage.value = newValue
      } else {
        self.storage = Storage(value: newValue)
      }
    }
  }

  private var storage: Storage

  init(value: Value) {
    self.storage = Storage(value: value)
  }

  mutating func isKnownUniquelyReferenced() -> Bool {
    Swift.isKnownUniquelyReferenced(&self.storage)
  }

  private class Storage {
    var value: Value
    init(value: Value) {
      self.value = value
    }
  }
}

import Foundation

extension Wrapper: Equatable where Value: Equatable {
  static func == (lhs: Self, rhs: Self) -> Bool {
    if lhs.storage === rhs.storage {
      return true
    }
    Thread.sleep(forTimeInterval: 3)
    return lhs.value == rhs.value
  }
}

var x = Wrapper(value: 1)
x.isKnownUniquelyReferenced()
var y = x
x.isKnownUniquelyReferenced()
y.isKnownUniquelyReferenced()
x == y
x.value = 2
y.value = 2
x == y
y.value
x.value
x.isKnownUniquelyReferenced()
y.isKnownUniquelyReferenced()

var z = 1
var w = z
z = 2
w
z
