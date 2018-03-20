
func greet(at date: Date, name: String) -> String {
  let seconds = Int(date.timeIntervalSince1970) % 60
  return "Hello \(name)! It's \(seconds) seconds past the minute."
}

func greet(at date: Date) -> (String) -> String {
  return { name in
    let seconds = Int(date.timeIntervalSince1970) % 60
    return "Hello \(name)! It's \(seconds) seconds past the minute."
  }
}

func curry<A, B, C>(_ f: @escaping (A, B) -> C) -> (A) -> (B) -> C {
  return { a in { b in f(a, b) } }
}

curry(greet(at:name:))
greet(at:)

curry(String.init(data:encoding:))
  >>> { $0(.utf8) }

func flip<A, B, C>(_ f: @escaping (A) -> (B) -> C) -> (B) -> (A) -> C {

  return { b in { a in f(a)(b) } }
}

func flip<A, C>(_ f: @escaping (A) -> () -> C) -> () -> (A) -> C {

  return { { a in f(a)() } }
}

let stringWithEncoding = flip(curry(String.init(data:encoding:)))

let uft8String = stringWithEncoding(.utf8)

"Hello".uppercased(with: Locale.init(identifier: "en"))

String.uppercased(with:)

// (Self) -> (Arguments) -> ReturnType

String.uppercased(with:)("Hello")(Locale.init(identifier: "en"))

let uppercasedWithLocale = flip(String.uppercased(with:))
let uppercasedWithEn = uppercasedWithLocale(Locale.init(identifier: "en"))

"Hello" |> uppercasedWithEn

flip(String.uppercased)
flip(String.uppercased)()
"Hello" |> flip(String.uppercased)()

func zurry<A>(_ f: () -> A) -> A {
  return f()
}

"Hello" |> zurry(flip(String.uppercased))

[1, 2, 3]
  .map(incr)
  .map(square)

//curry([Int].map as ([Int]) -> ((Int) -> Int) -> [Int])

func map<A, B>(_ f: @escaping (A) -> B) -> ([A]) -> ([B]) {
  return { $0.map(f) }
}

map(incr)
map(square)
map(incr >>> square >>> String.init)

Array(1...10)
  .filter { $0 > 5 }

func filter<A>(_ p: @escaping (A) -> Bool) -> ([A]) -> [A] {
  return { $0.filter(p) }
}

Array(1...10)
  |> filter { $0 > 5 }
  >>> map(incr >>> square)
//: [See the next page](@next) for exercises!
