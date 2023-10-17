import SwiftUI

class CounterModel_ObservableObject: ObservableObject {
  @Published var count = 0
  @Published var secondsElapsed = 0
  @Published private var timerTask: Task<Void, Error>?
  var isTimerOn: Bool {
    self.timerTask != nil
  }

//  init() {
//    self.$count.sink { count in
//      self.count != count
//    }
//  }

  func decrementButtonTapped() {
    self.count -= 1
  }
  func incrementButtonTapped() {
    self.count += 1
  }

  func startTimerButtonTapped() {
    self.timerTask?.cancel()
    self.timerTask = Task { @MainActor in
      while true {
        try await Task.sleep(for: .seconds(1))
        self.secondsElapsed += 1
        print("secondsElapsed", self.secondsElapsed)
      }
    }
  }

  func stopTimerButtonTapped() {
    self.timerTask?.cancel()
    self.timerTask = nil
  }
}

struct CounterView_ObservableObject: View {
  @ObservedObject var model: CounterModel_ObservableObject

  var body: some View {
    let _ = Self._printChanges()
    Form {
      Section {
        Text(self.model.count.description)
        Button("Decrement") { self.model.decrementButtonTapped() }
        Button("Increment") { self.model.incrementButtonTapped() }
      } header: {
        Text("Counter")
      }
      Section {
        //Text("Seconds elapsed: \(self.model.secondsElapsed)")
        if !self.model.isTimerOn {
          Button("Start timer") {
            self.model.startTimerButtonTapped()
          }
        } else {
          Button {
            self.model.stopTimerButtonTapped()
          } label: {
            HStack {
              Text("Stop timer")
              Spacer()
              ProgressView().id(UUID())
            }
          }
        }
      } header: {
        Text("Timer")
      }
    }
  }
}

#Preview {
  CounterView_ObservableObject(model: CounterModel_ObservableObject())
}
