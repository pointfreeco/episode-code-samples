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
    let model: GameModel
    @Dependency(\.defaultDatabase) var database

    init() async throws {
      let game = try await #require(
        _database.wrappedValue.read { db in
          try Game.find(UUID(-1)).fetchOne(db)
        }
      )
      model = GameModel(game: game)
      await model.task()
    }

    @Test func basics() async throws {
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
      await expectDifference(model.rows) {
        model.addPlayerButtonTapped()
        model.newPlayerName = "Blob Esq"
        model.saveNewPlayerButtonTapped()
        try await model.$rows.load()
      } changes: { rows in
        rows.append(
          GameModel.Row(player: Player(id: UUID(0), gameID: UUID(-1), name: "Blob Esq", score: 0))
        )
      }
    }

    @Test func incrementPlayerScore() async throws {
      await expectDifference(model.rows) {
        model.incrementButtonTapped(for: model.rows[0].player)
        try await model.$rows.load()
      } changes: { rows in
        rows[0].player.score = 4
      }
    }

    @Test func incrementPlayerScoreSortsToTop() async throws {
      let blobJr = model.rows[1].player
      await expectDifference(model.rows) {
        model.incrementButtonTapped(for: blobJr)
        model.incrementButtonTapped(for: blobJr)
        try await model.$rows.load()
      } changes: { rows in
        rows[1].player.score = 4
        let blobJr = rows.remove(at: 1)
        rows.insert(blobJr, at: 0)
      }
    }

    @Test func deletePlayerRemovesRow() async throws {
      await expectDifference(model.rows) {
        model.deletePlayers(at: [0])
        try await model.$rows.load()
      } changes: { rows in
        rows.remove(at: 0)
      }
    }
  }
}
