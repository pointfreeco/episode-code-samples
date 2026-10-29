import SwiftUI

@MainActor
@Observable class Model {
  var count = 0
  let session = Session()
  var task: Task<Void, Never>?

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
    task = Task.immediate { [weak self] in
      for await _ in NotificationCenter.default.messages(for: IncrementMessage.self, bufferSize: .max) {
        guard let self else { break }
        count += 1
      }
    }
    Task.immediate { [weak self] in
      for await _ in NotificationCenter.default.messages(for: SessionDidChangeMessage.self, bufferSize: .max) {
        guard let self else { break }
        print(session.token as Any)
      }
    }
  }

  isolated deinit {
    task?.cancel()
  }

  func incrementButtonTapped() {
    NotificationCenter.default.post(name: .increment, object: nil)
  }

  func newIncrementButtonTapped() {
    NotificationCenter.default.post(IncrementMessage())
  }

  func newIncrement1000ButtonTapped() {
    for _ in 1...1_000 {
      Task { @concurrent in
        NotificationCenter.default.post(IncrementMessage())
      }
    }
  }

  func loginButtonTapped() {
    session.update(token: "deadbeef")
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
        Button("+ (new)") {
          model.newIncrementButtonTapped()
        }
        Button("+ 1000 (new)") {
          model.newIncrement1000ButtonTapped()
        }
        Button("Login") {
          model.loginButtonTapped()
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
//    NotificationCenter.default.post(name: .sessionDidChange, object: nil)
    NotificationCenter.default.post(SessionDidChangeMessage())
  }
}

extension Notification.Name {
  static var sessionDidChange: Self {
    Self("sessionDidChange")
  }
}

struct IncrementMessage: NotificationCenter.AsyncMessage {
  class Subject {}
}

struct SessionDidChangeMessage: NotificationCenter.AsyncMessage {
  class Subject {}
}
