import Combine
import CombineSchedulers
import SwiftUI

class CounterViewModel: ObservableObject {
  @Published var alert: Alert?
  @Published var count = 0

  let fact: FactClient
  let mainQueue: AnySchedulerOf<DispatchQueue>

  private var cancellables: Set<AnyCancellable> = []

  init(
    fact: FactClient,
    mainQueue: AnySchedulerOf<DispatchQueue>
  ) {
    self.fact = fact
    self.mainQueue = mainQueue
  }

  struct Alert: Equatable, Identifiable {
    var message: String
    var title: String

    var id: String {
      self.title + self.message
    }
  }

  func decrementButtonTapped() {
    self.count -= 1
  }
  func incrementButtonTapped() {
    self.count += 1
  }
  func factButtonTapped() {
    self.fact.fetch(self.count)
      .receive(on: self.mainQueue.animation())
      .sink(
        receiveCompletion: { [weak self] completion in
          if case .failure = completion {
            self?.alert = .init(message: "Couldn't load fact", title: "Error")
          }
        },
        receiveValue: { fact in
          // ???
        }
      )
      .store(in: &self.cancellables)
  }
}

struct VanillaCounterView: View {
  @ObservedObject var viewModel: CounterViewModel

  var body: some View {
    VStack {
      HStack {
        Button("-") { self.viewModel.decrementButtonTapped() }
        Text("\(self.viewModel.count)")
        Button("+") { self.viewModel.incrementButtonTapped() }
      }

      Button("Fact") { self.viewModel.factButtonTapped() }
    }
    .alert(item: self.$viewModel.alert) { alert in
      Alert(
        title: Text(alert.title),
        message: Text(alert.message)
      )
    }
  }
}

struct Vanilla_Previews: PreviewProvider {
  static var previews: some View {
    VanillaCounterView(
      viewModel: .init(
        fact: .live,
        mainQueue: .main
      )
    )
  }
}
