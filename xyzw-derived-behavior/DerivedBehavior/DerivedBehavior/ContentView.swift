import Combine
import SwiftUI

class AppViewModel: ObservableObject {
  let counter: CounterViewModel
  let profile: ProfileViewModel
  var cancellables: Set<AnyCancellable> = []
  
  init(
    counter: CounterViewModel = .init(),
    profile: ProfileViewModel = .init()
  ) {
    self.counter = counter
    self.profile = profile
    
    self.counter.objectWillChange
      .sink { [weak self] in self?.objectWillChange.send() }
      .store(in: &self.cancellables)
    self.profile.objectWillChange
      .sink { [weak self] in self?.objectWillChange.send() }
      .store(in: &self.cancellables)
  }
}

struct VanillaContentView: View {
  @ObservedObject var viewModel: AppViewModel
//  @ObservedObject var counterViewModel: CounterViewModel
//  @ObservedObject var profileViewModel: ProfileViewModel

  var body: some View {
    TabView {
      VanillaCounterView(viewModel: self.viewModel.counter)
        .tabItem { Text("Counter \(self.viewModel.counter.count)") }

      VanillaProfileView(viewModel: self.viewModel.profile)
        .tabItem { Text("Profile \(self.viewModel.profile.favorites.count)") }
    }
  }
}

class CounterViewModel: ObservableObject {
  @Published var count = 0
  @Published var favorites: Set<Int> = []
}

struct VanillaCounterView: View {
  @ObservedObject var viewModel: CounterViewModel

  var body: some View {
    VStack {
      HStack {
        Button("-") { self.viewModel.count -= 1 }
        Text("\(self.viewModel.count)")
        Button("+") { self.viewModel.count += 1 }
      }

      if self.viewModel.favorites.contains(self.viewModel.count) {
        Button("Remove") {
          self.viewModel.favorites.remove(self.viewModel.count)
        }
      } else {
        Button("Save") {
          self.viewModel.favorites.insert(self.viewModel.count)
        }
      }
    }
  }
}

class ProfileViewModel: ObservableObject {
  @Published var favorites: Set<Int> = []
}

struct VanillaProfileView: View {
  @ObservedObject var viewModel: ProfileViewModel

  var body: some View {
    List {
      ForEach(self.viewModel.favorites.sorted(), id: \.self) { number in
        HStack {
          Text("\(number)")
          Spacer()
          Button("Remove") {
            self.viewModel.favorites.remove(number)
          }
        }
      }
    }
  }
}

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    VanillaContentView(
      viewModel: .init()
//      counterViewModel: .init(),
//      profileViewModel: .init()
    )
  }
}
