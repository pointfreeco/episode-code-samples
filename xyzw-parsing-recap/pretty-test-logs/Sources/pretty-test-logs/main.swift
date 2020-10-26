extension Parser where Input: RangeReplaceableCollection {
  var stream: Parser<AnyIterator<Input>, [Output]> {
    .init { stream in
      var buffer = Input()
      var outputs: [Output] = []
      while let chunk = stream.next() {
        buffer.append(contentsOf: chunk)
        while let output = self.run(&buffer) {
          outputs.append(output)
        }
      }
      return outputs
    }
  }
}
extension Parser {
  func handleEvents(receiveOutput: @escaping (Output) -> Void) -> Self {
    .init { input in
      guard let output = self.run(&input) else { return nil }
      receiveOutput(output)
      return output
    }
  }
}
var stdin = AnyIterator(logs.split(separator: "\n").map { $0 + "\n" }.makeIterator())


extension Parser where Input: RangeReplaceableCollection {
  func run(
    input: inout AnyIterator<Input>,
    output streamOut: @escaping (Output) -> Void
  ) {
    Parser<AnyIterator<Input>, Void> { stream in
      var buffer = Input()
      while let chunk = stream.next() {
        buffer.append(contentsOf: chunk)
        while let output = self.run(&buffer) {
          streamOut(output)
        }
      }
      return ()
    }
    .run(&input)
  }
}

print("Starting...")


Parser.oneOf(
  testResult.map(Optional.some),
  Parser.prefix(upTo: "Test Case '-[").map { _ in nil },
  Parser.rest.map { _ in nil }
)
  .run(
    input: &stdin,
    output: {
      if let result = $0 {
        print(format(result: result))
      }
    }
  )

import XCTest

class TestParser {

}



var stdinLogs: Substring = ""
var results: [TestResult] = []
while let line = readLine() {
  stdinLogs.append(contentsOf: line)
  stdinLogs.append("\n")
  if let output = testResult.run(&stdinLogs) {
    results.append(output)
  }
}

results.forEach { result in
  print(format(result: result))
}

//let stdin = AnyIterator { }
//
//testResult
//  .stream
//  .run

//testResults.run(stdinLogs[...]).match?.forEach { result in
//  print(format(result: result))
//}
