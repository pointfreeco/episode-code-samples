import SwiftUI

@MainActor
@Observable class Model {
  var count = 0

  init() {
    NotificationCenter.default.addObserver(forName: .increment, object: nil, queue: .main) { [weak self] notification in
      MainActor.assumeIsolated {
        self?.count += 1
      }
    }
  }

  func incrementButtonTapped() {
    NotificationCenter.default.post(name: .increment, object: nil)
  }
}

struct ContentView: View {
  @State private var count = 0
  @State private var model = Model()

  var body: some View {
    Form {
      Section {
        Text("\(count)")
          .monospacedDigit()
          .contentTransition(.numericText())
        Button("+") {
          withAnimation {
            NotificationCenter.default.post(name: .increment, object: nil)
          }
        }
      } header: {
        Text("View state")
      }

      Section {
        Text("\(model.count)")
          .monospacedDigit()
          .contentTransition(.numericText())
        Button("+") {
          model.incrementButtonTapped()
        }
      } header: {
        Text("Observable model")
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
