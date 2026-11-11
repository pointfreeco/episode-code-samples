import SwiftUI

@MainActor
@Observable class Model {
  var count = 0
  let session = Session()
  var task: Task<Void, Never>?
  var token: NotificationCenter.ObservationToken!
  var sessionToken: NotificationCenter.ObservationToken!

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
    token = NotificationCenter.default.addObserver(
      for: MainActorIncrementMessage.self) { [weak self] message in
        guard let self else { return }
        count += 1
      }

    sessionToken = NotificationCenter.default.addObserver(for: MainActorSessionDidChangeMessage.self) { [weak self] _ in
      print(self?.session.token as Any)
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

  func mainActorIncrementButtonTapped() {
    NotificationCenter.default.post(MainActorIncrementMessage())
  }

  func mainActorIncrement1000ButtonTapped() {
    for _ in 1...1_000 {
      NotificationCenter.default.post(MainActorIncrementMessage())
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
          withAnimation {
            model.incrementButtonTapped()
          }
        }
        Button("+ (new)") {
          withAnimation {
            model.newIncrementButtonTapped()
          }
        }
        Button("+ 1000 (new)") {
          model.newIncrement1000ButtonTapped()
        }
        Button("+ (main actor)") {
          withAnimation {
            model.mainActorIncrementButtonTapped()
          }
        }
        Button("+ 1000 (main actor)") {
          withAnimation {
            model.mainActorIncrement1000ButtonTapped()
          }
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


@MainActor
final class Session {
  private(set) var token: String?

  func update(token: String?) {
    self.token = token
//    NotificationCenter.default.post(name: .sessionDidChange, object: nil)
//    NotificationCenter.default.post(SessionDidChangeMessage())
    NotificationCenter.default.post(MainActorSessionDidChangeMessage())
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
struct MainActorIncrementMessage: NotificationCenter.MainActorMessage {
  class Subject {}
}

struct SessionDidChangeMessage: NotificationCenter.AsyncMessage {
  class Subject {}
}
struct MainActorSessionDidChangeMessage: NotificationCenter.MainActorMessage {
  class Subject {}
}
