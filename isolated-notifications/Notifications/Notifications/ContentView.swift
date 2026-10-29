import SwiftUI

@MainActor
@Observable class Model {
  var count = 0

  init() {
    NotificationCenter.default.addObserver(
      forName: .increment,
      object: nil,
      queue: .main
    ) { [weak self] notification in
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
  @State var count = 0
  @State private var model = Model()
  @State private var session = Session()

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
        Button("+ 1,000") {
          for _ in 1...1 {
            Task { @concurrent in
              NotificationCenter.default.post(name: .increment, object: nil)
            }
          }
        }
        Button("Login") {
          session.update(token: "deadbeef")
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
          MainActor.assumeIsolated {
            count += 1
          }
        }
      NotificationCenter.default
        .addObserver(
          forName: .sessionDidChange,
          object: nil,
          queue: .main
        ) { notification in
          MainActor.assumeIsolated {
            print(session.token as Any)
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


final class Session: @unchecked Sendable {
  private let lock = NSLock()
  private var _token: String?

  var token: String? {
    lock.lock()
    defer { lock.unlock() }
    return _token
  }

  func update(token: String?) {
    lock.lock()
    defer { lock.unlock() }
    _token = token
    NotificationCenter.default.post(name: .sessionDidChange, object: nil)
  }
}

extension Notification.Name {
  static var sessionDidChange: Self {
    Self("sessionDidChange")
  }
}
