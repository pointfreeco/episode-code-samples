import Combine
import CombineSchedulers
import SwiftUI

class CounterViewModel: ObservableObject {
  @Published var alert: Alert?
  @Published var count = 0
  let onFact: (Int, String) -> Void

  let fact: FactClient
  let mainQueue: AnySchedulerOf<DispatchQueue>

  private var cancellables: Set<AnyCancellable> = []

  init(
    fact: FactClient,
    mainQueue: AnySchedulerOf<DispatchQueue>,
    onFact: @escaping (Int, String) -> Void
  ) {
    self.fact = fact
    self.mainQueue = mainQueue
    self.onFact = onFact
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
        receiveValue: { [weak self] fact in
          guard let self = self else { return }
          self.onFact(self.count, fact)
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

class CounterRowViewModel: ObservableObject, Identifiable {
  @Published var counter: CounterViewModel
  let id: UUID
  let onRemove: () -> Void
  
  init(
    counter: CounterViewModel,
    id: UUID,
    onRemove: @escaping () -> Void
  ) {
    self.counter = counter
    self.id = id
    self.onRemove = onRemove
  }
  
  func removeButtonTapped() {
    // TODO: track analytics
    DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
      self.onRemove()
    }
  }
}

struct VanillaCounterRowView: View {
  let viewModel: CounterRowViewModel

  var body: some View {
    HStack {
      VanillaCounterView(
        viewModel: self.viewModel.counter
      )
      
      Spacer()
      
      Button("Remove") {
        withAnimation {
          self.viewModel.removeButtonTapped()
        }
      }
    }
    .buttonStyle(PlainButtonStyle())
  }
}


class FactPromptViewModel: ObservableObject {
  let count: Int
  @Published var fact: String
  @Published var isLoading = false

  let factClient: FactClient
  let mainQueue: AnySchedulerOf<DispatchQueue>

  private var cancellables: Set<AnyCancellable> = []

  init(
    count: Int,
    fact: String,
    factClient: FactClient,
    mainQueue: AnySchedulerOf<DispatchQueue>
  ) {
    self.count = count
    self.fact = fact
    self.factClient = factClient
    self.mainQueue = mainQueue
  }

  func dismissButtonTapped() {

  }
  func getAnotherFactButtonTapped() {
    self.isLoading = true

    self.factClient.fetch(self.count)
      .receive(on: self.mainQueue.animation())
      .sink(
        receiveCompletion: { [weak self] _ in
          self?.isLoading = false
        },
        receiveValue: { [weak self] fact in
          self?.fact = fact
        }
      )
      .store(in: &self.cancellables)
  }
}

struct VanillaFactPrompt: View {
  @ObservedObject var viewModel: FactPromptViewModel
  let onDismissTapped: () -> Void

  var body: some View {
    VStack(alignment: .leading, spacing: 16) {
      VStack(alignment: .leading, spacing: 12) {
        HStack {
          Image(systemName: "info.circle.fill")
          Text("Fact")
        }
        .font(.title3.bold())

        if self.viewModel.isLoading {
          ProgressView()
        } else {
          Text(self.viewModel.fact)
        }
      }

      HStack(spacing: 12) {
        Button("Get another fact") {
          self.viewModel.getAnotherFactButtonTapped()
        }

        Button("Dismiss") {
          self.onDismissTapped()
          //self.viewModel.dismissButtonTapped()
        }
      }
    }
    .padding()
    .frame(maxWidth: .infinity, alignment: .leading)
    .background(Color.white)
    .cornerRadius(8)
    .shadow(color: .black.opacity(0.1), radius: 20)
    .padding()
  }
}

struct IdentifiedArray<Element: Identifiable> {
  var ids: [Element.ID]
  var lookup: [Element.ID: Element]
}

class AppViewModel: ObservableObject {
  @Published var counters: [CounterRowViewModel] = []
  @Published var factPrompt: FactPromptViewModel?
  
  let fact: FactClient
  let mainQueue: AnySchedulerOf<DispatchQueue>
  let uuid: () -> UUID

  private var cancellables: Set<AnyCancellable> = []
  
  init(
    fact: FactClient,
    mainQueue: AnySchedulerOf<DispatchQueue>,
    uuid: @escaping () -> UUID
  ) {
    self.fact = fact
    self.mainQueue = mainQueue
    self.uuid = uuid
  }

  var sum: Int {
    self.counters.reduce(0) { $0 + $1.counter.count }
  }
  
  func addButtonTapped() {
    let counterViewModel = CounterViewModel(
      fact: self.fact,
      mainQueue: self.mainQueue,
      onFact: { [weak self] count, fact in
        guard let self = self else { return }

        self.factPrompt = .init(
          count: count,
          fact: fact,
          factClient: self.fact,
          mainQueue: self.mainQueue
        )
      }
    )

    let id = self.uuid()
//    let index = self.counters.endIndex
    self.counters.append(
      .init(
        counter: counterViewModel,
        id: id,
        onRemove: { [weak self] in

      // - quick lookup / in-place mutation
      // - handles invariants for duplicate identities
      // - simpler than ordered set (requires hashable elements)

//          self?.counters.removeAll(where: { $0.id == id })
      guard let self = self else { return }
      for (index, counter) in zip(self.counters.indices, self.counters) {
        if counter.id == id {
          self.counters.remove(at: index)
          return
        }
      }
//      self?.counters.remove(at: index)
        }
      )
    )

    counterViewModel.$count
      .sink { [weak self] _ in self?.objectWillChange.send() }
      .store(in: &self.cancellables)
  }

  func dismissFactPrompt() {
    self.factPrompt = nil
  }
}

struct VanillaAppView: View {
  @ObservedObject var viewModel: AppViewModel
  
  var body: some View {
    ZStack(alignment: .bottom) {
      List {
        Text("Sum: \(self.viewModel.sum)")

        ForEach(self.viewModel.counters) { counterRow in
          VanillaCounterRowView(
            viewModel: counterRow
          )
        }
      }
      .navigationTitle("Counters")
      .navigationBarItems(
        trailing: Button("Add") {
          withAnimation {
            self.viewModel.addButtonTapped()
          }
        }
      )
      
      if let factPrompt = self.viewModel.factPrompt {
        VanillaFactPrompt(
          viewModel: factPrompt,
          onDismissTapped: {
            self.viewModel.dismissFactPrompt()
          }
        )
      }
    }
  }
}


struct Vanilla_Previews: PreviewProvider {
  static var previews: some View {
    NavigationView {
      VanillaAppView(
        viewModel: .init(
          fact: .live,
          mainQueue: .main,
          uuid: UUID.init
        )
      )
    }
  }
}
