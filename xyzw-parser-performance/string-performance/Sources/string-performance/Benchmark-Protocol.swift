import Benchmark

let protocolSuite = BenchmarkSuite(name: "Protocol") { suite in
  let string = "1234567890"

//  suite.benchmark("Parser.int") {
//    var string = string[...].utf8
//    precondition(Parser.int.run(&string) == 1234567890)
//  }
//
//  suite.benchmark("IntParser") {
//    var string = string[...].utf8
//    precondition(IntParser().run(&string) == 1234567890)
//  }

//  let parser1 = Parser<Substring.UTF8View, Int>.int
//    .take(.first)
//    .take(.int)
//    .take(.first)
//    .take(.int)
//    .take(.first)
//    .take(.int)
//    .take(.first)
//    .take(.int)
//  suite.benchmark("Deeply nested: Parser") {
//    var input = "1-2-3-4-5"[...].utf8
//
//    let output = parser1.run(&input)
//    precondition(output != nil)
//    precondition(input.isEmpty)
//  }

  let parser2 = IntParser()
    .take(First())
    .take(IntParser())
    .take(First())
    .take(IntParser())
    .take(First())
    .take(IntParser())
    .take(First())
    .take(IntParser())
  suite.benchmark("Deeply nested: ParserProtocol") {
    var input = "1-2-3-4-5"[...].utf8

    let output = parser2.run(&input)

    precondition(output != nil)
    precondition(input.isEmpty)
  }
}

//let csv = #"""
//id,name,isAdmin
//1,"Blob",true
//2,"Blob Jr",false
//3,"Blob Sr",true
//4,"Blob, ""Esq.""",false
//"""#
//
//// [[String]]
