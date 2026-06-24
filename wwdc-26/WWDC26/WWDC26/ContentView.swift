import Playgrounds
import SwiftUI

@main struct MyApp: App {
  var body: some Scene {
    WindowGroup {
      AlertsV3View()
    }
  }
}

struct ContentView: View {
  var body: some View {
    Text("Hello, world!")
      .padding()
  }
}

#Preview {
  ContentView()
}

#Playground {
  _ = 1 + 2
}
