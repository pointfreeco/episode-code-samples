import CustomDump
import DependenciesTestSupport
import Foundation
import SQLiteData
import Testing

@testable import Scorekeeper

extension BaseSuite {
  @Suite(
    .dependencies {
      try $0.defaultDatabase.write { db in
        try db.seed {
          Game.Draft(id: UUID(-1), title: "Family gin rummy")
          Player.Draft(id: UUID(-1), gameID: UUID(-1), name: "Blob", score: 1)
          Player.Draft(id: UUID(-2), gameID: UUID(-1), name: "Blob Sr", score: 3)
          Player.Draft(id: UUID(-3), gameID: UUID(-1), name: "Blob Jr", score: 2)

          Game.Draft(id: UUID(-2), title: "Weekly poker night")
          Player.Draft(id: UUID(-4), gameID: UUID(-2), name: "Brandon", score: 0)
          Player.Draft(id: UUID(-5), gameID: UUID(-2), name: "Stephen", score: 0)

          Game.Draft(id: UUID(-3), title: "Mahjong with grandma")

        }
      }
    }
  )
  struct GameFeatureTests {
    @Dependency(\.defaultDatabase) var database

    @Test func basics() async throws {
      let game = try await #require(
        database.read { db in
          try Game.find(UUID(-1)).fetchOne(db)
        }
      )
      let model = GameModel(game: game)
      await model.task()
      expectNoDifference(
        model.rows,
        [
          GameModel.Row(player: Player(id: UUID(-2), gameID: UUID(-1), name: "Blob Sr", score: 3)),
          GameModel.Row(player: Player(id: UUID(-3), gameID: UUID(-1), name: "Blob Jr", score: 2)),
          GameModel.Row(player: Player(id: UUID(-1), gameID: UUID(-1), name: "Blob", score: 1)),
        ]
      )
    }

    @Test func addPlayer() async throws {
      let game = try await #require(
        database.read { db in
          try Game.find(UUID(-1)).fetchOne(db)
        }
      )
      let model = GameModel(game: game)
      await model.task()

      model.addPlayerButtonTapped()
      model.newPlayerName = "Blob Esq"
      model.saveNewPlayerButtonTapped()
      try await model.$rows.load()
      expectNoDifference(
        model.rows,
        [
          GameModel.Row(player: Player(id: UUID(-2), gameID: UUID(-1), name: "Blob Sr", score: 3)),
          GameModel.Row(player: Player(id: UUID(-3), gameID: UUID(-1), name: "Blob Jr", score: 2)),
          GameModel.Row(player: Player(id: UUID(-1), gameID: UUID(-1), name: "Blob", score: 1)),
          GameModel.Row(player: Player(id: UUID(0), gameID: UUID(-1), name: "Blob Esq", score: 0)),
        ]
      )
    }
  }
}
