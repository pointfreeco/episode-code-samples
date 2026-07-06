import Playgrounds
import SwiftUI
import UIKitNavigation

@main struct MyApp: App {
  var body: some Scene {
    WindowGroup {
      UIViewControllerRepresenting {
        AlertsV4ViewController()
      }
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
