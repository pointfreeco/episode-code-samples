import Observation
import SwiftUI

struct Angle {
  var radians: Double
  var degrees: Double {
    @storageRestrictions(initializes: radians)
    init(initialValue) {
      self.radians = initialValue * .pi / 180
    }
    get { self.radians * 180 / .pi }
    set { self.radians = newValue * .pi / 180 }
  }
  init(radians: Double) {
    self.radians = radians
  }
  init(degrees: Double) {
    self.degrees = degrees
  }
}

@Observable
class CounterModel {
  // private var _count
  var count: Int = 0 {
    didSet {
      print("Count changed to", self.count)
    }
  }
  var isDisplayingSecondsElapsed = true
  var secondsElapsed = 0
  private var timerTask: Task<Void, Error>?
  var isTimerOn: Bool {
    self.timerTask != nil
  }

  init() {
    self.count = 0

    @Sendable func observe() {
      withObservationTracking {
        _ = self.count
      } onChange: {
        Task {
          print("Count changed to", self.count)
        }
        observe()
      }
    }
//    observe()
  }

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

struct CounterView: View {
  @Bindable var model: CounterModel

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
        if self.model.isDisplayingSecondsElapsed {
          Text("Seconds elapsed: \(self.model.secondsElapsed)")
        }
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
        Toggle(isOn: self.$model.isDisplayingSecondsElapsed) {
          Text("Observe seconds elapsed")
        }
      } header: {
        Text("Timer")
      }
    }
  }
}

#Preview {
  CounterView(model: CounterModel())
}

struct ObservedView<Content: View>: View {
  @State var id = UUID()
  let content: () -> Content

  var body: some View {
    withObservationTracking {
      content()
    } onChange: {
      self.id = UUID()
    }
  }
}
