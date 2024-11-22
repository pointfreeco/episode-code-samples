import GRDB
import IssueReporting
import SwiftUI

struct ContentView: View {
  let databaseQueue: DatabaseQueue
  @State var players: [Player] = []
  @State var playerDetail: Player?

  var body: some View {
    Form {
      ForEach(players) { player in
        Button {
          playerDetail = player
        } label: {
          HStack {
            Text(player.name)
            if player.isInjured {
              Spacer()
              Image(systemName: "stethoscope")
                .foregroundStyle(.red)
            }
          }
        }
      }
    }
    .sheet(item: $playerDetail) { player in
      NavigationStack {
        PlayerDetailView(
          databaseQueue: databaseQueue,
          player: player
        )
      }
      .presentationDetents([.medium])
    }
    .onAppear {
      do {
        players = try databaseQueue.read { db in
          try Player.fetchAll(db)
        }
      } catch {
        reportIssue(error)
      }
    }
  }
}

struct PlayerDetailView: View {
  let databaseQueue: DatabaseQueue
  let player: Player
  @State var team: Team?

  var body: some View {
    Form {
      Section {
        Text(player.name)
        if player.isInjured {
          Text("\(Image(systemName: "stethoscope")) Injured")
            .foregroundStyle(.red)
        } else {
          Text("Not injured")
        }
      } header: {
        Text("Details")
      }

      Section {
        if let team {
          Text(team.name)
        } else {
          Text("No team")
            .italic()
        }
      } header: {
        Text("Team")
      }
    }
    .navigationTitle("Player")
    .onAppear {
      do {
        guard let teamID = player.teamID
        else { return }
        team = try databaseQueue.read { db in
          try Team.fetchOne(db, id: teamID)
        }
      } catch {
        reportIssue(error)
      }
    }
  }
}

#Preview {
  let databaseQueue = try! DatabaseQueue.appDatabase()
  try! databaseQueue.write { db in
    for index in 1...10 {
      _ = try! Player(
        name: "Blob \(index)",
        createdAt: Date(),
        isInjured: index.isMultiple(of: 3)
      ).inserted(db)
    }
  }
  return ContentView(databaseQueue: databaseQueue)
}

#Preview("Player detail") {
  PlayerDetailView(
    databaseQueue: try! .appDatabase(),
    player: Player(
      name: "Blob",
      createdAt: Date(),
      teamID: 3
    )
  )
}
