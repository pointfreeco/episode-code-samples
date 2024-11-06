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
    .task {
      let values = ValueObservation.tracking { db in
        try Player.fetchAll(db)
      }
      .values(in: databaseQueue)
      do {
        for try await players in values {
          self.players = players
        }
      } catch {
        reportIssue(error)
      }
    }
  }
}

struct PlayerDetailView: View {
  let databaseQueue: DatabaseQueue
  @State var player: Player
  @State var team: Team?
  @Environment(\.dismiss) var dismiss

  var body: some View {
    Form {
      Section {
        TextField("Name", text: $player.name)
        Button {
          player.isInjured.toggle()
        } label: {
          if player.isInjured {
            Text("\(Image(systemName: "stethoscope")) Injured")
              .foregroundStyle(.red)
          } else {
            Text("Not injured")
          }
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
    .toolbar {
      ToolbarItem(placement: .cancellationAction) {
        Button("Cancel") {
          dismiss()
        }
      }
      ToolbarItem(placement: .primaryAction) {
        Button("Save") {
          do {
            try databaseQueue.write { db in
              try player.save(db)
            }
            dismiss()
          } catch {
            reportIssue(error)
          }
        }
      }
    }
//    .onChange(of: player) {
//      do {
//        try databaseQueue.write { db in
//          try player.save(db)
//        }
//      } catch {
//        reportIssue(error)
//      }
//    }
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
  @Previewable @State var isPresented = true

  Button("Present") {
    isPresented = true
  }
  .sheet(isPresented: $isPresented) {
    NavigationStack {
      PlayerDetailView(
        databaseQueue: try! .appDatabase(),
        player: Player(
          name: "Blob",
          createdAt: Date(),
          teamID: 3
        )
      )
    }
    .presentationDetents([.medium])
  }
}
