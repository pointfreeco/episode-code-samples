import CustomDump
import DependenciesTestSupport
import Foundation
import SQLiteData
import Testing

@testable import Scorekeeper

struct GameFeatureTests {
  @Dependency(\.defaultDatabase) var database
  @Test(
    .dependencies {
      try $0.bootstrapDatabase()
      try $0.defaultDatabase.write { db in
        try db.seed {
          Game.Draft(id: UUID(0), title: "Family gin rummy")
          Game.Draft(id: UUID(1), title: "Weekly poker night")
          Game.Draft(id: UUID(2), title: "Mahjong with grandma")

          Player.Draft(id: UUID(0), gameID: UUID(0), name: "Blob", score: 1)
          Player.Draft(id: UUID(1), gameID: UUID(0), name: "Blob Sr", score: 3)
          Player.Draft(id: UUID(2), gameID: UUID(0), name: "Blob Jr", score: 2)
        }
      }
    }
  ) func basics() async throws {
    let game = try await #require(
      database.read { db in
        try Game.find(UUID(0)).fetchOne(db)
      }
    )
    let model = GameModel(game: game)
    await model.task()
    expectNoDifference(
      model.rows,
      [
        GameModel.Row(player: Player(id: UUID(1), gameID: UUID(0), name: "Blob Sr", score: 3)),
        GameModel.Row(player: Player(id: UUID(2), gameID: UUID(0), name: "Blob Jr", score: 2)),
        GameModel.Row(player: Player(id: UUID(0), gameID: UUID(0), name: "Blob", score: 1)),
      ]
    )
  }
}
