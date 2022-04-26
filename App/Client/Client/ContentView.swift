import SwiftUI
import SiteRouter
import _URLRouting

let apiClient = URLRoutingClient.live(router: router.baseURL("http://127.0.0.1:8080"))

struct ContentView: View {
  @State var books: [BooksResponse.Book] = []

  var body: some View {
    List {
      ForEach(self.books, id: \.id) { book in
        Text(book.title)
      }
    }
    .task {
      do {
        self.books = try await apiClient.request(
          .users(.user(42, .books())),
          as: BooksResponse.self
        ).value.books
      } catch {

      }
    }
  }
}

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    ContentView()
  }
}
