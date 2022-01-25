import Benchmark
import Parsing

/*
 This benchmark reproduces an HTTP parser from a Rust parser benchmark suite:

 https://github.com/rust-bakery/parser_benchmarks/tree/master/http

 In particular, it benchmarks the same HTTP header as that defined in `one_test`.
 */

private struct Request: Equatable {
  let method: String
  let uri: String
  let version: String
}

private struct Header: Equatable {
  let name: String
  let value: [String]
}

private func isToken(_ c: UTF8.CodeUnit) -> Bool {
  switch c {
  case 128...,
    ...31,
    .init(ascii: "("),
    .init(ascii: ")"),
    .init(ascii: "<"),
    .init(ascii: ">"),
    .init(ascii: "@"),
    .init(ascii: ","),
    .init(ascii: ";"),
    .init(ascii: ":"),
    .init(ascii: "\\"),
    .init(ascii: "'"),
    .init(ascii: "/"),
    .init(ascii: "["),
    .init(ascii: "]"),
    .init(ascii: "?"),
    .init(ascii: "="),
    .init(ascii: "{"),
    .init(ascii: "}"),
    .init(ascii: " "):
    return false
  default:
    return true
  }
}

private func notLineEnding(_ c: UTF8.CodeUnit) -> Bool {
  c != .init(ascii: "\r") && c != .init(ascii: "\n")
}

private func isNotSpace(_ c: UTF8.CodeUnit) -> Bool {
  c != .init(ascii: " ")
}

private func isHorizontalSpace(_ c: UTF8.CodeUnit) -> Bool {
  c == .init(ascii: " ") || c == .init(ascii: "\t")
}

private func isVersion(_ c: UTF8.CodeUnit) -> Bool {
  c >= .init(ascii: "0")
    && c <= .init(ascii: "9")
    || c == .init(ascii: ".")
}

private let method = Prefix(while: isToken)
  .map { String(Substring($0)) }

private let uri = Prefix(while: isNotSpace)
  .map { String(Substring($0)) }

private let httpVersion = "HTTP/".utf8
  .take(Prefix(while: isVersion))
  .map { String(Substring($0)) }

private let requestLine =
  method
  .skip(" ".utf8)
  .take(uri)
  .skip(" ".utf8)
  .take(httpVersion)
  .skip(Newline())
  .map(Request.init)

private let headerValue = " ".utf8.orElse("\t".utf8)
  .skip(Prefix(while: isHorizontalSpace))
  .take(
    Prefix(while: notLineEnding)
      .map { String(Substring($0)) }
  )
  .skip(Newline())

private let header = Prefix(while: isToken)
  .map { String(Substring($0)) }
  .skip(":".utf8)
  .take(Many(headerValue))
  .map(Header.init)

private let request = requestLine.take(Many(header))

let httpSuite = BenchmarkSuite(name: "HTTP") { suite in
  let input = """
    GET / HTTP/1.1
    Host: www.reddit.com
    User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.8; rv:15.0) Gecko/20100101 Firefox/15.0.1
    Accept: text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8
    Accept-Language: en-us,en;q=0.5
    Accept-Encoding: gzip, deflate
    Connection: keep-alive

    """
  let expected = (
    Request(method: "GET", uri: "/", version: "1.1"),
    [
      Header(name: "Host", value: ["www.reddit.com"]),
      Header(
        name: "User-Agent",
        value: [
          "Mozilla/5.0 (Macintosh; Intel Mac OS X 10.8; rv:15.0) Gecko/20100101 Firefox/15.0.1"
        ]
      ),
      Header(
        name: "Accept",
        value: ["text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8"]
      ),
      Header(name: "Accept-Language", value: ["en-us,en;q=0.5"]),
      Header(name: "Accept-Encoding", value: ["gzip, deflate"]),
      Header(name: "Connection", value: ["keep-alive"]),
    ]
  )
  var output: (Request, [Header])!
  suite.benchmark(
    name: "HTTP",
    run: { output = request.parse(input) },
    tearDown: { precondition(output == expected) }
  )
}
