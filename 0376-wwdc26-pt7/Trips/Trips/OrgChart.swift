import Dependencies
import Foundation
import OSLog
import SQLiteData
import SwiftUI

@Table
struct Employee: Identifiable {
  let id: UUID
  var name: String
  var bossID: Employee.ID?
}

struct EmployeesView: View {
  @Fetch(EmployeeTreesRequest(ordering: .hierarchy)) fileprivate var employeeTrees = []
  @State private var ordering: Ordering = .hierarchy
  @Dependency(\.defaultDatabase) private var database

  enum Ordering: Hashable {
    case hierarchy
    case alphabetical
  }

  var body: some View {
    List(employeeTrees, children: \.children) { tree in
      HStack {
        Text(tree.name)
        Spacer()
        if tree.node.totalReports > 0 {
          Text("\(tree.node.totalReports) reports")
            .foregroundStyle(.secondary)
            .font(.caption)
        }
      }
      .swipeActions(edge: .trailing) {
        Button(role: .destructive) {
          deleteButtonTapped(id: tree.id)
        } label: {
          Label("Delete", systemImage: "trash")
        }
      }
    }
    .navigationTitle("Employees")
    .toolbar {
      ToolbarItem.init(placement: .title) {
        Picker("Ordering", selection: $ordering) {
          Text("Hierarchy").tag(Ordering.hierarchy)
          Text("A–Z").tag(Ordering.alphabetical)
        }
        .pickerStyle(.segmented)
      }
    }
    .task(id: ordering) {
      await withErrorReporting {
        _ = try await $employeeTrees.load(
          EmployeeTreesRequest(ordering: ordering),
          animation: .default
        )
      }
    }
  }

  private func deleteButtonTapped(id: Employee.ID) {
    withErrorReporting {
      try database.write { db in
        try Employee.find(id).delete().execute(db)
      }
    }
  }

  @Selection
  struct EmployeeNode: Identifiable {
    let id: Employee.ID
    let name: String
    let bossID: Employee.ID?
    let depth: Int
  }

  @Selection
  struct EmployeeRow: Identifiable {
    let id: Employee.ID
    let name: String
    let bossID: Employee.ID?
    let depth: Int
    let totalReports: Int
  }

  @Selection
  struct Report {
    let bossID: Employee.ID?
    let employeeID: Employee.ID
  }

  struct EmployeeTreesRequest: FetchKeyRequest {
    struct EmployeeTree: Identifiable {
      let node: EmployeeRow
      let reports: [EmployeeTree]
      var id: Employee.ID { node.id }
      var name: String { node.name }
      var children: [EmployeeTree]? { reports.isEmpty ? nil : reports }
    }
    let ordering: Ordering

    func fetch(_ db: Database) throws -> [EmployeeTree] {
      switch ordering {
      case .hierarchy:
        try fetchHierarchy(db)
      case .alphabetical:
        try fetchAlphabetical(db)
      }
    }

    private static var allReports: some PartialSelectStatement<Report> {
      Employee
        .where { $0.bossID.isNot(nil) }
        .select { Report.Columns(bossID: $0.bossID, employeeID: $0.id) }
        .union(
          all: true,
          Employee
            .join(Report.all) { $0.bossID.is($1.employeeID) }
            .select { employees, reports in
              Report.Columns(bossID: reports.bossID, employeeID: employees.id)
            }
        )
    }

    private func fetchAlphabetical(_ db: Database) throws -> [EmployeeTree] {
      try With {
        Self.allReports
      } query: {
        Employee
          .group(by: \.id)
          .order(by: \.name)
          .leftJoin(Report.all) { $1.bossID.is($0.id) }
          .select { employees, reports in
            EmployeeRow.Columns(
              id: employees.id,
              name: employees.name,
              bossID: employees.bossID,
              depth: 0,
              totalReports: reports.employeeID.count()
            )
          }
      }
      .fetchAll(db)
      .map { EmployeeTree(node: $0, reports: []) }
    }

    private func fetchHierarchy(_ db: Database) throws -> [EmployeeTree] {
      let cursor = try With {
        Employee
          .where { $0.bossID.is(nil) }
          .select {
            EmployeeNode.Columns(
              id: $0.id,
              name: $0.name,
              bossID: $0.bossID,
              depth: 0
            )
          }
          .union(
            all: true,
            Employee
              .join(EmployeeNode.all) { $0.bossID.is($1.id) }
              .select { employees, bosses in
                EmployeeNode.Columns(
                  id: employees.id,
                  name: employees.name,
                  bossID: employees.bossID,
                  depth: bosses.depth + 1
                )
              }
          )
        Self.allReports
      } query: {
        EmployeeNode
          .group(by: \.id)
          .order { ($0.depth.desc(), $0.name) }
          .leftJoin(Report.all) { $1.bossID.is($0.id) }
          .select { nodes, reports in
            EmployeeRow.Columns(
              id: nodes.id,
              name: nodes.name,
              bossID: nodes.bossID,
              depth: nodes.depth,
              totalReports: reports.employeeID.count()
            )
          }
      }
      .fetchCursor(db)

      var reportsByBossID: [Employee.ID: [EmployeeTree]] = [:]
      var roots: [EmployeeTree] = []
      while let node = try cursor.next() {
        let tree = EmployeeTree(
          node: node,
          reports: reportsByBossID.removeValue(forKey: node.id) ?? []
        )
        if let bossID = node.bossID {
          reportsByBossID[bossID, default: []].append(tree)
        } else {
          roots.append(tree)
        }
      }
      return roots
    }
  }
}

extension DependencyValues {
  fileprivate mutating func bootstrapEmployeesDatabase() throws {
    @Dependency(\.context) var context
    var configuration = Configuration()
    configuration.prepareDatabase { db in
      #if DEBUG
        db.trace(options: .profile) {
          guard
            !SyncEngine.isSynchronizing,
            !$0.expandedDescription.hasPrefix("--")
          else { return }
          switch context {
          case .live:
            logger.debug("\($0.expandedDescription)")
          case .preview:
            print("\($0.expandedDescription)")
          case .test:
            break
          }
        }
      #endif
    }
    let database = try SQLiteData.defaultDatabase(configuration: configuration)
    var migrator = DatabaseMigrator()
    #if DEBUG
      migrator.eraseDatabaseOnSchemaChange = true
    #endif
    migrator.registerMigration("Create 'employees' table") { db in
      try #sql(
        """
        CREATE TABLE "employees" (
          "id" TEXT PRIMARY KEY NOT NULL ON CONFLICT REPLACE DEFAULT (uuid()),
          "name" TEXT NOT NULL DEFAULT '',
          "bossID" TEXT REFERENCES "employees"("id") ON DELETE CASCADE
        ) STRICT
        """
      )
      .execute(db)
      try #sql(
        """
        CREATE INDEX "index_employees_on_bossID" ON "employees"("bossID")
        """
      )
      .execute(db)
    }
    try migrator.migrate(database)
    defaultDatabase = database
  }
}

private let logger = Logger(subsystem: "Trips", category: "EmployeesDatabase")

#Preview {
  let _ = prepareDependencies {
    try! $0.bootstrapEmployeesDatabase()
    try! $0.defaultDatabase.write { db in
      try db.seed {
        Employee(id: UUID(), name: "Gray", bossID: UUID(2))
        Employee(id: UUID(), name: "Indra", bossID: UUID(3))
        Employee(id: UUID(2), name: "Blair", bossID: UUID(1))
        Employee(id: UUID(3), name: "Casey", bossID: UUID(1))
        Employee(id: UUID(), name: "Harper", bossID: UUID(3))
        Employee(id: UUID(), name: "Finley", bossID: UUID(4))
        Employee(id: UUID(1), name: "Alex", bossID: nil)
        Employee(id: UUID(4), name: "Drew", bossID: UUID(2))
        Employee(id: UUID(), name: "Elliot", bossID: UUID(4))
      }
    }
  }

  NavigationStack {
    EmployeesView()
  }
}
