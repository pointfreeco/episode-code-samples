import XCTest
@testable import Client
import SiteRouter

class ClientTests: XCTestCase {
  func testBasics() async throws {
    let viewModel = ViewModel(
      apiClient: .failing
        .override(
          .users(.user(42, .books(.search(.init(direction: .asc))))),
          with: { try .ok(BooksResponse.mock) }
        )
    )

    await viewModel.fetch()

    XCTAssertEqual(viewModel.books, BooksResponse.mock.books)
  }
}

extension BooksResponse {
  static let mock = Self(
    books: [
      .init(
        id: .init(uuidString: "deadbeef-dead-beef-dead-beefdeadbeef")!,
        title: "Blobbed around the world",
        bookURL: .init(string: "/books/deadbeef-dead-beef-dead-beefdeadbeef")!)
    ]
  )
}
