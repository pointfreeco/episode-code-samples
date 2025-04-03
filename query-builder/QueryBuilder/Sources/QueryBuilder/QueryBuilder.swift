struct Select<From: Table, each Join: Table>: QueryExpression {
  var columns: [String]
  var groups: [String] = []
  var havings: [String] = []
  var joins: [String] = []
  var orders: [String] = []
  var wheres: [String] = []

  var queryString: String {
    var sql = """
    SELECT \(columns.isEmpty ? "*" : columns.joined(separator: ", "))
    FROM \(From.tableName)
    """
    if !joins.isEmpty {
      sql.append("\n\(joins.joined(separator: "\n"))")
    }
    if !wheres.isEmpty {
      sql.append("\nWHERE \(wheres.joined(separator: " AND "))")
    }
    if !groups.isEmpty {
      sql.append("\nGROUP BY \(groups.joined(separator: ", "))")
    }
    if !havings.isEmpty {
      sql.append("\nHAVING \(havings.joined(separator: " AND "))")
    }
    if !orders.isEmpty {
      sql.append("\nORDER BY \(orders.joined(separator: ", "))")
    }
    return sql
  }

  func order(
    @OrderBuilder build orders: (From.Columns, repeat (each Join).Columns) -> [String]
  ) -> Select {
    Select(
      columns: columns,
      groups: groups,
      havings: havings,
      joins: joins,
      orders: self.orders + orders(From.columns, repeat (each Join).columns),
      wheres: wheres
    )
  }

//  func order<each OrderingTerm: QueryExpression>(
//    build orders: (From.Columns) -> (repeat each OrderingTerm)
//  ) -> Select {
//    let orders = orders(From.columns)
//    var orderStrings: [String] = []
//    for order in repeat each orders {
//      orderStrings.append(order.queryString)
//    }
//    return Select(
//      columns: columns,
//      joins: joins,
//      orders: self.orders + orderStrings,
//      wheres: wheres
//    )
//  }

  func `where`(
    _ predicate: (From.Columns, repeat (each Join).Columns) -> some QueryExpression<Bool>
  ) -> Select {
    Select(
      columns: columns,
      groups: groups,
      havings: havings,
      joins: joins,
      orders: orders,
      wheres: wheres + [
        predicate(From.columns, repeat (each Join).columns).queryString
      ]
    )
  }

  func join<Other: Table>(
    _ other: Other.Type,
    on constraint: (From.Columns, Other.Columns) -> some QueryExpression<Bool>
  ) -> Select<From, Other> {
    Select<From, Other>(
      columns: columns,
      groups: groups,
      havings: havings,
      joins: joins + [
        """
        JOIN \(other.tableName)
        ON \(constraint(From.columns, Other.columns).queryString)
        """
      ],
      orders: orders,
      wheres: wheres
    )
  }

  func leftJoin<Other: Table>(
    _ other: Other.Type,
    on constraint: (From.Columns, Other.Columns) -> some QueryExpression<Bool>
  ) -> Select<From, Other> {
    Select<From, Other>(
      columns: columns,
      groups: groups,
      havings: havings,
      joins: joins + [
        """
        LEFT JOIN \(other.tableName)
        ON \(constraint(From.columns, Other.columns).queryString)
        """
      ],
      orders: orders,
      wheres: wheres
    )
  }

  func select<each ResultColumn: QueryExpression>(
    _ columns: (From.Columns, repeat (each Join).Columns) -> (repeat each ResultColumn)
  ) -> Select {
    let columns = columns(From.columns, repeat (each Join).columns)
    var columnStrings: [String] = []
    for column in repeat each columns {
      columnStrings.append(column.queryString)
    }
    return Select(
      columns: self.columns + columnStrings,
      groups: groups,
      havings: havings,
      joins: joins,
      orders: orders,
      wheres: wheres
    )
  }

  // GROUP BY reminders.isCompleted, reminders.priority
  func group<each Grouping: QueryExpression>(
    by groups: (From.Columns, repeat (each Join).Columns) -> (repeat each Grouping)
  ) -> Select {
    let groups = groups(From.columns, repeat (each Join).columns)
    var groupStrings: [String] = []
    for group in repeat each groups {
      groupStrings.append(group.queryString)
    }
    return Select(
      columns: columns,
      groups: self.groups + groupStrings,
      havings: havings,
      joins: joins,
      orders: orders,
      wheres: wheres
    )
  }

  func having(
    _ predicate: (From.Columns, repeat (each Join).Columns) -> some QueryExpression<Bool>
  ) -> Select {
    Select(
      columns: columns,
      groups: groups,
      havings: havings + [
        predicate(From.columns, repeat (each Join).columns).queryString
      ],
      joins: joins,
      orders: orders,
      wheres: wheres
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
//  static func select(_ columns: KeyPath<Columns, Column>...) -> Select<Self> {
//    Select(
//      columns: columns.map { Self.columns[keyPath: $0].name }
//    )
//  }
  static func select<each ResultColumn: QueryExpression>(
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

struct Column<QueryValue>: QueryExpression {
  var name: String
  var table: String
  var queryString: String { "\(table).\(name)" }
}

extension QueryExpression {
  func count(distinct: Bool = false) -> some QueryExpression<Int> {
    CountFunction(base: self, isDistinct: distinct)
  }
  func avg() -> some QueryExpression {
    AvgFunction(base: self)
  }
  func asc(nulls nullOrder: NullOrder? = nil) -> some QueryExpression {
    OrderingTerm(isAscending: true, nullOrder: nullOrder, base: self)
  }
  func desc(nulls nullOrder: NullOrder? = nil) -> some QueryExpression {
    OrderingTerm(isAscending: false, nullOrder: nullOrder, base: self)
  }
}

extension QueryExpression<String> {
  func groupConcat(separator: String? = nil) -> some QueryExpression {
    GroupConcatFunction(base: self, separator: separator)
  }
  func length() -> some QueryExpression<Int> {
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
  typealias QueryValue = Int
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
  typealias QueryValue = Int
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

protocol QueryExpression<QueryValue> {
  associatedtype QueryValue = ()
  var queryString: String { get }
}

prefix func ! (
  expression: some QueryExpression<Bool>
) -> some QueryExpression<Bool> {
  Negate(base: expression)
}

struct Negate<Base: QueryExpression<Bool>>: QueryExpression {
  typealias QueryValue = Bool
  let base: Base
  var queryString: String {
    "NOT (\(base.queryString))"
  }
}

func == <T> (lhs: some QueryExpression<T>, rhs: some QueryExpression<T>) -> some QueryExpression<Bool> {
  Equals(lhs: lhs, rhs: rhs)
}

func == <T> (lhs: some QueryExpression<T?>, rhs: some QueryExpression<T>) -> some QueryExpression<Bool> {
  Equals(lhs: lhs, rhs: rhs)
}

func == <T> (lhs: some QueryExpression<T>, rhs: some QueryExpression<T?>) -> some QueryExpression<Bool> {
  Equals(lhs: lhs, rhs: rhs)
}

struct Equals<LHS: QueryExpression, RHS: QueryExpression>: QueryExpression {
  typealias QueryValue = Bool
  let lhs: LHS
  let rhs: RHS
  var queryString: String {
    "(\(lhs.queryString) = \(rhs.queryString))"
  }
}

extension Int: QueryExpression {
  typealias QueryValue = Self
  var queryString: String { "\(self)" }
}

func || (lhs: some QueryExpression<Bool>, rhs: some QueryExpression<Bool>) -> some QueryExpression<Bool> {
  Or(lhs: lhs, rhs: rhs)
}

struct Or<LHS: QueryExpression, RHS: QueryExpression>: QueryExpression {
  typealias QueryValue = Bool
  let lhs: LHS
  let rhs: RHS
  var queryString: String {
    "(\(lhs.queryString) OR \(rhs.queryString))"
  }
}

func && (lhs: some QueryExpression<Bool>, rhs: some QueryExpression<Bool>) -> some QueryExpression<Bool> {
  And(lhs: lhs, rhs: rhs)
}

struct And<LHS: QueryExpression, RHS: QueryExpression>: QueryExpression {
  typealias QueryValue = Bool
  let lhs: LHS
  let rhs: RHS
  var queryString: String {
    "(\(lhs.queryString) AND \(rhs.queryString))"
  }
}
