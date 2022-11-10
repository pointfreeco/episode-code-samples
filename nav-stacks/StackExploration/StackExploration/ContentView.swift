import SwiftUI

struct ContentView: View {
  var body: some View {
    NavigationStack {
      ListView()
        .navigationDestination(for: String.self) { letter in
          ListView()
            .navigationTitle(Text(letter))
        }
        .navigationDestination(for: Int.self) { number in
          ListView()
            .navigationTitle(Text("\(number)"))
        }
        .navigationTitle("Root")
    }
  }
}

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    ContentView()
  }
}

struct ListView: View {
  var body: some View {
    List {
      NavigationLink(value: "A") {
        Text("Go to screen A")
      }
      NavigationLink(value: "B") {
        Text("Go to screen B")
      }
      NavigationLink(value: "C") {
        Text("Go to screen C")
      }
      NavigationLink(value: 42) {
        Text("Go to screen 42")
      }
    }
  }
}
