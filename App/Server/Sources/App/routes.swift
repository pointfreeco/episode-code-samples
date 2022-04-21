import Vapor

struct UserResponse: Content {
  let id: Int
  let name: String
  let booksURL: URL
}
struct BookResponse: Content {
  let id: UUID
  let userId: Int
  let title: String
}
struct BooksResponse: Content {
  let books: [Book]
  struct Book: Content {
    let id: UUID
    let title: String
    let bookURL: URL
  }
}
struct SearchOptions: Decodable {
  var sort: Sort = .title
  var direction: Direction = .asc
  var count = 10

  enum Direction: String, CaseIterable, Decodable {
    case asc, desc
  }
  enum Sort: String, CaseIterable, Decodable {
    case title, category
  }
}

func routes(_ app: Application) throws {
  // /users/:userId
  app.get("users", ":userId") { req -> UserResponse in
    guard
      let userId = req.parameters.get("userId", as: Int.self)
    else {
      struct BadRequest: Error {}
      throw BadRequest()
    }
    return UserResponse(
      id: userId,
      name: "Blob \(userId)",
      booksURL: .init(string: "http://127.0.0.1:8080/users/\(userId)/books/search?sort=title&direction=asc&count=10")!
    )
  }

  app.get("users", ":userId", "books", ":bookId") { req -> BookResponse in
    guard
      let userId = req.parameters.get("userId", as: Int.self),
      let bookId = req.parameters.get("bookId", as: UUID.self)
    else {
      struct BadRequest: Error {}
      throw BadRequest()
    }
    return BookResponse(
      id: bookId,
      userId: userId,
      title: "Blobbed around the world \(bookId)"
    )
  }

  app.get("users", ":userId", "books", "search") { req -> BooksResponse in
    guard
      let userId = req.parameters.get("userId", as: Int.self)
    else {
      struct BadRequest: Error {}
      throw BadRequest()
    }

    let options = try req.query.decode(SearchOptions.self)

    return BooksResponse(
      books: (1...options.count).map { n in
        let bookId = UUID()
        return .init(
          id: bookId,
          title: "Blobbed around the world \(n)",
          bookURL: .init(string: "http://127.0.0.1:8080/users/\(userId)/books/\(bookId)")!
        )
      }
        .sorted {
          options.direction == .asc
          ? $0.title < $1.title
          : $0.title > $1.title
        }
    )
  }
}
