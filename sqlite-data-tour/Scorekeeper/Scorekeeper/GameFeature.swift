import SQLiteData
import SwiftUI

@Observable class GameModel {
  let game: Game
  var isNewPlayerAlertPresented = false
  var newPlayerName = ""
  var sortAscending = false {
    didSet {
      Task { await reloadData() }
    }
  }
  @ObservationIgnored @FetchAll(Player.none) var players
  @ObservationIgnored @Dependency(\.defaultDatabase) var database

  init(game: Game) {
    self.game = game
  }

  func addPlayerButtonTapped() {
    newPlayerName = ""
    isNewPlayerAlertPresented = true
  }

  func decrementButtonTapped(for player: Player) {
    withErrorReporting {
      try database.write { db in
        try Player.find(player.id)
          .update { $0.score -= 1 }
          .execute(db)
      }
    }
  }

  func incrementButtonTapped(for player: Player) {
    withErrorReporting {
      try database.write { db in
        try Player.find(player.id)
          .update { $0.score += 1 }
          .execute(db)
      }
    }
  }

  func deletePlayers(at offsets: IndexSet) {
    withErrorReporting {
      try database.write { db in
        try Player.find(offsets.map { players[$0].id })
          .delete()
          .execute(db)
      }
    }
  }

  func toggleSortButtonTapped() {
    sortAscending.toggle()
  }

  func saveNewPlayerButtonTapped() {
    withErrorReporting {
      try database.write { db in
        try Player.insert {
          Player.Draft(gameID: game.id, name: newPlayerName)
        }
        .execute(db)
      }
    }
  }

  func task() async {
    await reloadData()
  }

  private func reloadData() async {
    await withErrorReporting {
      _ = try await $players.load(
        Player
          .where { $0.gameID.eq(game.id) }
          .order {
            if sortAscending {
              $0.score
            } else {
              $0.score.desc()
            }
          },
        animation: .default
      )
    }
  }
}

struct GameView: View {
  @State var model: GameModel

  init(game: Game) {
    _model = State(wrappedValue: GameModel(game: game))
  }

  var body: some View {
    Form {
      if !model.$players.isLoading, model.players.isEmpty {
        ContentUnavailableView {
          Label("No players", systemImage: "person.3.fill")
        } description: {
          Button("Add player") { model.addPlayerButtonTapped() }
        }
      } else {
        Section {
          ForEach(model.players) { player in
            HStack {
              Button {
                /*@START_MENU_TOKEN@*//*@PLACEHOLDER=Action@*//*@END_MENU_TOKEN@*/
              } label: {
                if let image = UIImage(data: /*@START_MENU_TOKEN@*//*@PLACEHOLDER=Image data@*/Data()/*@END_MENU_TOKEN@*/) {
                  Image(uiImage: image)
                    .resizable()
                    .scaledToFill()
                } else {
                  Rectangle()
                }
              }
              .foregroundStyle(Color.gray)
              .frame(width: 44, height: 44)
              .clipShape(Circle())
              .transaction { $0.animation = nil }

              Text(player.name)
              Spacer()
              Button {
                model.decrementButtonTapped(for: player)
              } label: {
                Image(systemName: "minus")
              }
              Text("\(player.score)")
              Button {
                model.incrementButtonTapped(for: player)
              } label: {
                Image(systemName: "plus")
              }
            }
            .buttonStyle(.borderless)
          }
          .onDelete { offsets in model.deletePlayers(at: offsets) }
        } header: {
          HStack {
            Text("Players")
            Spacer()
            Button {
              model.toggleSortButtonTapped()
            } label: {
              Image(systemName: model.sortAscending ? "arrow.down" : "arrow.up")
            }
          }
        }
      }
    }
    .navigationTitle(model.game.title)
    .toolbar {
      ToolbarItem {
        Button {
          /*@START_MENU_TOKEN@*//*@PLACEHOLDER=Action@*//*@END_MENU_TOKEN@*/
        } label: {
          Image(systemName: "square.and.arrow.up")
        }
      }
      ToolbarItem {
        Button {
          model.addPlayerButtonTapped()
        } label: {
          Image(systemName: "plus")
        }
        .alert("New player", isPresented: $model.isNewPlayerAlertPresented) {
          TextField("Player name", text: $model.newPlayerName)
          Button("Save") { model.saveNewPlayerButtonTapped() }
          Button("Cancel", role: .cancel) { }
        }
      }
    }
    .task {
      await model.task()
    }
  }
}

#Preview {
  let game = prepareDependencies {
    $0.defaultDatabase = try! appDatabase()
    try! $0.defaultDatabase.seed()
    return try! $0.defaultDatabase.read { db in
      try Game.fetchOne(db)!
    }
  }

  NavigationStack {
    GameView(game: game)
  }
}
