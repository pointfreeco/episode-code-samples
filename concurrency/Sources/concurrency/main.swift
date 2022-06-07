import Foundation

let task = Task<Int, Error>.init {
  struct SomeError: Error {}
  throw SomeError()
  return 42
}

func doSomethingAsync() async {}

Task {
  await doSomethingAsync()
}

func doSomethingElseAsync() async {
  await doSomethingAsync()
}

func doSomethingThatCanFail() throws {}

try doSomethingThatCanFail()

func doSomething() /*throws*/ {
  do {
    try doSomethingThatCanFail()
  } catch let error {
//    TODO: Handle error
  }
}

// (A) throws -> B
// (A) -> Result<B, Error>

// (inout A) -> B
// (A) -> (B, A)

// (A) async -> B
// (A) -> Task<B, Never>
// (A) -> ((B) -> Void) -> Void
// (A, (B) -> Void) -> Void

// dataTask: (URL, completionHandler: (Data?, Response?, Error?) -> Void) -> Void
// start: ((MKLocalSearch.Response?, Error?) -> Void) -> Void



for n in 0..<workCount {
  Task {
    let current = Thread.current
    try await Task.sleep(nanoseconds: NSEC_PER_SEC)
    if current != Thread.current {
      print(n, "Thread changed from", current, "to", Thread.current)
    }
  }
}


Thread.sleep(forTimeInterval: 5)
