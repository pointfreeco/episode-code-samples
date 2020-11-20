//print("Starting...")
//while let line = readLine() {
//  print("You typed: \(line)")
//}
//print("Done!")

struct NaturalNumbers: IteratorProtocol {
  var count = 0
  
  mutating func next() -> Int? {
    defer { self.count += 1 }
    return self.count
  }
}

struct OneBillionNumbers: IteratorProtocol {
  var count = 0
  
  mutating func next() -> Int? {
    defer { self.count += 1 }
    return self.count <= 1_000_000_000
      ? self.count
      : nil
  }
}

//Array(1...1_000_000_000)

var naturals = sequence(first: 0, next: { $0 + 1 })
var oneBillion = sequence(first: 0, next: { $0 < 1_000_000_000 ? $0 + 1 : nil })

let randomNumbers = AnyIterator {
  // produce next value
  Int.random(in: 1 ... .max)
}

// (Parser<Input, Output>) -> Parser<AnyIterator<Input>, [Output]>

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

var stdin = AnyIterator { readLine(strippingNewline: false)?[...] }

testResult
  .stream
  .run(stdin)
  .match?
  .forEach {
    print(format(result: $0))
  }

extension Parser where Input: RangeReplaceableCollection {
  func run(
    input: inout AnyIterator<Input>,
    output streamOut: (Output) -> Void
  ) {
    print("start")
    var buffer = Input()
    while let chunk = input.next() {
      print("chunk", chunk)
      buffer.append(contentsOf: chunk)

      while let output = self.run(&buffer) {
        print("output", output)
        streamOut(output)
      }
    }
    print("done")
  }
}

testResult
  .run(input: &stdin, output: { print(format(result: $0)) })

//
//var stdinLogs: Substring = ""
//var results: [TestResult] = []
//while let line = readLine() {
//  stdinLogs.append(contentsOf: line)
//  stdinLogs.append("\n")
//  if let result = testResult.run(&stdinLogs) {
//    results.append(result)
//  }
//}
//results.forEach { result in
//  print(format(result: result))
//}
