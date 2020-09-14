import Foundation

struct Article: Equatable, Identifiable {
  var blurb: String
  var date: Date
  let id: UUID
  var isHidden = false
  var isFavorite = false
  var title: String
  var willReadLater = false
}

let placeholderArticles = (0...10).map { _ in
  Article(
    blurb: String(repeating: " ", count: .random(in: 50...100)),
    date: .init(),
    id: .init(),
    isFavorite: Bool.random(),
    title: String(repeating: " ", count: .random(in: 10...30)),
    willReadLater: Bool.random()
  )
}

let liveArticles = [
  Article(
    blurb: "What makes functions special, contrasting them with the way we usually write code, and have some exploratory discussions about operators and composition.",
    date: Date(timeIntervalSince1970: 1_517_206_269),
    id: .init(),
    title: "Functions"
  ),
  Article(
    blurb: "Side effects: can’t live with ’em; can’t write a program without ’em. Let’s explore a few kinds of side effects we encounter every day, why they make code difficult to reason about and test, and how we can control them without losing composition.",
    date: Date(timeIntervalSince1970: 1_517_811_069),
    id: .init(),
    title: "Side-effects"
  ),
  Article(
    blurb: "Parsing is a difficult, but surprisingly ubiquitous programming problem, and functional programming has a lot to say about it. Let’s take a moment to understand the problem space of parsing, and see what tools Swift and Apple gives us to parse complex text formats.",
    date: .init(timeIntervalSince1970: 1557122400),
    id: .init(),
    title: "Parsers"
  ),
  Article(
    blurb: "In this article we will build a library from first principles inspired by protocol-oriented programming, and clearly show the downsides to this approach. Then, we’ll scrap the protocols, use simple concrete data types, and discover a whole new world of composition.",
    date: .init(timeIntervalSince1970: 1545116400),
    id: .init(),
    title: "Snapshot testing"
  ),
  Article(
    blurb: "Architecture is a tough problem and there’s no shortage of articles, videos and open source projects attempting to solve the problem once and for all. In this collection we systematically develop an architecture from first principles, with an eye on building something that is composable, modular, testable, and more.",
    date: .init(timeIntervalSince1970: 1564984800),
    id: .init(),
    title: "Composable Architecture"
  ),
]

struct FullArticle: Equatable {
  var body: String
  var comments: [Comment]

  struct Comment: Equatable, Identifiable {
    var body: String
    var commenter: User
    var date: Date
    let id = UUID()
  }
}

struct User: Equatable {
  var name: String
}

let articleDateFormatter: DateFormatter = {
  let formatter = DateFormatter()
  formatter.dateFormat = "EEEE MMM d, yyyy"
  formatter.timeZone = TimeZone(secondsFromGMT: 0)
  return formatter
}()
