import SQLiteData
import SwiftUI

struct GamesView: View {
  @FetchAll(animation: .default) var games: [Game]
  @State var isNewGameAlertPresented = false
  @State var newGameTitle = ""
  @Dependency(\.defaultDatabase) var database

  var body: some View {
    List {
      ForEach(games) { game in
        NavigationLink {
          GameView(game: game)
        } label: {
          Text(game.title)
            .font(.headline)
        }
      }
      .onDelete { offsets in
        withErrorReporting {
          try database.write { db in
            try Game.find(offsets.map { games[$0].id })
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
