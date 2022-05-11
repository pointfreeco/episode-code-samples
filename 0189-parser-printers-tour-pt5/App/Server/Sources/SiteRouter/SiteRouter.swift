import Foundation
import URLRouting

public struct UserResponse: Codable {
  public let id: Int
  public let name: String
  public let booksURL: URL
  public init(
    id: Int,
    name: String,
    booksURL: URL
  ) {
    self.id = id
    self.name = name
    self.booksURL = booksURL
  }
}
public struct BookResponse: Codable {
  public let id: UUID
  public let userId: Int
  public let title: String
  public init(
    id: UUID,
    userId: Int,
    title: String
  ) {
    self.id = id
    self.userId = userId
    self.title = title
  }
}
public struct BooksResponse: Codable {
  public let books: [Book]
  public init(books: [Book]) {
    self.books = books
  }
  public struct Book: Codable, Equatable {
    public let id: UUID
    public let title: String
    public let bookURL: URL
    public init(
      id: UUID,
      title: String,
      bookURL: URL
    ) {
      self.id = id
      self.title = title
      self.bookURL = bookURL
    }
  }
}

public struct CreateUser: Codable, Equatable {
  public let bio: String
  public let name: String
  public init(
    bio: String,
    name: String
  ) {
    self.bio = bio
    self.name = name
  }
}
public struct SearchOptions: Decodable, Equatable {
  public var sort: Sort = .title
  public var direction: Direction = .asc
  public var count = 10

  public init(
    sort: Sort = .title,
    direction: Direction = .asc,
    count: Int = 10
  ) {
    self.sort = sort
    self.direction = direction
    self.count = count
  }

  public enum Direction: String, CaseIterable, Decodable {
    case asc, desc
  }
  public enum Sort: String, CaseIterable, Decodable {
    case title, category
  }
}
public enum BookRoute: Equatable {
  case fetch
}
public enum BooksRoute: Equatable {
  case book(UUID, BookRoute = .fetch)
  case search(SearchOptions = .init())
}
public enum UserRoute: Equatable {
  case books(BooksRoute = .search())
  case fetch
}
public enum UsersRoute: Equatable {
  case create(CreateUser)
  case user(Int, UserRoute = .fetch)
}
public enum SiteRoute: Equatable {
  case aboutUs
  case contactUs
  case home
  case users(UsersRoute)
}

let bookRouter = OneOf {
  Route(.case(BookRoute.fetch))
}
let booksRouter = OneOf {
  Route(.case(BooksRoute.search)) {
    Path { "search" }
    Parse(.memberwise(SearchOptions.init)) {
      Query {
        Field("sort", default: .title) { SearchOptions.Sort.parser() }
        Field("direction", default: .asc) { SearchOptions.Direction.parser() }
        Field("count", default: 10) { Digits() }
      }
    }
  }
  Route(.case(BooksRoute.book)) {
    Path { UUID.parser() }
    bookRouter
  }
}
let userRouter = OneOf {
  Route(.case(UserRoute.fetch))
  Route(.case(UserRoute.books)) {
    Path { "books" }
    booksRouter
  }
}
let usersRouter = OneOf {
  Route(.case(UsersRoute.create)) {
    Method.post
    Body(.json(CreateUser.self))
  }
  Route(.case(UsersRoute.user)) {
    Path { Digits() }
    userRouter
  }
}
public let router = OneOf {
  Route(.case(SiteRoute.aboutUs)) {
    Path { "about-us" }
  }
  Route(.case(SiteRoute.contactUs)) {
    Path { "contact-us" }
  }
  Route(.case(SiteRoute.home))
  Route(.case(SiteRoute.users)) {
    Path { "users" }
    usersRouter
  }
}
