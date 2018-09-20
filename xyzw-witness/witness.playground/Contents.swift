import Foundation
import PlaygroundSupport

struct Snapshot<A> {
  let diff: (A, A) -> String
  let from: (Data) -> A
  let to: (A) -> Data

  func imap<B>(_ f: @escaping (A) -> B, _ g: @escaping (B) -> A) -> Snapshot<B> {
    return Snapshot<B>(
      diff: { b1, b2 in self.diff(g(b1), g(b2)) },
      from: { f(self.from($0)) },
      to: { self.to(g($0)) }
    )
  }
}

//
//let htmlSnapshot = Snapshot<String>(
//  diff: { _, _ in fatalError() },
//  from: { _ in fatalError() },
//  to: { _ in fatalError() }
//)

//import WebKit
//
//let webviewSnapshot: Snapshot<WKWebView> = htmlSnapshot
//  .imap({ html in
//    let webView = WKWebView.init(frame: NSRect.init(x: 0, y: 0, width: 300, height: 400))
//    webView.loadHTMLString(html, baseURL: nil)
//    return webView
//  }, { webView in "" })
//
//
//
//1


protocol SomeProtocol {
  var getVariable: Int { get }
  func someFunc(foo: Int) -> String
  static func someStaticFunc(foo: Int) -> String
  static var getStaticVar: Int { get }
}

struct SomeProtocolWitness<`Self`> {
  let getVariable: (`Self`) -> Int
  let someFunc: (`Self`, Int) -> String
  let someStaticFunc: (Int) -> String
  let getStaticVar: Int
}

1

extension Int: SomeProtocol {
  static func someStaticFunc(foo: Int) -> String {
    return "\(foo + 42)"
  }

  static var getStaticVar: Int {
    return 42
  }

  var getVariable: Int {
    return self + 42
  }

  func someFunc(foo: Int) -> String {
    return String(self + foo)
  }
}

let intWitness = SomeProtocolWitness<Int>(
  getVariable: { $0 + 42 },
  someFunc: { String($0 + $1) },
  someStaticFunc: { "\($0 + 42)" },
  getStaticVar: 42
)

intWitness.getVariable(3)
3.getVariable

intWitness.someFunc(3, 4)
3.someFunc(foo: 4)

1

protocol CarFactoryProtocol {
  associatedtype CarType
  func produce() -> CarType
}


struct AnyCarFactory<CarType>: CarFactoryProtocol {
  private let _produce: () -> CarType

  init<Factory: CarFactoryProtocol>(_ carFactory: Factory) where Factory.CarType == CarType {
    _produce = carFactory.produce
  }

  func produce() -> CarType {
    return _produce()
  }
}

2



protocol GitHubProtocol {
  func fetchRepos(onComplete completionHandler: (@escaping (GitHub.Repo?, Error?) -> Void))
}

struct GitHub: GitHubProtocol {
  struct Repo: Decodable {
    var archived: Bool
    var description: String?
    var htmlUrl: URL
    var name: String
    var pushedAt: Date?
  }

  func fetchRepos(onComplete completionHandler: (@escaping (GitHub.Repo?, Error?) -> Void)) {
    fatalError()
  }

//  var fetchRepos = fetchRepos(onComplete:)
}

struct GithubWitness<A> {
  var fetchRepos: (GitHub.Repo?, Error?) -> Void
}

let liveWitness = GithubWitness<Void>(fetchRepos: { _, _ in
})
let mockWitness = GithubWitness<Void>(fetchRepos: { _, _ in
})

//private func fetchRepos(onComplete completionHandler: (@escaping (Result<[GitHub.Repo], Error>) -> Void)) {
//  dataTask("orgs/pointfreeco/repos", completionHandler: completionHandler)
//}



protocol ExistentialProtocol {
  func test<A>(_ a: A) -> A
}

class ExistentialWitness<B> {
  func test<A>(_ b: B, _ a: A) -> A {
    fatalError()
  }
}

class MyExistentialWitness: ExistentialWitness<Int> {
  override func test<A>(_ b: Int, _ a: A) -> A {
    fatalError()
  }
}



2


protocol Parent {
  var x: Int { get }
}

protocol Child: Parent {
  var y: Int { get }
}

struct ParentWitness<A> {
  let x: (A) -> Int
}

struct ChildWitness<A> {
  let y: (A) -> Int
  let parent: ParentWitness<A>
}

ChildWitness<Int>(
  y: { $0 },
  parent: ParentWitness<Int>(x: { $0 })
)



//Decoder
2


func apply<A, B>(_ f: @escaping (A) -> B) -> (A) -> B {
  return { a in f(a) }
}


struct User {
  var bio: String
  var id: Int
  var name: String
  var password: String
}

extension User: CustomPlaygroundDisplayConvertible {
  public var playgroundDescription: Any {
    return String(describing: self)
  }
}


infix operator >>>
func >>> <A, B, C>(f: @escaping (A) -> B, g: @escaping (B) -> C) -> (A) -> C {
  return { g(f($0)) }
}

struct CustomStringConverting<A> {
  let description: (A) -> String

  func contramap<B>(_ f: @escaping (B) -> A) -> CustomStringConverting<B> {
    return .init(description: f >>> self.description)
  }
}

let prettyDescription = CustomStringConverting<User> {
  return """
  User(
    bio: \($0.bio)
    id: \($0.id)
    name: \($0.name)
    password: \($0.password)
  )
  """
}
let compactDescription = CustomStringConverting<User> {
  return "User(bio: \($0.bio), id: \($0.id), name: \($0.name), password: \($0.password))"
}

func set<S, A>(_ kp: WritableKeyPath<S, A>, _ a: A) -> (S) -> S {
  return { s in
    var s = s
    s[keyPath: kp] = a
    return s
  }
}
func over<S, A>(_ kp: WritableKeyPath<S, A>, _ f: @escaping (A) -> A) -> (S) -> S {
  return { s in
    var s = s
    s[keyPath: kp] = f(s[keyPath: kp])
    return s
  }
}

let safePrettyDescription = prettyDescription
  .contramap(apply(set(\.password, "********")))
let safeCompactDescription = compactDescription
  .contramap(apply(set(\.password, "********")))

let safePrettyTruncatedDescription = prettyDescription
  .contramap(apply(set(\.password, "********")))
  .contramap(apply(over(\.bio, { String($0.prefix(30)) + "..." })))


let user = User(
  bio: "Blobbed around the world, did some functional programming.",
  id: 42,
  name: "Blob",
  password: "blobisawesome"
)

//extension User: CustomStringConvertible {
//  var description: String {
//    return "User"
//  }
//}


print(String.init(describing: user))
print(String.init(reflecting: user))

print(safePrettyTruncatedDescription.description(user))


//divide :: (a -> (b, c)) -> f b -> f c -> f a

struct Predicate<A> {
  let contains: (A) -> Bool
}
func divide<A, B, C>(_ f: @escaping (A) -> (B, C)) -> (Predicate<B>, Predicate<C>) -> Predicate<A> {
  return { pb, pc in
    return .init { a in
      let (b, c) = f(a)
      return pb.contains(b) && pc.contains(c)
    }
  }
}
func divide<A, B, C>(_ f: @escaping (A) -> (B, C)) -> (CustomStringConverting<B>, CustomStringConverting<C>) -> CustomStringConverting<A> {
  return { sb, sc in
    return .init { a in
      let (b, c) = f(a)
      return sb.description(b) + "\n" + sc.description(c)
    }
  }
}

let tmp = divide({ (u: User) in (u.id, u.name) })(.init { (x: Int) in "\(x)" }, .init { (x: String) in x })

tmp.description(user)



protocol GitHubP {
  func fetchRespos(completion: ([Int]) -> Void) -> Void
}

struct GitHubPWitness {
  let fetchRespos: (([Int]) -> Void) -> Void
}

//public protocol CustomStringConvertible {
//  public var description: String { get }
//}
//CustomDebugStringConvertible

struct CustomStringConvertibleWitness<A> {
  let description: (A) -> String
}

// equatable
struct EquatableWitness<A> {
  let eq: (A, A) -> Bool
}

struct ComparableWitness<A> {
  let lessThan: (A, A) -> Bool
  let eq: EquatableWitness<A>
}

protocol A {
  var x: Int { get }
}
protocol B: A {}
extension B {
  var x: Int { return 2 }
}
protocol C: A {}
extension C {
  var x: Int { return 3 }
}
protocol D: B, C {
}


//(E() as C).x
//(E() as C).x





//struct _SequenceWitness<`Self`, Element, Iterator, Subsequence

//Sequence





//let liveWitness = GitHubPWitness<Void>.init(fetchRespos: { _, live.api. })
//let mockWitness = GitHubPWitness<Void>.init(fetchRespos: { _, live.api. })


1









import WebKit

// Broke
extension URL: PlaygroundLiveViewable {
  public var playgroundLiveViewRepresentation: PlaygroundLiveViewRepresentation {
    let webView = WKWebView(frame: .init(x: 0, y: 0, width: 400, height: 800))
    webView.load(URLRequest(url: self))
    return PlaygroundLiveViewRepresentation.view(webView)
  }
}

// Woke
struct PlaygroundLiveViewing<A> {
  let playgroundLiveViewRepresentation: (A) -> PlaygroundLiveViewRepresentation
}

let urlLiveView: (CGSize) -> PlaygroundLiveViewing<URL> = { size in
  return .init { url in
    let webView = WKWebView(frame: .init(x: 0, y: 0, width: size.width, height: size.height))
    webView.load(URLRequest(url: url))
    return PlaygroundLiveViewRepresentation.view(webView)
  }
}

let urlHtmlLiveView: (CGSize) -> PlaygroundLiveViewing<URL> = { size in
  return .init { url in
    let sema = DispatchSemaphore(value: 0)
    var html: String?
    URLSession.shared.dataTask(with: url) { data, response, error in
      html = String(decoding: data!, as: UTF8.self)
      sema.signal()
      }
      .resume()
    sema.wait()

    let textView = UITextView(frame: .init(origin: .zero, size: size))
    textView.text = html ?? "Bad data"
    return .view(textView)
  }
}

// this is unfortauntely needed to be able to do `liveView = witness.playgroundLiveViewRepresentation(foo)
extension PlaygroundLiveViewRepresentation: PlaygroundLiveViewable {
  public var playgroundLiveViewRepresentation: PlaygroundLiveViewRepresentation {
    return self
  }
}


//PlaygroundPage.current.liveView = URL(string: "https://www.pointfree.co")!

// vs

PlaygroundPage.current.liveView = urlHtmlLiveView(.init(width: 300, height: 400))
  .playgroundLiveViewRepresentation(
    URL(string: "https://www.google.com")!
)

