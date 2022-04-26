import XCTest
@testable import Client
import SiteRouter

class ClientTests: XCTestCase {
  func testBasics() async {
    let viewModel = ViewModel(
      apiClient: .failing
        .override(.users(.user(42, .books(.search(.init(direction: .asc)))))) {
          try .ok(
            BooksResponse(
              books: [
                .init(
                  id: .init(uuidString: "deadbeef-dead-beef-dead-beefdeadbeef")!,
                  title: "Blobbed around the world",
                  bookURL: URL(string: "/books/deadbeef-dead-beef-dead-beefdeadbeef")!
                )
              ]
            )
          )
        }
    )

    await viewModel.fetch()

    XCTAssertEqual(
      viewModel.books,
      [
        .init(
          id: .init(uuidString: "deadbeef-dead-beef-dead-beefdeadbeef")!,
          title: "Blobbed around the world",
          bookURL: URL(string: "/books/deadbeef-dead-beef-dead-beefdeadbeef")!
        )
      ]
    )
  }
}
