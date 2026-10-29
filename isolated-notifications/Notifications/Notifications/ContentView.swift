import SwiftUI

struct ContentView: View {
  @State var count = 0

  var body: some View {
    Form {
      Text("\(count)")
      Button("+") {
        NotificationCenter.default.post(name: .increment, object: nil)
      }
    }
    .onAppear {
      NotificationCenter.default
        .addObserver(
          forName: .increment,
          object: nil,
          queue: .main
        ) { notification in
          //_count.wrappedValue += 1
          MainActor.assumeIsolated {
            count += 1
          }
        }
    }
  }
}

extension Notification.Name {
  static var increment: Self {
    Self("increment")
  }
}

#Preview {
  ContentView()
}
