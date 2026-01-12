import SQLiteData
import SwiftUI

struct GamesView: View {
  @Selection struct Row {
    let game: Game
    let playerCount: Int
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
            Text(row.game.title)
              .font(.headline)
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
            .select { Row.Columns(game: $0, playerCount: $1.count()) },
          animation: .default
        )
        .task
      }
    }
  }
}

#Preview {
  let _ = prepareDependencies {
    try! $0.bootstrapDatabase()
    try! $0.defaultDatabase.seed()
  }
  NavigationStack {
    GamesView()
  }
}
