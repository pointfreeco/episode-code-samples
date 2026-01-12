import Dependencies
import Foundation
import SQLiteData

@Table struct Game: Identifiable {
  let id: UUID
  var title = ""
}

@Table struct Player: Identifiable {
  let id: UUID
  let gameID: Game.ID
  var name = ""
  var score = 0
}

@Table struct PlayerAsset: Identifiable {
  @Column(primaryKey: true)
  let playerID: Player.ID
  var imageData: Data
  var id: Player.ID { playerID }
}

func appDatabase() throws -> any DatabaseWriter {
  var configuration = Configuration()
  configuration.prepareDatabase { db in
    try db.attachMetadatabase()
    #if DEBUG
      db.trace {
        print($0.expandedDescription)
      }
    #endif
  }
  let database = try SQLiteData.defaultDatabase(configuration: configuration)
  var migrator = DatabaseMigrator()
  #if DEBUG
    migrator.eraseDatabaseOnSchemaChange = true
  #endif
  migrator.registerMigration("Create 'games' and 'players' tables") { db in
    try #sql(
      """
      CREATE TABLE "games" (
        "id" TEXT PRIMARY KEY NOT NULL ON CONFLICT REPLACE DEFAULT (uuid()),
        "title" TEXT NOT NULL DEFAULT ''
      ) STRICT
      """
    )
    .execute(db)

    try #sql(
      """
      CREATE TABLE "players" (
        "id" TEXT PRIMARY KEY NOT NULL ON CONFLICT REPLACE DEFAULT (uuid()),
        "gameID" TEXT NOT NULL REFERENCES "games"("id") ON DELETE CASCADE,
        "name" TEXT NOT NULL DEFAULT '',
        "score" INTEGER NOT NULL DEFAULT 0
      ) STRICT
      """
    )
    .execute(db)

    try #sql(
      """
      CREATE INDEX "index_players_on_gameID" ON "players"("gameID")
      """
    )
    .execute(db)
  }

  migrator.registerMigration("Create 'playerAssets' table") { db in
    try #sql(
      """
      CREATE TABLE "playerAssets" (
        "playerID" TEXT PRIMARY KEY NOT NULL REFERENCES "players"("id") ON DELETE CASCADE,
        "imageData" BLOB NOT NULL
      ) STRICT
      """
    )
    .execute(db)
  }

  try migrator.migrate(database)
  return database
}

extension DependencyValues {
  mutating func bootstrapDatabase() throws {
    defaultDatabase = try appDatabase()
    defaultSyncEngine = try SyncEngine(
      for: defaultDatabase,
      tables: Game.self, Player.self, PlayerAsset.self,
    )
  }
}

extension DatabaseWriter {
  func seed() throws {
    try write { db in
      try db.seed {
        Game.Draft(id: UUID(1), title: "Family gin rummy")
        Game.Draft(title: "Weekly poker night")
        Game.Draft(title: "Mahjong with grandma")

        Player.Draft(gameID: UUID(1), name: "Blob", score: 40)
        Player.Draft(gameID: UUID(1), name: "Blob Sr", score: 100)
        Player.Draft(gameID: UUID(1), name: "Blob Jr", score: 67)
      }
    }
  }
}

