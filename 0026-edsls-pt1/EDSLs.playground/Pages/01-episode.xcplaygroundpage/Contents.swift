

/*
 SELECT id, name
 FROM users
 WHERE email = 'blob@pointfree.co'
 */


/*
<html>
  <body>
    <p>Hello World!</p>
  </body>
</html>
*/


/*
platform :ios, '8.0'
use_frameworks!

target 'MyApp' do
  pod 'NonEmpty', '~> 0.2'
  pod 'Overture', '~> 0.1'
end
*/

/*
github "pointfreeco/NonEmpty" ~> 0.2
github "pointfreeco/Overture" ~> 0.1
*/

//x * (4 + 5)
//(x * 4) + 5

enum Expr: Equatable {
  case int(Int)
  indirect case add(Expr, Expr)
  indirect case mul(Expr, Expr)
  case `var`
}

Expr.int(3)
Expr.add(.int(3), .int(4))
Expr.add(.add(.int(3), .int(4)), .int(5))
Expr.add(.add(.int(3), .int(4)), .add(.int(5), .int(6)))

Expr.add(
  .add(
    .int(3),
    .int(4)
  ),
  .add(
    .int(5),
    .int(6)
  )
)

extension Expr: ExpressibleByIntegerLiteral {
  init(integerLiteral value: Int) {
    self = .int(value)
  }
}

Expr.add(.add(3, 4), .add(5, 6))

func eval(_ expr: Expr, with value: Int) -> Int {
  switch expr {
  case let .int(value):
    return value
  case let .add(lhs, rhs):
    return eval(lhs, with: value) + eval(rhs, with: value)
  case let .mul(lhs, rhs):
    return eval(lhs, with: value) * eval(rhs, with: value)
  case .var:
    return value
  }
}

eval(.add(.add(3, 4), .add(5, 6)), with: 0)

eval(.mul(.add(3, 4), .add(5, 6)), with: 0)

eval(.mul(.add(.var, 4), .add(5, 6)), with: 3)

func print(_ expr: Expr) -> String {
  switch expr {
  case let .int(value):
    return "\(value)"
  case let .add(lhs, rhs):
    return "(\(print(lhs)) + \(print(rhs)))"
  case let .mul(lhs, rhs):
    return "(\(print(lhs)) * \(print(rhs)))"
  case .var:
    return "x"
  }
}

print(.add(.add(3, 4), .add(5, 6)))

print(.mul(.add(3, 4), .add(5, 6)))
// 3 + (4 * 5) + 6

print(.mul(.add(3, .var), .add(5, 6)))

print(.mul(.add(3, .var), .add(5, .var)))

func swap(_ expr: Expr) -> Expr {
  switch expr {
  case .int:
    return expr
  case let .add(lhs, rhs):
    return .mul(swap(lhs), swap(rhs))
  case let .mul(lhs, rhs):
    return .add(swap(lhs), swap(rhs))
  case .var:
    return expr
  }
}

print(swap(.mul(.add(3, 4), .add(5, 6))))

print(Expr.add(.mul(2, 3), .mul(2, 4)))
print(Expr.mul(2, .add(3, 4)))

func simplify(_ expr: Expr) -> Expr {
  switch expr {
  case .int:
    return expr
  case let .add(.mul(a, b), .mul(c, d)) where a == c:
    return .mul(a, .add(b, d))
  case .add:
    return expr
  case .mul:
    return expr
  case .var:
    return expr
  }
}

print(simplify(Expr.add(.mul(2, 3), .mul(2, 4))))

print(simplify(Expr.add(.mul(.var, 3), .mul(.var, 4))))
