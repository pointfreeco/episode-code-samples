import SwiftUI
import SiteRouter
import _URLRouting

class ViewModel: ObservableObject {
  @Published var books: [BooksResponse.Book] = []
  @Published var direction: SearchOptions.Direction = .asc

  let apiClient: URLRoutingClient<SiteRoute>

  init(apiClient: URLRoutingClient<SiteRoute>) {
    self.apiClient = apiClient
  }

  @MainActor
  func fetch() async {
    do {
      self.books = try await self.apiClient.request(
        .users(.user(42, .books())),
        as: BooksResponse.self
      ).value.books
    } catch {

    }
  }
}

struct ContentView: View {
  @ObservedObject var viewModel: ViewModel

  var body: some View {
    VStack {
      Picker(selection: self.$viewModel.direction) {
        Text("Ascending").tag(SearchOptions.Direction.asc)
        Text("Descending").tag(SearchOptions.Direction.desc)
      } label: {
        Text("Direction")
      }
      .pickerStyle(.segmented)

      List {
        ForEach(self.viewModel.books, id: \.id) { book in
          Text(book.title)
        }
      }
    }
    .task { await self.viewModel.fetch() }
    .onChange(of: self.viewModel.direction) { _ in
      Task {
        await self.viewModel.fetch()
      }
    }
  }
}

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    ContentView(
      viewModel: ViewModel(
        apiClient: .failing
          .override {
            guard case .users(.user(_, .books(.search))) = $0
            else { return false }
            return true
          } with: {
            try .ok(
              BooksResponse(
                books: (1...100).map { n in
                    .init(id: .init(), title: "Book \(n)", bookURL: URL(string: "/books/\(n)")!)
                }
              )
            )
          }
      )
    )
  }
}
