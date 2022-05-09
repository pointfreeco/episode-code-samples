import Vapor
import SiteRouter

extension UserResponse: Content {}
extension BookResponse: Content {}
extension BooksResponse: Content {}
extension BooksResponse.Book: Content {}

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

func siteHandler(
  request: Request,
  route: SiteRoute
) async throws -> AsyncResponseEncodable {
  switch route {
  case .aboutUs:
    return [String: String]()
  case .contactUs:
    return [String: String]()
  case .home:
    return [String: String]()
  case let .users(route):
    return try await usersHandler(request: request, route: route)
  }
}

func usersHandler(
  request: Request,
  route: UsersRoute
) async throws -> AsyncResponseEncodable {
  switch route {
  case .create(_):
    return [String: String]()
  case let .user(userId, route):
    return try await userHandler(request: request, userId: userId, route: route)
  }
}

func userHandler(
  request: Request,
  userId: Int,
  route: UserRoute
) async throws -> AsyncResponseEncodable {
  switch route {
  case let .books(route):
    return try await booksHandler(request: request, userId: userId, route: route)
  case .fetch:
    return UserResponse(
      id: userId,
      name: "Blob \(userId)",
      booksURL: request.application.router
        .url(for: .users(.user(userId, .books())))
    )
  }
}

func booksHandler(
  request: Request,
  userId: Int,
  route: BooksRoute
) async throws -> AsyncResponseEncodable {
  switch route {
  case let .book(bookId, route):
    return try await bookHandler(request: request, userId: userId, bookId: bookId, route: route)
  case let .search(options):
    return BooksResponse(
      books: (1...options.count).map { n in
        let bookId = UUID()
        return .init(
          id: bookId,
          title: "Blobbed around the world \(n)",
          bookURL: request.application.router
            .url(for: .users(.user(userId, .books(.book(bookId)))))
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

func bookHandler(
  request: Request,
  userId: Int,
  bookId: UUID,
  route: BookRoute
) async throws -> AsyncResponseEncodable {
  switch route {
  case .fetch:
    return BookResponse(
      id: bookId,
      userId: userId,
      title: "Blobbed around the world \(bookId)"
    )
  }
}
