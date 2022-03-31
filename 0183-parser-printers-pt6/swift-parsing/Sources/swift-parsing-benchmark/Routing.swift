import Benchmark
import Foundation
import Parsing

#if canImport(FoundationNetworking)
  import FoundationNetworking
#endif

/// This benchmark demonstrates how you can build a URL request router that can transform an input
/// request into a more well-structured data type, such as an enum. We build a router that can
/// recognize one of 5 routes for a website.
let routingSuite = BenchmarkSuite(name: "Routing") { suite in
  #if compiler(>=5.5)

  /*
   Rails.application.routes.draw do
     get "/users/:user_id/books/:book_id" => "books#fetch"
   end

   users_books_path true, "123"


   app.get('/users/:userId/books/:bookId', function (req, res) {
     ...
   })


   app.get("users", ":userID", "books", ":bookID") { req in
     ...
   }


   <a href="/users/42/books/123">Blob Autobiography</a>
   <a href="/users/42/books/321">Blobbed around the world</a>
   ...

   "/users/\(user.id)/books/\(book.id)"


   router.print(.user(id: user.id, .book(id: book.id))) // "/users/42/books/123"
   */


    enum AppRoute: Equatable {
      case home
      case contactUs
      case episodes(Episodes)
    }
    enum Episodes: Equatable {
      case index
      case episode(id: Int, route: Episode)
    }
    enum Episode: Equatable {
      case show
      case comments(Comments)
    }
    enum Comments: Equatable {
      case post(Comment)
      case show(count: Int)
    }
    struct Comment: Decodable, Equatable {
      let commenter: String
      let message: String
    }

    let router = OneOf {
      Route(AppRoute.home)

      Route(AppRoute.contactUs) {
        Path(FromUTF8View { "contact-us".utf8 })
      }

      Route(AppRoute.episodes) {
        Path(FromUTF8View { "episodes".utf8 })

        OneOf {
          Route(Episodes.index)

          Route(Episodes.episode) {
            Path(Int.parser())

            OneOf {
              Route(Episode.show)

              Route(Episode.comments) {
                Path(FromUTF8View { "comments".utf8 })

                OneOf {
                  Route(Comments.post) {
                    Method.post
                    Body {
                      JSON(Comment.self)
                    }
                  }

                  Route(Comments.show) {
                    Query("count", Int.parser(), default: 10)
                  }
                }
              }
            }
          }
        }
      }
    }

    var postRequest = URLRequest(url: URL(string: "/episodes/1/comments")!)
    postRequest.httpMethod = "POST"
    postRequest.httpBody = Data(
      """
      {"commenter": "Blob", "message": "Hi!"}
      """.utf8)
    let requests = [
      URLRequest(url: URL(string: "/")!),
      URLRequest(url: URL(string: "/contact-us")!),
      URLRequest(url: URL(string: "/episodes")!),
      URLRequest(url: URL(string: "/episodes/1")!),
      URLRequest(url: URL(string: "/episodes/1/comments")!),
      URLRequest(url: URL(string: "/episodes/1/comments?count=20")!),
      postRequest,
    ]
    .map { URLRequestData(request: $0)! }

    var output: [AppRoute]!
    var expectedOutput: [AppRoute] = [
      .home,
      .contactUs,
      .episodes(.index),
      .episodes(.episode(id: 1, route: .show)),
      .episodes(.episode(id: 1, route: .comments(.show(count: 10)))),
      .episodes(.episode(id: 1, route: .comments(.show(count: 20)))),
      .episodes(.episode(id: 1, route: .comments(.post(.init(commenter: "Blob", message: "Hi!"))))),
    ]
    suite.benchmark("Parser") {
      output = try requests.map {
        var input = $0
        return try router.parse(&input)
      }
    } tearDown: {
      precondition(output == expectedOutput)
    }
  #endif
}
