let plainFieldProtocol = PrefixWhile<Substring.UTF8View> {
  $0 != .init(ascii: ",") && $0 != .init(ascii: "\n")
}
let quotedFieldProtocol = Prefix("\""[...].utf8)
  .take(PrefixWhile { $0 != .init(ascii: "\"") })
  .skip(Prefix("\""[...].utf8))
let fieldProtocol = OneOf(quotedFieldProtocol, plainFieldProtocol)
let lineProtocol = ZeroOrMore(fieldProtocol, separatedBy: Prefix(","[...].utf8))
let csvProtocol = ZeroOrMore(lineProtocol, separatedBy: Prefix("\n"[...].utf8))

// ---

let plainFieldUtf8 = Parser<Substring.UTF8View, Substring.UTF8View>
  .prefix(while: { $0 != .init(ascii: ",") && $0 != .init(ascii: "\n") })
let quotedFieldUtf8 = Parser<Substring.UTF8View, Void>.prefix("\""[...].utf8)
  .take(.prefix(while: { $0 != .init(ascii: "\"") }))
  .skip(.prefix("\""[...].utf8))
let fieldUtf8 = Parser.oneOf(quotedFieldUtf8, plainFieldUtf8)
let lineUtf8 = fieldUtf8.zeroOrMore(separatedBy: .prefix(","[...].utf8))
let csvUtf8 = lineUtf8.zeroOrMore(separatedBy: .prefix("\n"[...].utf8))

// ---


let plainFieldSubstring = Parser<Substring, Substring>
  .prefix(while: { $0 != "," && $0 != "\n" })
let quotedFieldSubstring = Parser<Substring, Void>.prefix("\"")
  .take(.prefix(while: { $0 != "\"" }))
  .skip("\"")
let fieldSubstring = Parser.oneOf(quotedFieldSubstring, plainFieldSubstring)
let lineSubstring = fieldSubstring.zeroOrMore(separatedBy: ",")
let csvSubstring = lineSubstring.zeroOrMore(separatedBy: "\n")

// ---


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
    let field = self.remove(while: { $0 != UTF8.CodeUnit(ascii: "\"") })
    self.removeFirst()
    return field
  }

  mutating func parsePlainField() -> Substring.UTF8View {
    self.remove(while: { $0 != UTF8.CodeUnit(ascii: ",") && $0 != UTF8.CodeUnit(ascii: "\n") })
  }

  mutating func remove(while condition: (Substring.UTF8View.Element) -> Bool) -> Substring.UTF8View {
    let prefix = self.prefix(while: condition)
    self.removeFirst(prefix.count)
    return prefix
  }
}

func loopParseCSV(_ input: String) -> [[Substring.UTF8View]] {
  var result: [[Substring.UTF8View]] = [[]]
  var startIndex = input.utf8.startIndex
  var endIndex = startIndex
  var isInQuotes = false

  for c in input.utf8 {
    switch c {
    case .init(ascii: ","):
      guard !isInQuotes else { continue }
      result[result.endIndex-1].append(input.utf8[startIndex ..< endIndex])
      startIndex = input.utf8.index(after: endIndex)

    case .init(ascii: "\n"):
      guard !isInQuotes else { continue }
      result[result.endIndex-1].append(input.utf8[startIndex ..< endIndex])
      startIndex = input.utf8.index(after: endIndex)
      result.append([])

    case .init(ascii: "\""):
      isInQuotes.toggle()

    default:
      break
    }
    input.utf8.formIndex(after: &endIndex)
  }

  result[result.endIndex-1].append(input.utf8[startIndex ..< endIndex])
  startIndex = input.utf8.index(after: endIndex)

  return result
}

extension String {
  func parseImperativeUtf8() -> [[Substring.UTF8View]] {
    var result: [[Substring.UTF8View]] = [[]]
    var startIndex = self.utf8.startIndex
    var endIndex = startIndex
    var wasInQuotes = false
    var inQuotes = false

    for c in self.utf8 {
      switch (c, inQuotes) {
      case (.init(ascii: ","), false):
        result[result.endIndex-1].append(self.utf8[startIndex ..< (wasInQuotes ? self.utf8.index(before: endIndex) : endIndex)])
        startIndex = self.utf8.index(after: endIndex)
        wasInQuotes = false

      case (.init(ascii: "\n"), false):
        result[result.endIndex-1].append(self.utf8[startIndex ..< (wasInQuotes ? self.utf8.index(before: endIndex) : endIndex)])
        startIndex = self.utf8.index(after: endIndex)
        result.append([])
        wasInQuotes = false

      case (.init(ascii: "\""), _):
        wasInQuotes = inQuotes
        if !inQuotes {
          startIndex = self.utf8.index(after: startIndex)
        }
        inQuotes = !inQuotes

      default:
        break
      }
      endIndex = self.utf8.index(after: endIndex)
    }
    result[result.endIndex-1].append(self.utf8[startIndex ..< (wasInQuotes ? self.utf8.index(before: endIndex) : endIndex)])
    startIndex = self.utf8.index(after: endIndex)
    return result
  }
}
