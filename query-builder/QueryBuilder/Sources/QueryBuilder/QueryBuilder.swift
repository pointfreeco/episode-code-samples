struct Select<From: Table>: QueryExpression {
  var columns: [String]
  var orders: [String] = []

  var queryString: String {
    var sql = """
    SELECT \(columns.isEmpty ? "*" : columns.joined(separator: ", "))
    FROM \(From.tableName)
    """
    if !orders.isEmpty {
      sql.append("\nORDER BY \(orders.joined(separator: ", "))")
    }
    return sql
  }

  func order(
    @OrderBuilder build orders: (From.Columns) -> [String]
  ) -> Select {
    Select(
      columns: columns,
      orders: self.orders + orders(From.columns)
    )
  }

  func order<each OrderingTerm: QueryExpression>(
    build orders: (From.Columns) -> (repeat each OrderingTerm)
  ) -> Select {
    let orders = orders(From.columns)
    var orderStrings: [String] = []
    for order in repeat each orders {
      orderStrings.append(order.queryString)
    }
    return Select(
      columns: columns,
      orders: self.orders + orderStrings
    )
  }
}

@resultBuilder
enum OrderBuilder {
  static func buildBlock(_ component: [String]) -> [String] {
    component
  }
  static func buildOptional(_ component: [String]?) -> [String] {
    component ?? []
  }
  static func buildEither(first component: [String]) -> [String] {
    component
  }
  static func buildEither(second component: [String]) -> [String] {
    component
  }
  static func buildExpression<each OrderingTerm: QueryExpression>(
    _ orders: (repeat each OrderingTerm)
  ) -> [String] {
    var orderStrings: [String] = []
    for order in repeat each orders {
      orderStrings.append(order.queryString)
    }
    return orderStrings
  }
}

protocol Table {
  associatedtype Columns
  static var tableName: String { get }
  static var columns: Columns { get }
}

extension Table {
  static func select(_ columns: String...) -> Select<Self> {
    Select(columns: columns)
  }
  static func select(_ columns: KeyPath<Columns, Column>...) -> Select<Self> {
    Select(
      columns: columns.map { Self.columns[keyPath: $0].name }
    )
  }
  static func select<each ResultColumn: QueryExpression>(
    //_: (any QueryExpression)...,
    _ columns: (Columns) -> (repeat each ResultColumn)
  ) -> Select<Self> {
    let columns = columns(Self.columns)
    var columnStrings: [String] = []
    for column in repeat each columns {
      columnStrings.append(column.queryString)
    }
    return Select(
      columns: columnStrings
    )
  }
  static func all() -> Select<Self> {
    Select(columns: [])
  }
  static func count() -> Select<Self> {
    Select(columns: ["count(*)"])
  }
}

struct Column: QueryExpression {
  var name: String
  var queryString: String { name }
}

extension QueryExpression {
  func count(distinct: Bool = false) -> some QueryExpression {
    CountFunction(base: self, isDistinct: distinct)
  }
  func avg() -> some QueryExpression {
    AvgFunction(base: self)
  }
  func groupConcat(separator: String? = nil) -> some QueryExpression {
    GroupConcatFunction(base: self, separator: separator)
  }
  func asc(nulls nullOrder: NullOrder? = nil) -> some QueryExpression {
    OrderingTerm(isAscending: true, nullOrder: nullOrder, base: self)
  }
  func desc(nulls nullOrder: NullOrder? = nil) -> some QueryExpression {
    OrderingTerm(isAscending: false, nullOrder: nullOrder, base: self)
  }
  func length() -> some QueryExpression {
    LengthFunction(base: self)
  }
  func collate(_ collation: Collation) -> some QueryExpression {
    Collate(collation: collation, base: self)
  }
}

enum Collation: String {
  case nocase = "NOCASE"
  case binary = "BINARY"
  case rtrim = "RTRIM"
}

struct Collate<Base: QueryExpression>: QueryExpression {
  let collation: Collation
  let base: Base
  var queryString: String {
    "\(base.queryString) COLLATE \(collation.rawValue)"
  }
}

enum NullOrder: String {
  case first = "FIRST"
  case last = "LAST"
}

struct OrderingTerm<Base: QueryExpression>: QueryExpression {
  let isAscending: Bool
  let nullOrder: NullOrder?
  let base: Base
  var queryString: String {
    var sql = "\(base.queryString)\(isAscending ? " ASC" : " DESC")"
    if let nullOrder {
      sql.append(" NULLS \(nullOrder.rawValue)")
    }
    return sql
  }
}

struct CountFunction<Base: QueryExpression>: QueryExpression {
  let base: Base
  let isDistinct: Bool
  var queryString: String {
    "count(\(isDistinct ? "DISTINCT " : "")\(base.queryString))"
  }
}

struct AvgFunction<Base: QueryExpression>: QueryExpression {
  let base: Base
  var queryString: String {
    "avg(\(base.queryString))"
  }
}

struct LengthFunction<Base: QueryExpression>: QueryExpression {
  let base: Base
  var queryString: String {
    "length(\(base.queryString))"
  }
}

struct GroupConcatFunction<Base: QueryExpression>: QueryExpression {
  let base: Base
  let separator: String?
  var queryString: String {
    "group_concat(\(base.queryString)\(separator.map { ", '\($0)'" } ?? ""))"
  }
}

protocol QueryExpression {
  var queryString: String { get }
}
