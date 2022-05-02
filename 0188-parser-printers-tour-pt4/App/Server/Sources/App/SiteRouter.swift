import Foundation
import VaporRouting

struct CreateUser: Codable {
  let bio: String
  let name: String
}

enum BookRoute {
  case fetch
}
enum BooksRoute {
  case book(UUID, BookRoute = .fetch)
  case search(SearchOptions = .init())
}
enum UserRoute {
  case books(BooksRoute = .search())
  case fetch
}
enum UsersRoute {
  case create(CreateUser)
  case user(Int, UserRoute = .fetch)
}
enum SiteRoute {
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
let router = OneOf {
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
