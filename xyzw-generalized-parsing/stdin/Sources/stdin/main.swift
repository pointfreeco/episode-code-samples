print("Starting...")
while let line = readLine() {
  print("You typed: \(line)")
}
print("Done!")

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

Array(1...1_000_000_000)

var naturals = sequence(first: 0, next: { $0 + 1 })
var oneBillion = sequence(first: 0, next: { $0 < 1_000_000_000 ? $0 + 1 : nil })

let randomNumbers = AnyIterator {
  // produce next value
  Int.random(in: 1 ... .max)
}

let stdin = AnyIterator { readLine() }

var stdinLogs: Substring = ""
var results: [TestResult] = []
while let line = readLine() {
  stdinLogs.append(contentsOf: line)
  stdinLogs.append("\n")
  if let result = testResult.run(&stdinLogs) {
    results.append(result)
  }
}
results.forEach { result in
  print(format(result: result))
}
