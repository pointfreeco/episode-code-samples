import GRDB
import IssueReporting
import SwiftUI

struct ContentView: View {
  let databaseQueue: DatabaseQueue
  @State var players: [Player] = []

  var body: some View {
    Form {
      ForEach(players, id: \.id) { player in
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
