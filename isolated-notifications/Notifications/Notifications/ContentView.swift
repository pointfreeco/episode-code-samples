import SwiftUI

@MainActor
@Observable class Model {
  var count = 0
  let session = Session()
  var token: ModernNotificationCenter.ObservationToken!
  var sessionToken: ModernNotificationCenter.ObservationToken!

  init() {
    token = ModernNotificationCenter.default.addObserver(
      for: MainActorIncrementMessage.self) { [weak self] message in
        guard let self else { return }
        count += 1
      }

    sessionToken = ModernNotificationCenter.default.addObserver(for: MainActorSessionDidChangeMessage.self) { [weak self] _ in
      print(self?.session.token as Any)
    }
  }

  func mainActorIncrementButtonTapped() {
    ModernNotificationCenter.default.post(MainActorIncrementMessage())
  }

  func mainActorIncrement1000ButtonTapped() {
    for _ in 1...1_000 {
      ModernNotificationCenter.default.post(MainActorIncrementMessage())
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
        Text("\(model.count)")
          .monospacedDigit()
          .contentTransition(.numericText())
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
    ModernNotificationCenter.default.post(MainActorSessionDidChangeMessage())
  }
}

extension Notification.Name {
  static var sessionDidChange: Self {
    Self("sessionDidChange")
  }
}

struct MainActorIncrementMessage: ModernNotificationCenter.MainActorMessage {
}

struct MainActorSessionDidChangeMessage: ModernNotificationCenter.MainActorMessage {
}
