let plainField = Parser<Substring.UTF8View, Substring.UTF8View>
  .prefix(while: { $0 != .init(ascii: ",") && $0 != .init(ascii: "\n") })

let quotedField = Parser<Substring.UTF8View, Void>.prefix("\""[...].utf8)
  .take(.prefix(while: { $0 != .init(ascii: "\"") }))
  .skip(Parser.prefix("\""[...].utf8))

let field = Parser.oneOf(quotedField, plainField)
  .map { String(Substring($0)) }

let line = field.zeroOrMore(separatedBy: .prefix(","[...].utf8))

let csv = line.zeroOrMore(separatedBy: .oneOf(.prefix("\n"[...].utf8), .prefix("\r\n"[...].utf8)))

extension Substring.UTF8View {
  mutating func parseCsv() -> [[String]] {
    var results: [[String]] = []
    while !self.isEmpty {
      results.append(self.parseLine())
    }
    return results
  }

  mutating func parseLine() -> [String] {
    var row: [String] = []
    while true {
      row.append(self.parseField())

      if self.first == UTF8.CodeUnit(ascii: "\n") || self.isEmpty {
        if !self.isEmpty {
          self.removeFirst()
        }
        break
      } else if self.starts(with: "\r\n"[...].utf8) {
        self.removeFirst(2)
        break
      } else if self.first == UTF8.CodeUnit(ascii: ",") {
        self.removeFirst()
      }
    }
    return row
  }

  mutating func parseField() -> String {
    if self.first == UTF8.CodeUnit(ascii: "\"") {
      return String(Substring(self.parseQuotedField()))
    } else {
      return String(Substring(self.parsePlainField()))
    }
  }

  mutating func parseQuotedField() -> Substring.UTF8View {
    self.removeFirst()
    let field = self.remove(while: { $0 != UTF8.CodeUnit(ascii: "\"") })
    self.removeFirst()
    return field
  }

  mutating func parsePlainField() -> Substring.UTF8View {
    self.remove(while: { $0 != UTF8.CodeUnit(ascii: "\n") && $0 != UTF8.CodeUnit(ascii: ",") })
  }

  mutating func remove(while condition: (Substring.UTF8View.Element) -> Bool) -> Substring.UTF8View {
    let prefix = self.prefix(while: condition)
    self.removeFirst(prefix.count)
    return prefix
  }
}


extension String {
  func parseImperativeUtf8() -> [[String]] {
    var result: [[String]] = [[]]
    var startIndex = self.utf8.startIndex
    var endIndex = startIndex
    var inQuotes = false

    @inline(__always) func flush() {
      result[result.endIndex-1].append(String(self.utf8[startIndex..<endIndex])!)
      startIndex = self.utf8.index(after: endIndex)
    }

    for c in self.utf8 {
      switch (c, inQuotes) {
      case (.init(ascii: ","), false):
        flush()
      case (.init(ascii: "\n"), false):
        flush()
        result.append([])
      case (.init(ascii: "\""), _):
        inQuotes = !inQuotes
      default:
        break
      }
      endIndex = self.utf8.index(after: endIndex)
    }
    flush()
    return result
  }
}
