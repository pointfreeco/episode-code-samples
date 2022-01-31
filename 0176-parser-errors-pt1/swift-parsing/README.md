# swift-parsing

![CI](https://github.com/pointfreeco/swift-parsing/workflows/CI/badge.svg)
[![](https://img.shields.io/endpoint?url=https%3A%2F%2Fswiftpackageindex.com%2Fapi%2Fpackages%2Fpointfreeco%2Fswift-parsing%2Fbadge%3Ftype%3Dswift-versions)](https://swiftpackageindex.com/pointfreeco/swift-parsing)
[![](https://img.shields.io/endpoint?url=https%3A%2F%2Fswiftpackageindex.com%2Fapi%2Fpackages%2Fpointfreeco%2Fswift-parsing%2Fbadge%3Ftype%3Dplatforms)](https://swiftpackageindex.com/pointfreeco/swift-parsing)

A library for turning nebulous data into well-structured data, with a focus on composition, performance, and generality:

* **Composition**: Ability to break large, complex parsing problems down into smaller, simpler ones. And the ability to take small, simple parsers and easily combine them into larger, more complex ones.

* **Performance**: Parsers that have been composed of many smaller parts should perform as well as highly-tuned, hand-written parsers.

* **Generality**: Ability to parse _any_ kind of input into _any_ kind of output. This allows you to choose which abstraction levels you want to work on based on how much performance you need or how much correctness you want guaranteed. For example, you can write a highly tuned parser on collections of UTF-8 code units, and it will automatically plug into parsers of strings, arrays, unsafe buffer pointers and more.

[Motivation](#motivation)<br>
[Getting started](#getting-started)<br>
[Design](#design)<br>
[Benchmarks](#benchmarks)<br>
[Documentation](#documentation)<br>
[Other libraries](#other-libraries)<br>
[License](#license)<br>

## Learn More

This library was designed over the course of many [episodes](https://www.pointfree.co/collections/parsing) on [Point-Free](https://www.pointfree.co), a video series exploring functional programming and the Swift language, hosted by [Brandon Williams](https://twitter.com/mbrandonw) and [Stephen Celis](https://twitter.com/stephencelis). You can watch all of the episodes [here](https://www.pointfree.co/collections/parsing).

<a href="https://www.pointfree.co/collections/parsing">
  <img alt="video poster image" src="https://d3rccdn33rt8ze.cloudfront.net/episodes/0126.jpeg" width="600">
</a>

## Motivation

Parsing is a surprisingly ubiquitous problem in programming. We can define parsing as trying to take a more nebulous blob of data and transform it into something more well-structured. The Swift standard library comes with a number of parsers that we reach for every day. For example, there are initializers on `Int`, `Double`, and even `Bool`, that attempt to parse numbers and booleans from strings:

```swift
Int("42")         // 42
Int("Hello")      // nil

Double("123.45")  // 123.45
Double("Goodbye") // nil

Bool("true")      // true
Bool("0")         // nil
```

And there are types like `JSONDecoder` and `PropertyListDecoder` that attempt to parse `Decodable`-conforming types from data:

```swift
try JSONDecoder().decode(User.self, from: data)
try PropertyListDecoder().decode(Settings.self, from: data)
```

While parsers are everywhere in Swift, Swift has no holistic story _for_ parsing. Instead, we typically parse data in an ad hoc fashion using a number of unrelated initializers, methods, and other means. And this typically leads to less maintainable, less reusable code.

This library aims to write such a story for parsing in Swift. It introduces a single unit of parsing that can be combined in interesting ways to form large, complex parsers that can tackle the programming problems you need to solve in a maintainable way.

## Getting started

Suppose you have a string that holds some user data that you want to parse into an array of `User`s:

```swift
var input = """
1,Blob,true
2,Blob Jr.,false
3,Blob Sr.,true
"""

struct User {
  var id: Int
  var name: String
  var isAdmin: Bool
}
```

A naive approach to this would be a nested use of `.split(separator:)`, and then a little bit of extra work to convert strings into integers and booleans:

```swift
let users = input
  .split(separator: "\n")
  .compactMap { row -> User? in
    let fields = row.split(separator: ",")
    guard
      fields.count == 3,
      let id = Int(fields[0]),
      let isAdmin = Bool(String(fields[2]))
    else { return nil }

    return User(id: id, name: String(fields[1]), isAdmin: isAdmin)
  }
```

Not only is this code a little messy, but it is also inefficient since we are allocating arrays for the `.split` and then just immediately throwing away those values.

It would be more straightforward and efficient to instead describe how to consume bits from the beginning of the input and convert that into users. This is what this parser library excels at 😄.

We can start by describing what it means to parse a single row, first by parsing an integer off the front of the string, and then parsing a comma. We can do this by using the `Parse` type, which acts as an entry point into describing a list of parsers that you want to run one after the other to consume from an input:

```swift
let user = Parse {
  Int.parser()
  ","
}
```

Already this can consume the beginning of the input:

```swift
user.parse(&input) // => 1
input // => "Blob,true\n2,Blob Jr.,false\n3,Blob Sr.,true"
```

Next we want to take everything up until the next comma for the user's name, and then consume the comma:

```swift
let user = Parse { 
  Int.parser()
  ","
  Prefix { $0 != "," }
  ","
}
```

And then we want to take the boolean at the end of the row for the user's admin status:

```swift
let user = Parse {
  Int.parser()
  ","
  Prefix { $0 != "," }
  ","
  Bool.parser()
}
```

Currently this will parse a tuple `(Int, Substring, Bool)` from the input, and we can `.map` on that to turn it into a `User`:

```swift
let user = Parse {
  Int.parser()
  ","
  Prefix { $0 != "," }
  ","
  Bool.parser()
}
.map { User(id: $0, name: String($1), isAdmin: $2) }
```

To make the data we are parsing to more prominent, we can instead pass the transform closure as the first argument to `Parse`:

```swift
let user = Parse {
  User(id: $0, name: String($1), isAdmin: $2)
} with: {
  Int.parser()
  ","
  Prefix { $0 != "," }
  ","
  Bool.parser()
}
```

Or we can pass the `User` initializer to `Parse` in a point-free style by transforming the `Prefix` parser's output from a `Substring` to ` String` first:

```swift
let user = Parse(User.init(id:name:isAdmin:)) {
  Int.parser()
  ","
  Prefix { $0 != "," }.map(String.init)
  ","
  Bool.parser()
}
```

That is enough to parse a single user from the input string, leaving behind a newline and the final two users:

```swift
user.parse(&input) // => User(id: 1, name: "Blob", isAdmin: true)
input // => "\n2,Blob Jr.,false\n3,Blob Sr.,true"
```

To parse multiple users from the input we can use the `Many` parser to run the user parser many times:

```swift
let users = Many {
  user
} separator: {
  "\n"
}

users.parse(&input) // => [User(id: 1, name: "Blob", isAdmin: true), ...]
input // => ""
```

Now this parser can process an entire document of users, and the code is simpler and more straightforward than the version that uses `.split` and `.compactMap`.

Even better, it's more performant. We've written [benchmarks](Sources/swift-parsing-benchmark/ReadmeExample.swift) for these two styles of parsing, and the `.split`-style of parsing is more than twice as slow:

```
name                             time        std        iterations
------------------------------------------------------------------
README Example.Parser: Substring 3426.000 ns ±  63.40 %     385395
README Example.Adhoc             7631.000 ns ±  47.01 %     169332
Program ended with exit code: 0
```

Further, if you are willing write your parsers against `UTF8View` instead of `Substring`, you can eke out even more performance, more than doubling the speed:

```
name                             time        std        iterations
------------------------------------------------------------------
README Example.Parser: Substring 3693.000 ns ±  81.76 %     349763
README Example.Parser: UTF8      1272.000 ns ± 128.16 %     999150
README Example.Adhoc             8504.000 ns ±  59.59 %     151417
```

We can also compare these times to a tool that Apple's Foundation gives us: `Scanner`. It's a type that allows you to consume from the beginning of strings in order to produce values, and provides a nicer API than using `.split`:

```swift
var users: [User] = []
while scanner.currentIndex != input.endIndex {
  guard
    let id = scanner.scanInt(),
    let _ = scanner.scanString(","),
    let name = scanner.scanUpToString(","),
    let _ = scanner.scanString(","),
    let isAdmin = scanner.scanBool()
  else { break }

  users.append(User(id: id, name: name, isAdmin: isAdmin))
  _ = scanner.scanString("\n")
}
```

However, the `Scanner` style of parsing is more than 5 times as slow as the substring parser written above, and more than 15 times slower than the UTF-8 parser:

```
name                             time         std        iterations
-------------------------------------------------------------------
README Example.Parser: Substring  3481.000 ns ±  65.04 %     376525
README Example.Parser: UTF8       1207.000 ns ± 110.96 %    1000000
README Example.Adhoc              8029.000 ns ±  44.44 %     163719
README Example.Scanner           19786.000 ns ±  35.26 %      62125
```

That's the basics of parsing a simple string format, but there's a lot more operators and tricks to learn in order to performantly parse larger inputs. View the [benchmarks](Sources/swift-parsing-benchmark) for examples of real life parsing scenarios.

## Design

### Protocol

The design of the library is largely inspired by the Swift standard library and Apple's Combine framework. A parser is represented as a protocol that many types conform to, and then parser transformations (also known as "combinators") are methods that return concrete types conforming to the parser protocol.

For example, to parse all the characters from the beginning of a substring until you encounter a comma you can use the `Prefix` parser:

```swift
let parser = Prefix { $0 != "," }

var input = "Hello,World"[...]
parser.parse(&input) // => "Hello"
input // => ",World"
```

The type of this parser is:

```swift
Prefix<Substring>
```

We can `.map` on this parser in order to transform its output, which in this case is the string "Hello":

```swift
let parser = Prefix { $0 != "," }
  .map { $0 + "!!!" }

var input = "Hello,World"[...]
parser.parse(&input) // => "Hello!!!"
input // => ",World"
```

The type of this parser is now:

```swift
Parsers.Map<Prefix<Substring>, Substring>
```

Notice how the type of the parser encodes the operations that we performed. This adds a bit of complexity when using these types, but comes with some performance benefits because Swift can usually optimize away the creation of those nested types.

### Result builders

The library takes advantage of Swift's `@resultBuilder` feature to make constructing complex parsers as fluent as possible, and should be reminiscent of how views are constructed in SwiftUI. The main entry point into building a parser is the `Parse` builder:

```swift
Parse {

}
```

In this builder block you can specify parsers that will be run one after another. For example, if you wanted to parse an integer, then a comma, and then a boolean from a string, you can simply do:

```swift
Parse {
  Int.parser()
  ","
  Bool.parser()
}
```

Note that the `String` type conforms to the `Parser` protocol, and represents a parser that consumes that exact string from the beginning of an input if it matches, and otherwise fails.

Many of the parsers and operators that come with the library are configured with parser builders to maximize readability of the parsers. For example, to parse accounting syntax of numbers, where parenthesized numbers are negative, we can use the `OneOf` parser builder:

```swift
let accountingNumber = OneOf {
  Int.parser(isSigned: false)

  Parse {
    "("
    Int.parser(isSigned: false)
    ")"
  }
  .map { -$0 }
}

accountingNumber.parse("100")   // 100
accountingNumber.parse("(100)") // -100
```

### Low-level versus high-level

The library makes it easy to choose which abstraction level you want to work on. Both low-level and high-level have their pros and cons.

Parsing low-level inputs, such as UTF-8 code units, has better performance, but at the cost of potentially losing correctness. The most canonical example of this is trying to parse the character "é", which can be represented in code units as `[233]` or `[101, 769]`. If you don't remember to always parse both representations you may have a bug where you accidentally fail your parser when it encounters a code unit sequence you don't support.

On the other hand, parsing high-level inputs, such as `String`, can guarantee correctness, but at the cost of performance. For example, `String` handles the complexities of extended grapheme clusters and UTF-8 normalization for you, but traversing strings is slower since its elements are variable width.

The library gives you the tools that allow you to choose which abstraction level you want to work on, as well as the ability to fluidly move between abstraction levels where it makes sense.

For example, say we want to parse particular city names from the beginning of a string:

```swift
enum City {
  case london
  case newYork
  case sanJose
}
```

Because "San José" has an accented character, the safest way to parse it is to parse on the `Substring` abstraction level:

```swift
let city = OneOf {
  "London".map { City.london }
  "New York".map { City.newYork }
  "San José".map { City.sanJose }
}

var input = "San José,123"
city.parse(&input) // => City.sanJose
input // => ",123"
```

However, we are incurring the cost of parsing `Substring` for this entire parser, even though only the "San José" case needs that power. We can refactor this parser so that "London" and "New York" are parsed on the `UTF8View` level, since they consist of only ASCII characters, and then parse "San José" as `Substring`:

```swift
let city = OneOf {
  "London".utf8.map { City.london }
  "New York".utf8.map { City.newYork }
  FromSubstring { "San José" }
    .map { City.sanJose }
}
```

The `FromSubstring` parser allows us to temporarily leave the world of parsing UTF-8 and instead work on the higher level `Substring` abstraction, which takes care of normalization of the "é" character.

If we wanted to be _really_ pedantic we could even parse "San Jos" as UTF-8 and then parse only the "é" character as a substring:

```swift
let city = OneOf {
  "London".utf8.map { City.london }
  "New York".utf8.map { City.newYork }
  Parse(City.sanJose) {
    "San Jos".utf8
    FromSubstring { "é" }
  }
}
```

This allows you to parse as much as possible on the more performant, low-level `UTF8View`, while still allowing you to parse on the more correct, high-level `Substring` when necessary.

## Benchmarks

This library comes with a benchmark executable that not only demonstrates the performance of the library, but also provides a wide variety of parsing examples:

* [URL router](Sources/swift-parsing-benchmark/Routing.swift)
* [Xcode test logs](Sources/swift-parsing-benchmark/XcodeLogs)
* [Simplified CSV](Sources/swift-parsing-benchmark/CSV)
* [Hex color](Sources/swift-parsing-benchmark/Color.swift)
* [ISO8601 date](Sources/swift-parsing-benchmark/Date.swift)
* [HTTP request](Sources/swift-parsing-benchmark/HTTP.swift)
* [Simplified JSON](Sources/swift-parsing-benchmark/JSON.swift)
* [Arithmetic grammar](Sources/swift-parsing-benchmark/Arithmetic.swift)
* and more

These are the times we currently get when running the benchmarks:

```text
MacBook Pro (16-inch, 2021)
Apple M1 Pro (10 cores, 8 performance and 2 efficiency)
32 GB (LPDDR5)

name                                         time            std        iterations
----------------------------------------------------------------------------------
Arithmetic.Parser                                1000.000 ns ±  15.80 %    1000000
BinaryData.Parser                                 250.000 ns ±  34.95 %    1000000
Bool.Bool.init                                      0.000 ns ±    inf %    1000000
Bool.BoolParser                                    42.000 ns ±  60.93 %    1000000
Bool.Scanner.scanBool                             584.000 ns ±  16.36 %    1000000
Color.Parser                                      208.000 ns ±  25.44 %    1000000
CSV.Parser                                    1387958.000 ns ±   0.84 %        922
CSV.Ad hoc mutating methods                    863479.000 ns ±   2.49 %       1656
Date.Parser                                      5875.000 ns ±   6.55 %     241380
Date.DateFormatter                              24166.000 ns ±   3.50 %      56837
Date.ISO8601DateFormatter                       32625.000 ns ±   3.53 %      42868
HTTP.HTTP                                        4875.000 ns ±   5.85 %     286041
JSON.Parser                                      5917.000 ns ±   3.99 %     224290
JSON.JSONSerialization                           1708.000 ns ±  11.68 %     802207
Numerics.Int.init                                  41.000 ns ±  69.46 %    1000000
Numerics.Int.parser                                42.000 ns ±  60.40 %    1000000
Numerics.Scanner.scanInt                          125.000 ns ±  33.94 %    1000000
Numerics.Comma separated: Int.parser          3279938.000 ns ±   0.75 %        279
Numerics.Comma separated: Scanner.scanInt    52291583.000 ns ±   0.43 %         27
Numerics.Comma separated: String.split       13989062.000 ns ±   0.86 %        100
Numerics.Double.init                               42.000 ns ± 103.43 %    1000000
Numerics.Double.parser                             84.000 ns ±  57.35 %    1000000
Numerics.Scanner.scanDouble                       167.000 ns ±  30.26 %    1000000
Numerics.Comma separated: Double.parser       9871333.500 ns ±   1.03 %        116
Numerics.Comma separated: Scanner.scanDouble 54031625.000 ns ±   0.39 %         26
Numerics.Comma separated: String.split       18210792.000 ns ±   0.68 %         77
PrefixUpTo.Parser                               13292.000 ns ±   3.85 %     104936
PrefixUpTo.Scanner.scanUpToString               97500.000 ns ±   1.22 %      14267
Race.Parser                                     27041.000 ns ±   3.84 %      51576
README Example.Parser: Substring                 2375.000 ns ±  11.91 %     583192
README Example.Parser: UTF8                       875.000 ns ±  14.26 %    1000000
README Example.Adhoc                             3334.000 ns ±   7.75 %     412681
README Example.Scanner                          14708.000 ns ±   5.34 %      94978
Routing.Parser                                   3375.000 ns ±   7.23 %     409775
String Abstractions.Substring                  613292.000 ns ±   0.85 %       2273
String Abstractions.UTF8                        35583.000 ns ±   1.78 %      23918
UUID.UUID.init                                    209.000 ns ±  30.39 %    1000000
UUID.UUIDParser                                   375.000 ns ±  20.14 %    1000000
Xcode Logs.Parser                             3335583.000 ns ±   0.97 %        417
```

## Documentation

The latest documentation for swift-parsing is available [here](https://pointfreeco.github.io/swift-parsing/).

## Other libraries

There are a few other parsing libraries in the Swift community that you might also be interested in:

* [Sparse](https://github.com/johnpatrickmorgan/Sparse)
* [SwiftParsec](https://github.com/davedufresne/SwiftParsec)

## License

This library is released under the MIT license. See [LICENSE](LICENSE) for details.
