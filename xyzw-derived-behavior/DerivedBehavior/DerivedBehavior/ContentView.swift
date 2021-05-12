import SwiftUI

class AppViewModel: ObservableObject {
  @Published var count = 0
  @Published var favorites: Set<Int> = []
}

struct VanillaContentView: View {
  @ObservedObject var viewModel: AppViewModel

  var body: some View {
    TabView {
      VanillaCounterView(viewModel: self.viewModel)
        .tabItem { Text("Counter \(self.viewModel.count)") }

      VanillaProfileView(viewModel: self.viewModel)
        .tabItem { Text("Profile \(self.viewModel.favorites.count)") }
    }
  }
}

struct VanillaCounterView: View {
  @ObservedObject var viewModel: AppViewModel

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

struct VanillaProfileView: View {
  @ObservedObject var viewModel: AppViewModel

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
    VanillaContentView(viewModel: .init())
  }
}
