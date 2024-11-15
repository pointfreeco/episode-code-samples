import SwiftUI

struct ManyCountersView: View {
  @AppStorage("count") var count = 0

  var body: some View {
    Form {
      Section {
        CounterView()
      }

      Section {
        CounterView()
      }

      Button(#"UserDefaults.set(0, "count")"#) {
        // withTransaction {
        // lock.withLock {
        withAnimation {
          UserDefaults.standard.set(
            0,
            forKey: "count"
          )
        }
      }
    }
  }
}

@Observable
class CounterModel {
  @ObservationIgnored
  @AppStorage("count") var count = 0
}

struct CounterView: View {
//  @Query(sort: \.startDate, order: .reverse) var allTrips: [Trip]
//  @FileStorage(.documentsDirectory.appending(component: "trips.json")) var trips: [Trip] = []
//  @GRDBQuery(sort: \.startDate, order: .reverse) var allTrips: [Trip]
//  @RemoteConfig("largeCount") var isLargeCountEnabled = false

  @AppStorage("count") var count = 0

  var body: some View {
    Text("\(count)")
      .font(.largeTitle)
    Button("Decrement") {
      count -= 1
    }
    Button("Increment") {
      count += 1
    }
  }
}

#Preview("CounterView") {
  let _ = UserDefaults.standard.set(10_000, forKey: "count")
  CounterView()
}

#Preview("ManyCountersView") {
  let _ = UserDefaults.standard.set(0, forKey: "count")
  ManyCountersView()
}
