struct Select {
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
  static var tableName: String { get }
}

extension Table {
  static func select(_ columns: String...) -> Select {
    Select(columns: columns, from: Self.tableName)
  }
  static func all() -> Select {
    Select(columns: [], from: Self.tableName)
  }
  static func count() -> Select {
    Select(columns: ["count(*)"], from: Self.tableName)
  }
}
