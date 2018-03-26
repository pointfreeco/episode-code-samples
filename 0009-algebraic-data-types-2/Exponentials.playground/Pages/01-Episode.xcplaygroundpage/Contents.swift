
//(Data + 1) * (URLResponse + 1) * (Error + 1)
//  = Data * URLResponse * Error
//  + Data * URLResponse
//  + URLResponse * Error
//  + Data * Error
//  + Data
//  + URLResponse
//  + Error
//  + 1

// URLResponse * Data + Error

// (URLResponse + 1) * (Data + Error)
//   = URLResponse * Data
//     + URLResponse * Error
//     + Data
//     + Error

// (URLResponse?, Result<Data, Error>)

// switch (response, result) {
// case let (.some(response), .success(data)):
// case let (.some(response), .failed(error)):
// case let (.none, .success(data)):
// case let (.none, .failed(error)):
// }


//   = URLResponse * Data
//     + URLResponse * Error
//     + Error

// 2^100 = 2*2*2....*2
//pow(2, 100)


enum Three { case one, two, three }

// Bool^Three
// Bool^(1 + 1 + 1)
// Bool^1 * Bool^1 * Bool^1

// (Three) -> Bool

// A^B = (B) -> A

func f1(_ x: Three) -> Bool {
  switch x {
  case .one:   return true
  case .two:   return true
  case .three: return true
  }
}
func f2(_ x: Three) -> Bool {
  switch x {
  case .one:   return false
  case .two:   return true
  case .three: return true
  }
}
func f3(_ x: Three) -> Bool {
  switch x {
  case .one:   return true
  case .two:   return false
  case .three: return true
  }
}
func f4(_ x: Three) -> Bool {
  switch x {
  case .one:   return true
  case .two:   return true
  case .three: return false
  }
}
func f5(_ x: Three) -> Bool {
  switch x {
  case .one:   return false
  case .two:   return false
  case .three: return true
  }
}
func f6(_ x: Three) -> Bool {
  switch x {
  case .one:   return false
  case .two:   return true
  case .three: return false
  }
}
func f7(_ x: Three) -> Bool {
  switch x {
  case .one:   return true
  case .two:   return false
  case .three: return false
  }
}
func f8(_ x: Three) -> Bool {
  switch x {
  case .one:   return false
  case .two:   return false
  case .three: return false
  }
}

// 2^3 = 8
pow(2, 3)


//func foo1(_ x: Three) -> Bool {
//  print("hello")
//  return true
//}
//
//func foo2(_ x: Three) -> Bool {
//  print("world")
//  return false
//}
//
//func foo3(_ x: Three) -> Bool {
//  URLSession.shared.dataTask(with: URL(string: "https://www.pointfree.co")!).resume()
//  return true
//}


let a = 2
let b = 3
let c = 4

// (a^b)^c = a^(b*c)
pow(pow(a, b), c) == pow(a, b * c) 

// (a^b)^c = a^(b*c)
// (a <- b) <- c = a <- (b * c)
// c -> (b -> a) = (b * c) -> a

// (C) -> (B) -> A = (B, C) -> A


func curry<A, B, C>(_ f: @escaping (A, B) -> C) -> (A) -> (B) -> C {
  return { a in { b in f(a, b) } }
}

func uncurry<A, B, C>(_ f: @escaping (A) -> (B) -> C) -> (A, B) -> C {
  return { f($0)($1) }
}

String.init(data:encoding:)
curry(String.init(data:encoding:))
uncurry(curry(String.init(data:encoding:)))


// a^1 = a
pow(a, 1) == a
pow(b, 1) == b
pow(c, 1) == c

// a^1 = a
// a <- 1 = a
// 1 -> a = a

// (Void) -> A = A

func zurry<A>(_ f: () -> A) -> A {
  return f()
}

func unzurry<A>(_ a: A) -> () -> A {
  return { a }
}

// a^0 = 1
pow(a, 0) == 1
pow(b, 0) == 1
pow(c, 0) == 1
pow(0, 0) == 1

// a^0 = 1
// a <- 0 = 1
// 0 -> a = 1

// Never -> A = Void

func to<A>(_ f: (Never) -> A) -> Void {
  return ()
}

func from<A>(_ x: Void) -> (Never) -> A {
  return { never in
    switch never {
      //
    }
  }
}

func isInt(_ x: Either<Int, String>) -> Bool {
  switch x {
  case .left:  return true
  case .right: return false
  }
  // No return needed here
}

func absurd<A>(_ never: Never) -> A {
  switch never {
    //
  }
}

extension Result {
  func fold<A>(ifSuccess: (Value) -> A, ifFailure: (Error) -> A) -> A {
    switch self {
    case let .success(value):
      return ifSuccess(value)
    case let .failure(error):
      return ifFailure(error)
    }
  }
}

let result: Result<Int, String> = .success(2)
result
  .fold(ifSuccess: { _ in "Ok" }, ifFailure: { _ in "Something went wrong" })

let infallibleResult: Result<Int, Never> = .success(2)
infallibleResult
  .fold(ifSuccess: { _ in "Ok" }, ifFailure: absurd)

// (A) -> A
// (inout A) -> Void


func to<A>(
  _ f: @escaping (A) -> A
  ) -> ((inout A) -> Void) {

  return { a in
    a = f(a)
  }
}

func from<A>(
  _ f: @escaping (inout A) -> Void
  ) -> ((A) -> A) {

  return { a in
    var copy = a
    f(&copy)
    return copy
  }
}

// (A, B) -> A
// (inout A, B) -> Void

// (A, inout B) -> C
// (A, B) -> (C, B)

Data.init(from:)

// (A) throws -> B == (A) -> Result<B, Error>

func unthrow<A, B>(_ f: @escaping (A) throws -> B) -> (A) -> Result<B, Error> {
  return { a in
    do {
      return .success(try f(a))
    } catch {
      return .failure(error)
    }
  }
}

func throwing<A, B>(_ f: @escaping (A) -> Result<B, Error>) -> (A) throws -> B {
  return { a in
    switch f(a) {
    case let .success(value):
      return value
    case let .failure(error):
      throw error
    }
  }
}

Data.init(from:)
unthrow(Data.init(from:))
throwing(unthrow(Data.init(from:)))

// a^(b + c) = a^b * a^c
pow(a, b + c) == pow(a, b) * pow(a, c)

// a^(b + c) = a^b * a^c
// a <- (b + c) = (a <- b) * (a <- c)
// (b + c) -> a = (b -> a) * (c -> a)

// Either<B, C> -> A = (B -> A, C -> A)

func to<A, B, C>(_ f: @escaping (Either<B, C>) -> A) -> ((B) -> A, (C) -> A) {
  fatalError("exercise for the viewer")
}

func from<A, B, C>(_ f: ((B) -> A, (C) -> A)) -> (Either<B, C>) -> A {
  fatalError("exercise for the viewer")
}

// (a * b)^c = a^c * b^c
pow(a * b, c) == pow(a, c) * pow(b, c)

// (a * b)^c = a^c * b^c
// (a * b) <- c = (a <- c) * (b <- c)
// c -> (a * b) = (c -> a) * (c -> b)

// (C) -> (A, B) = ((C) -> A, (C) -> B)

func to<A, B, C>(_ f: @escaping (C) -> (A, B)) -> ((C) -> A, (C) -> B) {
  fatalError("exercise for the viewer")
}

func from<A, B, C>(_ f: ((C) -> A, (C) -> B)) -> (C) -> (A, B) {
  fatalError("exercise for the viewer")
}

// a^(b * c) != a^b * a^c
pow(a, b * c) != pow(a, b) * pow(a, c)

// a^(b * c) != a^b * a^c
// a <- (b * c) != (a <- b) * (a <- c)
// (b * c) -> a != (b -> a) * (c -> a)

// (B, C) -> A != ((B) -> A, (C) -> A)



// (a + b)^c != a^c + b^c
pow(a + b, c) != pow(a, c) + pow(b, c)

// (a + b)^c != a^c + b^c
// (a + b) <- c != (a <- c) + (b <- c)
// c -> (a + b) != (c -> a) + (c -> b)

// (C) -> Either<A, B> != Either<(C) -> A, (C) -> B>


//import Foundation
//URLSession.shared.dataTask(with: <#T##URL#>, completionHandler: <#T##(Data?, URLResponse?, Error?) -> Void#>) -> Void


//: [See the next page](@next) for exercises!

