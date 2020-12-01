import Benchmark

let csvSuite = BenchmarkSuite(name: "CSV") { suite in
  do {
    let quotedField = Parser<Substring, Void>.prefix("\"")
      .take(.prefix(while: { $0 != "\"" }))
      .skip("\"")
    let plainField = Parser<Substring, Substring>
      .prefix(while: { $0 != "," && $0 != "\n" })
    let field = Parser.oneOf(quotedField, plainField)
    let line = field.zeroOrMore(separatedBy: ",")
    let csv = line.zeroOrMore(separatedBy: "\n")
    
    suite.benchmark("Parser: Substring") {
      var input = csvSample[...]
      let output = csv.run(&input)
      precondition(output!.count == 1000)
      precondition(output!.allSatisfy { $0.count == 5 })
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
    let csv = line.zeroOrMore(separatedBy: .prefix("\n"[...].utf8))

    suite.benchmark("Parser: UTF8") {
      var input = csvSample[...].utf8
      let output = csv.run(&input)
      precondition(output!.count == 1000)
      precondition(output!.allSatisfy { $0.count == 5 })
    }
  }
}
