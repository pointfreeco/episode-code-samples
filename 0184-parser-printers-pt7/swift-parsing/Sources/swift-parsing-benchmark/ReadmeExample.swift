import Benchmark
import Foundation
import Parsing

/// This benchmark measures the performance of the examples given in the library's README.
let readmeExampleSuite = BenchmarkSuite(name: "README Example") { suite in
  let input = """
    1,Blob,true
    2,Blob Jr.,false
    3,Blob Sr.,true
    """
  let expectedOutput = [
    User(id: 1, name: "Blob", isAdmin: true),
    User(id: 2, name: "Blob Jr.", isAdmin: false),
    User(id: 3, name: "Blob Sr.", isAdmin: true),
  ]
  var output: [User]!

  struct User: Equatable {
    var id: Int
    var name: String
    var isAdmin: Bool
  }

  do {
    let user = Parse(User.init(id:name:isAdmin:)) {
      Int.parser()
      ","
      Prefix { $0 != "," }.map(String.init)
      ","
      Bool.parser()
    }
    let users = Many {
      user
    } separator: {
      "\n"
    } terminator: {
      End()
    }

    suite.benchmark("Parser: Substring") {
      var input = input[...]
      output = try users.parse(&input)
    } tearDown: {
      precondition(output == expectedOutput)
    }
  }

  do {
    let user = Parse(User.init(id:name:isAdmin:)) {
      Int.parser()
      ",".utf8
      Prefix { $0 != .init(ascii: ",") }.map { String(Substring($0)) }
      ",".utf8
      Bool.parser()
    }
    let users = Many {
      user
    } separator: {
      "\n".utf8
    } terminator: {
      End()
    }

    suite.benchmark("Parser: UTF8") {
      var input = input[...].utf8
      output = try users.parse(&input)
    } tearDown: {
      precondition(output == expectedOutput)
    }
  }

  suite.benchmark("Ad hoc") {
    output =
      input
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
  } tearDown: {
    precondition(output == expectedOutput)
  }

  if #available(macOS 10.15, *) {
    let scanner = Scanner(string: input)
    suite.benchmark("Scanner") {
      output = []
      while scanner.currentIndex != input.endIndex {
        guard
          let id = scanner.scanInt(),
          let _ = scanner.scanString(","),
          let name = scanner.scanUpToString(","),
          let _ = scanner.scanString(","),
          let isAdmin = scanner.scanBool()
        else { break }

        output.append(User(id: id, name: name, isAdmin: isAdmin))
        _ = scanner.scanString("\n")
      }
    } setUp: {
      scanner.currentIndex = input.startIndex
    } tearDown: {
      precondition(output == expectedOutput)
    }
  }
}
