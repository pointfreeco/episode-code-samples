import SwiftUI

@Observable
class AppModel {
  let tab1 = CounterModel()
  let tab2 = CounterModel()
  let tab3 = CounterModel()
}

struct AppView: View {
  let model: AppModel

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
      .badge(self.model.tab2.count)
      .tabItem { Text("Counter 2") }

      NavigationStack {
        CounterView(model: self.model.tab3)
          .navigationTitle(Text("Counter 3"))
      }
      .badge(self.model.tab3.count)
      .tabItem { Text("Counter 3") }
    }
  }
}

#Preview {
  AppView(model: AppModel())
}
