import SQLiteData
import SwiftUI

struct GamesView: View {
  @Selection struct Row {
    var game: Game
    var isShared: Bool
    var playerCount: Int
  }

  @FetchAll var rows: [Row]
  @State var isNewGameAlertPresented = false
  @State var newGameTitle = ""
  @Dependency(\.defaultDatabase) var database

  var body: some View {
    List {
      ForEach(rows, id: \.game.id) { row in
        NavigationLink {
          GameView(game: row.game)
        } label: {
          HStack {
            VStack(alignment: .leading) {
              Text(row.game.title)
                .font(.headline)
              if row.isShared {
                Text("\(Image(systemName: "network")) Shared")
                  .foregroundStyle(.gray)
              }
            }
            Spacer()
            Text("\(row.playerCount)")
            Image(systemName: "person.2.fill")
              .foregroundStyle(.gray)
          }
        }
      }
      .onDelete { offsets in
        withErrorReporting {
          try database.write { db in
            try Game.find(offsets.map { rows[$0].game.id })
              .delete()
              .execute(db)
          }
        }
      }
    }
    .navigationTitle("Games")
    .toolbar {
      ToolbarItem(placement: .topBarTrailing) {
        Button {
          newGameTitle = ""
          isNewGameAlertPresented = true
        } label: {
          Label("Add Game", systemImage: "plus")
        }
      }
    }
    .alert("Create new game", isPresented: $isNewGameAlertPresented) {
      TextField("Game title", text: $newGameTitle)
      Button("Save") {
        withErrorReporting {
          try database.write { db in
            try Game
              .insert { Game.Draft(title: newGameTitle) }
              .execute(db)
          }
        }
      }
      Button(role: .cancel) {}
    }
    .task {
      await withErrorReporting {
        try await $rows.load(
          Game
            .group(by: \.id)
            .leftJoin(Player.all) { $0.id.eq($1.gameID) }
            .order { $1.count().desc() }
            .leftJoin(SyncMetadata.all) { $0.syncMetadataID.eq($2.id) }
            .select {
              Row.Columns(
                game: $0,
                isShared: $2.isShared.ifnull(false),
                playerCount: $1.count()
              )
            },
          animation: .default
        )
        .task
      }
    }
  }
}

#Preview {
  @Previewable @Dependency(\.defaultDatabase) var database
  @Previewable @Dependency(\.defaultSyncEngine) var syncEngine
  let _ = prepareDependencies {
    try! $0.bootstrapDatabase()
    try! $0.defaultDatabase.seed()
  }
  NavigationStack {
    GamesView()
  }
  .task {
    let game = try! await database.read { db in
      try Game.fetchOne(db)!
    }
    try! await syncEngine.sendChanges()
    try! await syncEngine.share(record: game) { _ in
    }
  }
}
