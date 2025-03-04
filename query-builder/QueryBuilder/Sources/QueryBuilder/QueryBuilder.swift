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
  static func all() -> Select {
    Select(columns: [], from: Self.tableName)
  }
  static func count() -> Select {
    Select(columns: ["count(*)"], from: Self.tableName)
  }
}

struct Column {
  var name: String
}
