import SwiftUI

struct CounterView_State: View {
  @State var count = 0
  @State var isDisplayingSecondsElapsed = false
  @State var secondsElapsed = 0
  @State var timerTask: Task<Void, Error>?

  var body: some View {
    let _ = Self._printChanges()
    Form {
      Section {
        Text(self.count.description)
        Button("Decrement") { self.count -= 1 }
        Button("Increment") { self.count += 1 }
      } header: {
        Text("Counter")
      }
      Section {
        if self.isDisplayingSecondsElapsed {
          Text("Seconds elapsed: \(self.secondsElapsed)")
        }
        if self.timerTask == nil {
          Button("Start timer") {
            self.secondsElapsed = 0
            self.timerTask?.cancel()
            self.timerTask = Task {
              while true {
                try await Task.sleep(for: .seconds(1))
                print("secondsElapsed", self.secondsElapsed)
                self.secondsElapsed += 1
              }
            }
          }
        } else {
          Button {
            self.timerTask?.cancel()
            self.timerTask = nil
          } label: {
            HStack {
              Text("Stop timer")
              Spacer()
              ProgressView().id(UUID())
            }
          }
        }
        Toggle(isOn: self.$isDisplayingSecondsElapsed) {
          Text("Display seconds")
        }
      } header: {
        Text("Timer")
      }
    }
  }
}

#Preview {
  CounterView_State()
}
