import Benchmark
import Foundation
import Parsing

/// This benchmark shows how to create a naive JSON parser with combinators.
///
/// It is mostly implemented according to the [spec](https://www.json.org/json-en.html) (we take a
/// shortcut and use `Double.parser()`, which behaves accordingly).
let jsonSuite = BenchmarkSuite(name: "JSON") { suite in
  enum JSONValue: Equatable {
    case array([Self])
    case boolean(Bool)
    case null
    case number(Double)
    case object([String: Self])
    case string(String)
  }

  var json: AnyParser<Substring.UTF8View, JSONValue>!

  let unicode = Prefix(4) {
    (.init(ascii: "0") ... .init(ascii: "9")).contains($0)
      || (.init(ascii: "A") ... .init(ascii: "F")).contains($0)
      || (.init(ascii: "a") ... .init(ascii: "f")).contains($0)
  }
  .compactMap {
    UInt32(Substring($0), radix: 16)
      .flatMap(UnicodeScalar.init)
      .map(String.init)
  }

  let string = Parse {
    "\"".utf8
    Many(into: "") { string, fragment in
      string.append(contentsOf: fragment)
    } element: {
      OneOf {
        Prefix(1...) { $0 != .init(ascii: "\"") && $0 != .init(ascii: "\\") }
          .map { String(Substring($0)) }

        Parse {
          "\\".utf8

          OneOf {
            "\"".utf8.map { "\"" }
            "\\".utf8.map { "\\" }
            "/".utf8.map { "/" }
            "b".utf8.map { "\u{8}" }
            "f".utf8.map { "\u{c}" }
            "n".utf8.map { "\n" }
            "r".utf8.map { "\r" }
            "t".utf8.map { "\t" }
            unicode
          }
        }
      }
    } terminator: {
      "\"".utf8
    }
  }

  let object = Parse {
    "{".utf8
    Many(into: [String: JSONValue]()) { object, pair in
      let (name, value) = pair
      object[name] = value
    } element: {
      Skip { Whitespace() }
      string
      Skip { Whitespace() }
      ":".utf8
      Lazy { json! }
    } separator: {
      ",".utf8
    } terminator: {
      "}".utf8
    }
  }

  let array = Parse {
    "[".utf8
    Many {
      Lazy { json! }
    } separator: {
      ",".utf8
    } terminator: {
      "]".utf8
    }
  }

  json = Parse {
    Skip { Whitespace() }
    OneOf {
      object.map(JSONValue.object)
      array.map(JSONValue.array)
      string.map(JSONValue.string)
      Double.parser().map(JSONValue.number)
      Bool.parser().map(JSONValue.boolean)
      "null".utf8.map { JSONValue.null }
    }
    Skip { Whitespace() }
  }
  .eraseToAnyParser()

  let input = #"""
    {
      "hello": true,
      "goodbye": 42.42,
      "whatever": null,
      "xs": [1, "hello", null, false],
      "ys": {
        "0": 2,
        "1": "goodbye"
      }
    }
    """#
  var jsonOutput: JSONValue!
  suite.benchmark("Parser") {
    var input = input[...].utf8
    jsonOutput = try json.parse(&input)
  } tearDown: {
    precondition(
      jsonOutput
        == .object([
          "hello": .boolean(true),
          "goodbye": .number(42.42),
          "whatever": .null,
          "xs": .array([.number(1), .string("hello"), .null, .boolean(false)]),
          "ys": .object([
            "0": .number(2),
            "1": .string("goodbye"),
          ]),
        ])
    )
  }

  let dataInput = Data(input.utf8)
  var objectOutput: Any!
  suite.benchmark("JSONSerialization") {
    objectOutput = try JSONSerialization.jsonObject(with: dataInput, options: [])
  } tearDown: {
    precondition(
      (objectOutput as! NSDictionary) == [
        "hello": true,
        "goodbye": 42.42,
        "whatever": NSNull(),
        "xs": [1, "hello", nil, false],
        "ys": [
          "0": 2,
          "1": "goodbye",
        ],
      ]
    )
  }
}
