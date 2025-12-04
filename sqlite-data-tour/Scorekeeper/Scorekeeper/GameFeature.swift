import PhotosUI
import SQLiteData
import SwiftUI

@Observable class GameModel {
  let game: Game
  var isNewPlayerAlertPresented = false
  var isPlayerPhotoPickerPresented = false
  var playerPhotoPickerPresented: Player?
  var newPlayerName = ""
  var photosPickerItem: PhotosPickerItem? {
    didSet {
      updatePlayerImageTask?.cancel()
      updatePlayerImageTask = Task { await updatePlayerImage() }
    }
  }
  var sortAscending = false {
    didSet {
      Task { await reloadData() }
    }
  }
  var updatePlayerImageTask: Task<Void, Never>?
  @ObservationIgnored @FetchAll var rows: [Row]
  @ObservationIgnored @Dependency(\.defaultDatabase) var database

  @Selection struct Row {
    let player: Player
    let imageData: Data?
  }

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
        try Player.find(offsets.map { rows[$0].player.id })
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

  func photoButtonTapped(for player: Player) {
    isPlayerPhotoPickerPresented = true
    playerPhotoPickerPresented = player
  }

  private func reloadData() async {
    await withErrorReporting {
      _ = try await $rows.load(
        Player
          .where { $0.gameID.eq(game.id) }
          .order {
            if sortAscending {
              $0.score
            } else {
              $0.score.desc()
            }
          }
          .leftJoin(PlayerAsset.all) { $0.id.eq($1.playerID) }
          .select { Row.Columns(player: $0, imageData: $1.imageData) },
        animation: .default
      )
    }
  }

  private func updatePlayerImage() async {
    guard let photosPickerItem, let playerPhotoPickerPresented else { return }
    do {
      guard let imageData = try await photosPickerItem.loadTransferable(type: Data.self)
      else { return }
      try await database.write { db in
        try PlayerAsset.upsert {
          PlayerAsset(
            playerID: playerPhotoPickerPresented.id,
            imageData: imageData
          )
        }
        .execute(db)
      }
    } catch {
      // TODO: Show error to user
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
      if !model.$rows.isLoading, model.rows.isEmpty {
        ContentUnavailableView {
          Label("No players", systemImage: "person.3.fill")
        } description: {
          Button("Add player") { model.addPlayerButtonTapped() }
        }
      } else {
        Section {
          ForEach(model.rows, id: \.player.id) { row in
            HStack {
              Button {
                model.photoButtonTapped(for: row.player)
              } label: {
                if
                  let imageData = row.imageData,
                  let image = UIImage(data: imageData) {
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

              Text(row.player.name)
              Spacer()
              Button {
                model.decrementButtonTapped(for: row.player)
              } label: {
                Image(systemName: "minus")
              }
              Text("\(row.player.score)")
              Button {
                model.incrementButtonTapped(for: row.player)
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
    .photosPicker(
      isPresented: $model.isPlayerPhotoPickerPresented,
      selection: $model.photosPickerItem
    )
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
