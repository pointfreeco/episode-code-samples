import Foundation

/*

Rails.application.routes.draw do
  get "/users/:user_id/books/:book_id" => "books#fetch"
end

 users_books_path true, "hello" # /users/42/books/123


app.get('/users/:userId/books/:bookId', function (req, res) {
  ...
})


app.get("users", ":userID", "books", ":bookID") { req in
  ...
}


<a href="/users/42/book/123">Blob Autobiography</a>
<a href="/users/42/book/321">Blobbed around the world</a>

 "/users/\(user.id)/books/\(book.id)"

 router.parse("/users/42/books/123") // (42, 123)
 router.print((user.id, book.id)) // "/users/42/books/123"

 */

import _URLRouting


struct SearchOptions {
  var sort: Sort = .title
  var direction: Direction = .asc
  var count = 10

  enum Direction: String, CaseIterable {
    case asc, desc
  }
  enum Sort: String, CaseIterable {
    case title, category
  }
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

SiteRoute.users(.user(42, .books(.book(.init()))))

let router = OneOf {
  Route(.case(SiteRoute.aboutUs)) {
    Path { "about-us" }
  }
  Route(.case(SiteRoute.contactUs)) {
    Path { "contact-us" }
  }
  Route(.case(SiteRoute.home))
}

enum SiteRoute {
  case createUser(CreateUser)
  case user(id: Int)
  case book(userId: Int, bookId: UUID)
  case searchBooks(userId: Int, options: SearchOptions)
}
struct CreateUser: Codable {
  let bio: String
  let name: String
}

let router = OneOf {
  Route(.case(SiteRoute.user(id:))) {
    Path {
      "users"
      Digits()
    }
  }

  Route(.case(SiteRoute.book(userId:bookId:))) {
    Path {
      "users"
      Digits()
      "books"
      UUID.parser()
    }
  }

  Route(.case(SiteRoute.searchBooks(userId:options:))) {
    Path { "users"; Digits(); "books"; "search" }
    Parse(.memberwise(SearchOptions.init)) {
      Query {
        Field("sort", default: .title) { SearchOptions.Sort.parser() }
        Field("direction", default: .asc) { SearchOptions.Direction.parser() }
        Field("count", default: 10) { Digits() }
      }
    }
  }

  Route(.case(SiteRoute.createUser)) {
    Method.post
    Path { "users" }
    Body(.json(CreateUser.self))
  }
}

do {
  var request = URLRequest(url: URL(string: "/users")!)
  request.httpMethod = "POST"
  request.httpBody = try JSONEncoder().encode(CreateUser(bio: "Blobbed around the world", name: "Blob"))
  try router.match(request: request)

  try router.request(for: .createUser(.init(bio: "Blobbed around the world", name: "Blob"))) == request
} catch {
  print(error)
}

try router.match(path: "/users/42/books/search?count=100")
router.path(for: .searchBooks(userId: 42, options: .init(sort: .category, direction: .desc, count: 100)))

try router.match(path: "/users/42/books/deadbeef-dead-beef-dead-beefdeadbeef")
router.path(for: .book(userId: 42, bookId: .init()))
router.path(for: .user(id: 42))

"\(UUID())"
struct BookId {
  let id = UUID()
}
"\(BookId())"

// users/42/books/search?sort=title&direction=asc
// POST users/42/books, body={"title": "Blob Cookbook", "category": "Cooking", ...}

let request = URLRequest(url: URL(string: "users/42/books?sort=title&direction=asc")!)

