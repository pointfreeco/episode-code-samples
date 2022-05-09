import SiteRouter
import Vapor
import VaporRouting

enum SiteRouterKey: StorageKey {
  typealias Value = AnyParserPrinter<URLRequestData, SiteRoute>
}

extension Application {
  var router: SiteRouterKey.Value {
    get {
      self.storage[SiteRouterKey.self]!
    }
    set {
      self.storage[SiteRouterKey.self] = newValue
    }
  }
}

// configures your application
public func configure(_ app: Application) throws {
    // uncomment to serve files from /Public folder
    // app.middleware.use(FileMiddleware(publicDirectory: app.directory.publicDirectory))

    // register routes
//    try routes(app)
  app.router = router
    .baseURL("http://127.0.0.1:8080")
    .eraseToAnyParserPrinter()

  app.mount(app.router, use: siteHandler)
}
