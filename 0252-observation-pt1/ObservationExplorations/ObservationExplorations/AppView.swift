import Combine
import SwiftUI

class AppModel: ObservableObject {
  @Published var tab1 = CounterModel()
  @Published var tab2 = CounterModel()
  @Published var tab3 = CounterModel()

  private var cancellables: Set<AnyCancellable> = []

  init() {
    self.tab1.$count.sink { [weak self] _ in
      self?.objectWillChange.send()
    }
    .store(in: &self.cancellables)
    self.tab2.objectWillChange.sink { [weak self] in
      self?.objectWillChange.send()
    }
    .store(in: &self.cancellables)
    self.tab3.objectWillChange.sink { [weak self] in
      self?.objectWillChange.send()
    }
    .store(in: &self.cancellables)
  }
}

struct AppView: View {
  @ObservedObject var model: AppModel

  var body: some View {
    let _ = Self._printChanges()

    TabView {
      NavigationStack {
        CounterView(model: self.model.tab1)
          .navigationTitle(Text("Counter 1"))
      }
      .badge(self.model.tab1.count)
      .tabItem { Text("Counter 1") }

      NavigationStack {
        CounterView(model: self.model.tab2)
          .navigationTitle(Text("Counter 2"))
      }
      .tabItem { Text("Counter 2") }

      NavigationStack {
        CounterView(model: self.model.tab3)
          .navigationTitle(Text("Counter 3"))
      }
      .tabItem { Text("Counter 3") }
    }
  }
}

#Preview {
  AppView(model: AppModel())
}
