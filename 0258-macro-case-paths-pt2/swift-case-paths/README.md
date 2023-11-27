# 🧰 CasePaths

[![CI](https://github.com/pointfreeco/swift-case-paths/workflows/CI/badge.svg)](https://actions-badge.atrox.dev/pointfreeco/swift-case-paths/goto)
[![Slack](https://img.shields.io/badge/slack-chat-informational.svg?label=Slack&logo=slack)](http://pointfree.co/slack-invite)
[![](https://img.shields.io/endpoint?url=https%3A%2F%2Fswiftpackageindex.com%2Fapi%2Fpackages%2Fpointfreeco%2Fswift-case-paths%2Fbadge%3Ftype%3Dswift-versions)](https://swiftpackageindex.com/pointfreeco/swift-case-paths)
[![](https://img.shields.io/endpoint?url=https%3A%2F%2Fswiftpackageindex.com%2Fapi%2Fpackages%2Fpointfreeco%2Fswift-case-paths%2Fbadge%3Ftype%3Dplatforms)](https://swiftpackageindex.com/pointfreeco/swift-case-paths)

Case paths bring the power and ergonomics of key paths to enums!

## Motivation

Swift endows every struct and class property with a [key path](https://developer.apple.com/documentation/swift/swift_standard_library/key-path_expressions).

``` swift
struct User {
  var id: Int
  var name: String
}

\User.id   // WritableKeyPath<User, Int>
\User.name // WritableKeyPath<User, String>
```

This is compiler-generated code that can be used to abstractly zoom in on part of a structure, inspect and even change it, while propagating these changes to the structure's whole. They unlock the ability to do many things, like [key-value observing](https://developer.apple.com/documentation/swift/cocoa_design_patterns/using_key-value_observing_in_swift) and [reactive bindings](https://developer.apple.com/documentation/combine/receiving_and_handling_events_with_combine), [dynamic member lookup](https://github.com/apple/swift-evolution/blob/master/proposals/0252-keypath-dynamic-member-lookup.md), and scoping changes to the SwiftUI [environment](https://developer.apple.com/documentation/swiftui/environment).

Unfortunately, no such structure exists for enum cases!

``` swift
enum Authentication {
  case authenticated(accessToken: String)
  case unauthenticated
}

\Authentication.authenticated // 🛑
```

And so it's impossible to write similar generic algorithms that can zoom in on a particular enum case.

## Introducing: case paths

This library intends to bridge this gap by introducing what we call "case paths." Case paths can be constructed simply by prepending the enum type and case name with a _forward_ slash:

``` swift
import CasePaths

/Authentication.authenticated // CasePath<Authentication, String>
```

### Case paths vs. key paths

While key paths package up the functionality of getting and setting a value on a root structure, case paths package up the functionality of extracting and embedding a value on a root enumeration.

``` swift
user[keyPath: \User.id] = 42
user[keyPath: \User.id] // 42

let authentication = (/Authentication.authenticated).embed("cafebeef")
(/Authentication.authenticated).extract(from: authentication) // Optional("cafebeef")
```

Case path extraction can fail and return `nil` because the cases may not match up.

``` swift
(/Authentication.authenticated).extract(from: .unauthenticated) // nil
````

Case paths, like key paths, compose. Where key paths use dot-syntax to dive deeper into a structure, case paths use a double-dot syntax:

``` swift
\HighScore.user.name
// WritableKeyPath<HighScore, String>

/Result<Authentication, Error>..Authentication.authenticated
// CasePath<Result<Authentication, Error>, String>
```

Case paths, also like key paths, provide an "[identity](https://github.com/apple/swift-evolution/blob/master/proposals/0227-identity-keypath.md)" path, which is useful for interacting with APIs that use key paths and case paths but you want to work with entire structure.

``` swift
\User.self           // WritableKeyPath<User, User>
/Authentication.self // CasePath<Authentication, Authentication>
```

Key paths are created for every property, even computed ones, so what is the equivalent for case paths? Well, "computed" case paths can be created by providing custom `embed` and `extract` functions:

``` swift
CasePath<Authentication, String>(
  embed: { decryptedToken in
    Authentication.authenticated(token: encrypt(decryptedToken))
  },
  extract: { authentication in
    guard
      case let .authenticated(encryptedToken) = authentication,
      let decryptedToken = decrypt(token)
      else { return nil }
    return decryptedToken
  }
)
```

Since Swift 5.2, key path expressions can be passed directly to methods like `map`. The same is true of case path expressions, which can be passed to methods like `compactMap`:

``` swift
users.map(\User.name)
authentications.compactMap(/Authentication.authenticated)
```

## Ergonomic associated value access

CasePaths uses Swift reflection to automatically embed and extract associated values from _any_ enum in a single, short expression. This helpful utility is made available as a public module function that can be used in your own libraries and apps:

``` swift
(/Authentication.authenticated).extract(from: .authenticated("cafebeef"))
// Optional("cafebeef")
```

## Community

If you want to discuss this library or have a question about how to use it to solve 
a particular problem, there are a number of places you can discuss with fellow 
[Point-Free](http://www.pointfree.co) enthusiasts:

* For long-form discussions, we recommend the [discussions](http://github.com/pointfreeco/swift-case-paths/discussions) tab of this repo.
* For casual chat, we recommend the [Point-Free Community Slack](http://pointfree.co/slack-invite).

## Documentation

The latest documentation for CasePaths' APIs is available [here](https://pointfreeco.github.io/swift-case-paths/main/documentation/casepaths/).

## Other libraries

  - [`EnumKit`](https://github.com/gringoireDM/EnumKit) is a protocol-oriented, reflection-based solution to ergonomic enum access and inspired the creation of this library.

## Interested in learning more?

These concepts (and more) are explored thoroughly in [Point-Free](https://www.pointfree.co), a video series exploring functional programming and Swift hosted by [Brandon Williams](https://github.com/mbrandonw) and [Stephen Celis](https://github.com/stephencelis).

The design of this library was explored in the following [Point-Free](https://www.pointfree.co) episodes:

  - [Episode 87](https://www.pointfree.co/episodes/ep87-the-case-for-case-paths-introduction): The Case for Case Paths: Introduction
  - [Episode 88](https://www.pointfree.co/episodes/ep88-the-case-for-case-paths-properties): The Case for Case Paths: Properties
  - [Episode 89](https://www.pointfree.co/episodes/ep89-case-paths-for-free): Case Paths for Free

<a href="https://www.pointfree.co/episodes/ep87-the-case-for-case-paths-introduction">
  <img alt="video poster image" src="https://d3rccdn33rt8ze.cloudfront.net/episodes/0087.jpeg" width="480">
</a>

## License

All modules are released under the MIT license. See [LICENSE](LICENSE) for details.
