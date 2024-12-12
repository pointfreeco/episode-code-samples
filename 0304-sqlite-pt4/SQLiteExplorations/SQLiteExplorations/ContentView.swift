import GRDB
import IssueReporting
import SwiftUI

struct ContentView: View {
  @Environment(\.databaseQueue) var databaseQueue
  @State var players: [Player] = []
  @State var playerDetail: Player?
  @State var order: Order = .created

  enum Order: String, CaseIterable {
    case created = "Created"
    case isInjured = "Injured?"
    case name = "Name"
    var orderingTerm: any SQLOrderingTerm & Sendable {
      switch self {
      case .created:
        Column("createdAt")
      case .isInjured:
        Column("isInjured").desc
      case .name:
        Column("Name")
      }
    }
  }

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
    .toolbar {
      ToolbarItem(placement: .primaryAction) {
        Picker(order.rawValue, selection: $order) {
          Section {
            ForEach(Order.allCases, id: \.self) { order in
              Text(order.rawValue)
                .tag(order)
            }
          } header: {
            Text("Sort by")
          }
        }
      }
    }
    .sheet(item: $playerDetail) { player in
      NavigationStack {
        PlayerDetailView(
          player: player
        )
      }
      .presentationDetents([.medium])
    }
    .task(id: order) {
      let values = ValueObservation.tracking { [orderingTerm = order.orderingTerm] db in
        try Player
          .order(orderingTerm)
          .fetchAll(db)
      }
      .values(in: databaseQueue)
      do {
        for try await players in values {
          withAnimation {
            self.players = players
          }
        }
      } catch {
        reportIssue(error)
      }
    }
  }
}

struct PlayerDetailView: View {
  @Environment(\.databaseQueue) var databaseQueue
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
  @Previewable @Environment(\.databaseQueue) var databaseQueue
  try! databaseQueue.write { db in
    for index in 1...10 {
      _ = try! Player(
        name: "Blob \(index)",
        createdAt: Date(),
        isInjured: index.isMultiple(of: 3)
      ).inserted(db)
    }
  }
  return NavigationStack {
    ContentView()
  }
  .environment(\.databaseQueue, databaseQueue)
}

#Preview("Player detail") {
  @Previewable @State var isPresented = true

  Button("Present") {
    isPresented = true
  }
  .sheet(isPresented: $isPresented) {
    NavigationStack {
      PlayerDetailView(
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
