import Benchmark

let csvSuite = BenchmarkSuite(name: "CSV") { suite in
  do {
    let quotedField = Parser<Substring, Void>.prefix("\"")
      .take(.prefix(while: { $0 != "\"" }))
      .skip("\"")
    let plainField = Parser<Substring, Substring>
      .prefix(while: { $0 != "," && $0 != "\n" && $0 != "\r\n" })
    let field = Parser.oneOf(quotedField, plainField)
    let line = field.zeroOrMore(separatedBy: ",")
    let csv = line.zeroOrMore(separatedBy: .oneOf("\n", "\r\n"))
    
    suite.benchmark("Parser: Substring") {
      var input = csvSample[...]
      let output = csv.run(&input)
      precondition(output!.count == 1000)
      precondition(output!.allSatisfy { $0.count == 5 && $0.last?.last != "\r" })
    }
  }
  
  do {
    let quotedField = Parser<Substring.UTF8View, Void>.prefix("\""[...].utf8)
      .take(.prefix(while: { $0 != .init(ascii: "\"") }))
      .skip(.prefix("\""[...].utf8))
    let plainField = Parser<Substring.UTF8View, Substring.UTF8View>
      .prefix(while: { $0 != .init(ascii: ",") && $0 != .init(ascii: "\n") })
    let field = Parser.oneOf(quotedField, plainField)
    let line = field.zeroOrMore(separatedBy: .prefix(","[...].utf8))
      .map { fields -> [Substring.UTF8View] in
        guard fields.last?.last == .init(ascii: "\r")
        else { return fields }
        var fields = fields
        fields[fields.count - 1].removeLast()
        return fields
      }
    let csv = line.zeroOrMore(separatedBy: .prefix("\n"[...].utf8))

    suite.benchmark("Parser: UTF8") {
      var input = csvSample[...].utf8
      let output = csv.run(&input)
      precondition(output!.count == 1000)
      precondition(output!.allSatisfy { $0.count == 5 && $0.last?.last != .init(ascii: "\r") })
    }
  }
  
  do {
    let quotedField = Prefix("\""[...].utf8)
      .take(PrefixWhile { $0 != .init(ascii: "\"") })
      .skip(Prefix("\""[...].utf8))
    let plainField = PrefixWhile<Substring.UTF8View> {
      $0 != .init(ascii: ",") && $0 != .init(ascii: "\n")
    }
    let field = OneOf(quotedField, plainField)
    let line = field.zeroOrMore(separatedBy: Prefix(","[...].utf8))
      .map { fields -> [Substring.UTF8View] in
        guard fields.last?.last == .init(ascii: "\r")
        else { return fields }
        var fields = fields
        fields[fields.count - 1].removeLast()
        return fields
      }
    let csv = line.zeroOrMore(separatedBy: Prefix("\n"[...].utf8))

    suite.benchmark("ParserProtocol") {
      var input = csvSample[...].utf8
      let output = csv.run(&input)
      precondition(output!.count == 1000)
      precondition(output!.allSatisfy { $0.count == 5 && $0.last?.last != .init(ascii: "\r") })
    }
  }

  suite.benchmark("Mutating methods") {
    var input = csvSample[...].utf8
    let output = input.parseCSV()
    precondition(output.count == 1000)
    precondition(output.allSatisfy { $0.count == 5 && $0.last?.last != .init(ascii: "\r") })
  }

  suite.benchmark("Imperative loop") {
    let output = loopParseCSV(csvSample)
    precondition(output.count == 1000)
    precondition(output.allSatisfy { $0.count == 5 && $0.last?.last != .init(ascii: "\r") })
  }
}

// 1,"Blob",true
// [["1", "\"Blob\"", "true"]]

func loopParseCSV(_ input: String) -> [[Substring.UTF8View]] {
  var results: [[Substring.UTF8View]] = [[]]

  var startIndex = input.utf8.startIndex
  var endIndex = startIndex
  var isInQuotes = false
  var isInCarriageReturn = false

  for c in input.utf8 {
    switch c {
    case .init(ascii: ","):
      isInCarriageReturn = false
      guard !isInQuotes else { continue }

      results[results.count - 1].append(
        input.utf8[startIndex ..< endIndex]
      )
      startIndex = input.utf8.index(after: endIndex)

    case .init(ascii: "\n"):
      defer { isInCarriageReturn = false }
      guard !isInQuotes else { continue }

      let newEndIndex = isInCarriageReturn
        ? input.utf8.index(before: endIndex)
        : endIndex

      results[results.count - 1].append(
        input.utf8[startIndex ..< newEndIndex]
      )
      startIndex = input.utf8.index(after: endIndex)
      results.append([])

    case .init(ascii: "\""):
      isInCarriageReturn = false
      isInQuotes.toggle()

    case .init(ascii: "\r"):
      isInCarriageReturn = true

    default:
      isInCarriageReturn = false
      break
    }

    endIndex = input.utf8.index(after: endIndex)
  }

  results[results.count - 1].append(
    input.utf8[startIndex ..< endIndex]
  )

  return results
}

extension Substring.UTF8View {
  mutating func parseCSV() -> [[Substring.UTF8View]] {
    var results: [[Substring.UTF8View]] = []
    while !self.isEmpty {
      results.append(self.parseLine())
      if self.first == .init(ascii: "\n") {
        self.removeFirst()
      }
    }
    return results
  }

  mutating func parseLine() -> [Substring.UTF8View] {
    var fields: [Substring.UTF8View] = []

    while true {
      fields.append(self.parseField())
      if self.first == .init(ascii: ",") {
        self.removeFirst()
      } else {
        break
      }
    }

    if fields.last?.last == .init(ascii: "\r") {
      fields[fields.count - 1].removeLast()
    }

    return fields
  }

  mutating func parseField() -> Substring.UTF8View {
    if self.first == .init(ascii: "\"") {
      return self.parseQuotedField()
    } else {
      return self.parsePlainField()
    }
  }

  mutating func parseQuotedField() -> Substring.UTF8View {
    self.removeFirst()
    let field = self.prefix { $0 != .init(ascii: "\"") }
    self.removeFirst(field.count)
    self.removeFirst()
    return field
  }

  mutating func parsePlainField() -> Substring.UTF8View {
    let field = self.prefix { $0 != .init(ascii: ",") && $0 != .init(ascii: "\n") }
    self.removeFirst(field.count)
    return field
  }
}
