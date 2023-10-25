import SwiftUI

struct SomeValue {
  var count = 0
  mutating func apply() async throws {
//    DispatchQueue.global().asyncAfter(deadline: .now() + 1) {
//      self.count += 1
//    }
    try await Task.sleep(for: .seconds(1))
    self.count += 1
  }
}

//func foo() {
//  var value = SomeValue()
//  value.apply()
//  value.count  // 0
//  // doSomething(&value)
//  value.count  // 1
//
//  DispatchQueue.global().asyncAfter(deadline: .now() + 1) {
//    value.count += 1
//  }
//}

@main
struct ObservationExplorationsApp: App {
  let model = AppModel()

  var body: some Scene {
    WindowGroup {
      AppView(model: self.model)
        .onAppear {
          DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
            model.tab3.numbers = []
            model.tab3.counters = []
          }
        }
//      CounterView(model: CounterModel())
//      CounterView_ObservableObject(model: CounterModel_ObservableObject())
    }
  }
}
