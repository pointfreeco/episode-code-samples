
// extension Array {
//   func flatMap<B>(_ f: @escaping (Element) -> [B]) -> [B] {
//   }
// }

let csv = """
1,2,3,4
3,5,2
8,9,4
"""

csv
  .split(separator: "\n")
  .map { $0.split(separator: ",") }



// extension Optional {
//   func flatMap<B>(_ f: @escaping (Element) -> B?) -> B? {
//   }
// }

String.init(data: Data(), encoding: .utf8)
  .map(Int.init)

let _: Int? = String.init(data: Data([55]), encoding: .utf8)
  .flatMap(Int.init)

["1", "2", "buckle", "my", "shoe"]
  .map(Int.init)

["1", "2", "buckle", "my", "shoe"]
  .flatMap(Int.init)

csv.split(separator: "\n")
  .flatMap { $0.split(separator: ",") }
  .flatMap { Int($0) }
  .reduce(0, +)




// flatMap : ((A) -> [B]) -> ([A]) -> [B]
// flatMap : ((A) ->  B?) -> ( A?) ->  B?

// flatMap : ((A) ->  B?) -> ([A]) -> [B]



// flatMap : ((A) ->    Array<B>) -> (   Array<A>) ->    Array<B>
// flatMap : ((A) -> Optional<B>) -> (Optional<A>) -> Optional<B>

// flatMap : ((A) -> Optional<B>) -> (   Array<A>) ->    Array<B>



// flatMap : ((A) -> M<B>) -> (M<A>) -> M<B>
// flatMap : ((A) -> M<B>) -> (M<A>) -> M<B>

// flatMap : ((A) -> B?) -> (M<A>) -> M<B>



[1, 2, 3]
  .flatMap { $0 + 1 }



struct User {
  let name: String
}

let users = [User(name: "Blob"), User(name: "Math")]
users
  .map { $0.name }
users
  .flatMap { $0.name }



extension Array {
  func filterMap<B>(_ transform: (Element) -> B?) -> [B] {
    var result = [B]()
    for x in self {
      switch transform(x) {
      case let .some(x):
        result.append(x)
      case .none:
        continue
      }
    }
    return result
  }
}



extension Array {
  func compactMap<B>(_ transform: (Element) -> B?) -> [B] {
    var result = [B]()
    for x in self {
      switch transform(x) {
      case let .some(x):
        result.append(x)
      case .none:
        continue
      }
    }
    return result
  }
}



func filterSome<A>(_ p: @escaping (A) -> Bool) -> (A) -> A? {
  return { p($0) ? .some($0) : .none }
}


func filter<A>(_ p: @escaping (A) -> Bool) -> ([A]) -> [A] {
  return { $0.filterMap(filterSome(p)) }
}


Array(0..<10)
  |> filter { $0 % 2 == 0 }

enum Either<A, B> {
  case left(A)
  case right(B)
}



func partitionEither<A>(_ p: @escaping (A) -> Bool) -> (A) -> Either<A, A> {
  return { p($0) ? .right($0) : .left($0) }
}





extension Array {
  func partitionMap<A, B>(_ transform: (Element) -> Either<A, B>) -> (lefts: [A], rights: [B]) {
    var result = (lefts: [A](), rights: [B]())
    for x in self {
      switch transform(x) {
      case let .left(a):
        result.lefts.append(a)
      case let .right(b):
        result.rights.append(b)
      }
    }
    return result
  }
}

func partition<A>(_ p: @escaping (A) -> Bool) -> ([A]) -> (`false`: [A], `true`: [A]) {
  return {
    let (lefts, rights) = $0.partitionMap(partitionEither(p))
    return (lefts, rights)
  }
}



func partitionMap<A, B, C>(_ p: @escaping (A) -> Either<B, C>) -> ([A]) -> (lefts: [B], rights: [C]) {
  return { $0.partitionMap(p) }
}

let evenOdds = { $0 % 2 == 0 ? Either.left($0) : .right($0) }
partitionMap(evenOdds)

Array(1...10)
  |> partitionMap(evenOdds)
  |> (first <<< map)(square)
//: [See the next page](@next) for exercises!
