struct Select: QueryExpression {
  var columns: [String]
  var from: String

  var queryString: String {
    """
    SELECT \(columns.isEmpty ? "*" : columns.joined(separator: ", "))
    FROM \(from)
    """
  }
}

protocol Table {
  associatedtype Columns
  static var tableName: String { get }
  static var columns: Columns { get }
}

extension Table {
  static func select(_ columns: String...) -> Select {
    Select(columns: columns, from: Self.tableName)
  }
  static func select(_ columns: KeyPath<Columns, Column>...) -> Select {
    Select(
      columns: columns.map { Self.columns[keyPath: $0].name },
      from: tableName
    )
  }
  static func select<each ResultColumn: QueryExpression>(
    //_: (any QueryExpression)...,
    _ columns: (Columns) -> (repeat each ResultColumn)
  ) -> Select {
    let columns = columns(Self.columns)
    var columnStrings: [String] = []
    for column in repeat each columns {
      columnStrings.append(column.queryString)
    }
    return Select(
      columns: columnStrings,
      from: tableName
    )
  }
  static func all() -> Select {
    Select(columns: [], from: Self.tableName)
  }
  static func count() -> Select {
    Select(columns: ["count(*)"], from: Self.tableName)
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
