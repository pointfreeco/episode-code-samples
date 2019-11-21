//extension Effect where A == (Data?, URLResponse?, Error?) {
//  public func decode<M: Decodable>(as type: M.Type) -> Effect<M?> {
//    return self.map { data, _, _ in
//      data
//        .flatMap { try? JSONDecoder().decode(M.self, from: $0) }
//    }
//  }
//}
//
//extension Effect {
//  public func receive(on queue: DispatchQueue) -> Effect {
//    return Effect { callback in
//      self.run { a in
//        queue.async {
//          callback(a)
//        }
//      }
//    }
//  }
//}
//
//public func dataTask(with url: URL) -> Effect<(Data?, URLResponse?, Error?)> {
//  return Effect { callback in
//    URLSession.shared.dataTask(with: url) { data, response, error in
//      callback((data, response, error))
//    }
//    .resume()
//  }
//}
