import Benchmark
import Foundation
import Parsing

#if canImport(Darwin)
  import Darwin.C
#elseif canImport(Glibc)
  import Glibc
#endif

// MARK: - Parsers

private let additionAndSubtraction = InfixOperator(
  OneOfMany(
    "+".utf8.map { (+) },
    "-".utf8.map { (-) }
  ),
  associativity: .left,
  lowerThan: multiplicationAndDivision
)

private let multiplicationAndDivision = InfixOperator(
  OneOfMany(
    "*".utf8.map { (*) },
    "/".utf8.map { (/) }
  ),
  associativity: .left,
  lowerThan: exponent
)

private let exponent = InfixOperator(
  "^".utf8.map { pow },
  associativity: .left,
  lowerThan: factor
)

private let factor: AnyParser<Substring.UTF8View, Double> = "(".utf8
  .take(Lazy { additionAndSubtraction })
  .skip(")".utf8)
  .orElse(Double.parser())
  .eraseToAnyParser()

// MARK: -

public struct InfixOperator<Operator, Operand>: Parser
where
  Operator: Parser,
  Operand: Parser,
  Operator.Input == Operand.Input,
  Operator.Output == (Operand.Output, Operand.Output) -> Operand.Output
{
  public let `associativity`: Associativity
  public let operand: Operand
  public let `operator`: Operator

  @inlinable
  public init(
    _ operator: Operator,
    associativity: Associativity,
    lowerThan operand: Operand  // Should this be called `precedes operand:`?
  ) {
    self.associativity = `associativity`
    self.operand = operand
    self.operator = `operator`
  }

  @inlinable
  public func parse(_ input: inout Operand.Input) -> Operand.Output? {
    switch associativity {
    case .left:
      guard var lhs = self.operand.parse(&input) else { return nil }
      var rest = input
      while let operation = self.operator.parse(&input),
        let rhs = self.operand.parse(&input)
      {
        rest = input
        lhs = operation(lhs, rhs)
      }
      input = rest
      return lhs
    case .right:
      var lhs: [(Operand.Output, Operator.Output)] = []
      while true {
        guard let rhs = self.operand.parse(&input)
        else { break }
        guard let operation = self.operator.parse(&input)
        else {
          return lhs.reversed().reduce(rhs) { rhs, pair in
            let (lhs, operation) = pair
            return operation(lhs, rhs)
          }
        }
        lhs.append((rhs, operation))
      }
      return nil
    }
  }
}

public enum Associativity {
  case left
  case right
}

// MARK: - Suite

let arithmeticSuite = BenchmarkSuite(name: "Arithmetic") { suite in
  let arithmetic = "1+2*3/4-5^2"

  suite.benchmark("Parser") {
    var arithmetic = arithmetic[...].utf8
    precondition(additionAndSubtraction.parse(&arithmetic) == -22.5)
  }
}
