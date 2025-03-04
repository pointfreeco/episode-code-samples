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

  func order<each OrderingTerm: QueryExpression>(
    _ orders: (From.Columns) -> (repeat each OrderingTerm)
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

  func count(distinct: Bool = false) -> some QueryExpression {
    CountFunction(column: self, isDistinct: distinct)
  }
  func avg() -> some QueryExpression {
    AvgFunction(column: self)
  }
  func groupConcat(separator: String? = nil) -> some QueryExpression {
    GroupConcatFunction(column: self, separator: separator)
  }
  func asc(nulls nullOrder: NullOrder? = nil) -> some QueryExpression {
    OrderingTerm(isAscending: true, nullOrder: nullOrder, column: self)
  }
  func desc(nulls nullOrder: NullOrder? = nil) -> some QueryExpression {
    OrderingTerm(isAscending: false, nullOrder: nullOrder, column: self)
  }
}

enum NullOrder: String {
  case first = "FIRST"
  case last = "LAST"
}

struct OrderingTerm: QueryExpression {
  let isAscending: Bool
  let nullOrder: NullOrder?
  let column: Column
  var queryString: String {
    var sql = "\(column.queryString)\(isAscending ? " ASC" : " DESC")"
    if let nullOrder {
      sql.append(" NULLS \(nullOrder.rawValue)")
    }
    return sql
  }
}

struct CountFunction: QueryExpression {
  let column: Column
  let isDistinct: Bool
  var queryString: String {
    "count(\(isDistinct ? "DISTINCT " : "")\(column.queryString))"
  }
}

struct AvgFunction: QueryExpression {
  let column: Column
  var queryString: String {
    "avg(\(column.queryString))"
  }
}

struct GroupConcatFunction: QueryExpression {
  let column: Column
  let separator: String?
  var queryString: String {
    "group_concat(\(column.queryString)\(separator.map { ", '\($0)'" } ?? ""))"
  }
}

protocol QueryExpression {
  var queryString: String { get }
}
