import SwiftUI

@Observable
class ListModel {
  var numbers: [Int] = []
  var counters: [CounterModel] = []
  func addButtonTapped() {
    self.numbers.append(0)
    self.counters.append(CounterModel())
  }
}

struct ListView: View {
  let model: ListModel

  var body: some View {
    let _ = Self._printChanges()
    // self.model.episode.image
    Form {
      Section {
        ForEach(self.model.numbers.indices, id: \.self) { index in
          HStack {
            Button("-") { self.model.numbers[index] -= 1 }
            Text(self.model.numbers[index].description)
            Button("+") { self.model.numbers[index] += 1 }
          }
          .buttonStyle(.plain)
        }
      }
      Section {
        ForEach(self.model.counters) { counterModel in
          HStack {
            Button("-") { counterModel.decrementButtonTapped() }
            Text(counterModel.count.description)
            Button("+") { counterModel.incrementButtonTapped() }
          }
          .buttonStyle(.plain)
        }
      }
    }
    .toolbar {
      ToolbarItem {
        Button("Add") {
          self.model.addButtonTapped()
        }
      }
    }
  }
}

#Preview {
  NavigationStack {
    ListView(model: ListModel())
  }
}
