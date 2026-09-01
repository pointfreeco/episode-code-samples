/*
See the LICENSE.txt file for this sample's licensing information.

Abstract:
The SwiftUI app.
*/

import SwiftData
import SwiftUI

@main
struct TripsApp: App {
  let modelContainer = DataModel.shared.modelContainer

  var body: some Scene {
    WindowGroup {
      ContentView()
//      TripsView()
    }
    .modelContainer(modelContainer)
  }
}

struct TripsView: View {
  @Environment(\.modelContext) var modelContext
  @State var observer: ResultsObserver<Trip, Never>?
  var body: some View {
    List {
      if let observer {
        ForEach(observer.results) { trip in
          Text(trip.name)
        }
      }
    }
    .onAppear {
      observer = try! ResultsObserver(modelContext: modelContext)
      _ = Task {
        while true {
          try await Task.sleep(for: .seconds(1))
          withAnimation {
            modelContext.insert(Trip(name: "Blob", destination: "Blob"))
            try! modelContext.save()
          }
        }
      }
    }
  }
}
