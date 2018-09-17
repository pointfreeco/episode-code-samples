
import Darwin
arc4random()

arc4random() % 6 + 1

arc4random_uniform(6) + 1

// 1984-2018

arc4random_uniform(2018 + 1 - 1984) + 1984

func arc4random_uniform(between a: UInt32, and b: UInt32) -> UInt32 {
  return arc4random_uniform(b + 1 - a) + a
}

arc4random_uniform(between: 1984, and: 2018)

UInt32.random(in: 1984...2018)
UInt32.random(in: .min ... .max)


UInt.random(in: 1984...2018)
UInt.random(in: .min ... .max)

Int.random(in: 1984...2018)
Int.random(in: .min ... .max)

//Int.random(in: 0..<0)


enum Move: CaseIterable {
  case rock, paper, scissors
}

Move.allCases

Move.allCases[Int(arc4random_uniform(UInt32(Move.allCases.count)))]

func arc4random_uniform<A>(element xs: [A]) -> A {
  return xs[Int(arc4random_uniform(UInt32(xs.count)))]
}

arc4random_uniform(element: Move.allCases)

//arc4random_uniform(element: [])

print(Move.allCases.randomElement())
[].randomElement()


Double.random(in: 0...1)
Bool.random()

arc4random() % 2 == 0

arc4random

// () -> UInt32
// (UInt32) -> Double

//let uniform = arc4random >>> { Double($0) / Double(UInt32.max) }
//uniform(())

struct Gen<A> {
  let run: () -> A
}

let random = Gen { arc4random() }
random.run()

struct Func<A, B> { let run: (A) -> B }

extension Gen {
  func map<B>(_ f: @escaping (A) -> B) -> Gen<B> {
    return Gen<B> { f(self.run()) }
  }
}

random.map(String.init).run()

let uniform = random.map { Double($0) / Double(UInt32.max) }

uniform.run()
uniform.run()
uniform.run()

func double(in range: ClosedRange<Double>) -> Gen<Double> {
  return uniform.map { t in
    t * (range.upperBound - range.lowerBound) + range.lowerBound
  }
}

double(in: -2...10).run()
double(in: -2...10).run()
double(in: -2...10).run()
double(in: -2...10).run()

Double.random(in: -2...10)

let uint64: Gen<UInt64> = .init {
  let lower = UInt64(random.run())
  let upper = UInt64(random.run()) << 32
  return lower + upper
}

uint64.run()
uint64.run()
uint64.run()
uint64.run()

func int(in range: ClosedRange<Int>) -> Gen<Int> {
  return .init {
    var delta = UInt64(truncatingIfNeeded: range.upperBound &- range.lowerBound)
    if delta == UInt64.max {
      return Int(truncatingIfNeeded: uint64.run())
    }
    delta += 1
    let tmp = UInt64.max % delta + 1
    let upperBound = tmp == delta ? 0 : tmp
    var random: UInt64 = 0
    repeat {
      random = uint64.run()
    } while random < upperBound
    return Int(
      truncatingIfNeeded: UInt64(truncatingIfNeeded: range.lowerBound)
        &+ random % delta
    )
  }
}

int(in: -2...10).run()
int(in: -2...10).run()
int(in: -2...10).run()
int(in: -2...10).run()

let roll = int(in: 1...6)

let bool = int(in: 0...1).map { $0 == 1 }
bool.run()
bool.run()
bool.run()
Bool.random()

func element<A>(of xs: [A]) -> Gen<A?> {

  return int(in: 0...(xs.count - 1)).map { idx in
    guard !xs.isEmpty else { return nil }
    return xs[idx]
  }
}

let move = element(of: Move.allCases)
  .map { $0! }
move.run()
move.run()
move.run()

Bool.random
//[Element].random

extension Gen {
//  func array(count: Int) -> Gen<[A]> {
//    return Gen<[A]> {
//      Array(repeating: (), count: count).map(self.run)
//    }
//  }

  func array(count: Gen<Int>) -> Gen<[A]> {
    return Gen<[A]> {
      Array(repeating: (), count: count.run()).map(self.run)
    }
//    return count.map { self.array(count: $0).run() }
  }
}

let rollPair = roll.array(count: .init { 2 })
rollPair.run()
rollPair.run()
rollPair.run()
rollPair.run()

let aFewMoves = move.array(count: int(in: 0...3))
aFewMoves.run()
aFewMoves.run()
aFewMoves.run()
aFewMoves.run()

// huwKun-1zyjxi-nyxseh

let chars = Array("abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789")

let alphanum = element(of: chars).map { $0! }

let passwordSegment = alphanum.array(count: .init { 6 })
  .map { $0.map(String.init).joined() }

let password = passwordSegment.array(count: .init { 3 })
  .map { $0.joined(separator: "-") }

password.run()
password.run()
password.run()
password.run()
