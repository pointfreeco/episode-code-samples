import Benchmark

let protocolSuite = BenchmarkSuite(name: "Protocol") { suite in
  let string = "1234567890"

//  suite.benchmark("Parser.int") {
//    var string = string[...].utf8
//    precondition(Parser.int.run(&string) == 1234567890)
//  }
//
//  suite.benchmark("IntParser") {
//    var input = string[...].utf8
//    _ = IntParser().parse(&input)
//  }

  let p1 = Parser<Substring.UTF8View, Int>.int
    .take(.first)
    .take(.int)
    .take(.first)
    .take(.int)
    .take(.first)
    .take(.int)
    .take(.first)
    .take(.int)
  suite.benchmark("Deeply nested: Parser") {
    var input = "1-2-3-4-5"[...].utf8
    let output = p1.run(&input)
    precondition(output != nil)
    precondition(input.isEmpty)
  }

  suite.benchmark("Deeply nested: ParserProtocol") {
    var input = "1-2-3-4-5"[...].utf8
    let output = IntParser()
      .take(First())
      .take(IntParser())
      .take(First())
      .take(IntParser())
      .take(First())
      .take(IntParser())
      .take(First())
      .take(IntParser())
      .parse(&input)

    precondition(output != nil)
    precondition(input.isEmpty)
  }
}

//
//let f = {
//  {
//    {
//      {
//        {
//          {
//            {
//              {
//                {
//                  max(1, 100)
//                }
//              }
//            }
//          }
//        }
//      }
//    }
//  }
//}
//
////  suite.benchmark("External Closure", settings: Iterations(5_000_000)) {
////    precondition(f()()()()()()()()() == 100)
////  }
////
////  suite.benchmark("Inlined Closure", settings: Iterations(5_000_000)) {
////    let f = {
////      {
////        {
////          {
////            {
////              {
////                {
////                  {
////                    {
////                      100
////                    }
////                  }
////                }
////              }
////            }
////          }
////        }
////      }
////    }
////    precondition(f()()()()()()()()() == 100)
////  }
////
//

//
//    let originalParser = Parser.int
//      .take(.prefix("-"[...].utf8))
//      .take(.prefix("-"[...].utf8))
//      .take(.prefix("-"[...].utf8))
//      .take(.prefix("-"[...].utf8))
//      .take(.prefix("-"[...].utf8))
//      .take(.int)
//    let t1 = Parser<Substring.UTF8View, UInt8>.first
//      .take(.first)
//      .take(.first)
//      .take(.first)
//      .take(.first)
//      .take(.first)
//      .take(.first)
//      .take(.first)
//    suite.benchmark("Comma Separated: Original") {
//      var string = "12345678"[...].utf8
//
//      let output = t1
//        .run(&string)
//      precondition(output != nil)
//    }
//
//    let p1 = Take2(IntParser(), Prefix("-"[...].utf8))
//    let p2 = Take2(p1, Prefix("-"[...].utf8))
//    let p3 = Take2(p2, Prefix("-"[...].utf8))
//    let p4 = Take2(p3, Prefix("-"[...].utf8))
//    let p5 = Take2(p4, Prefix("-"[...].utf8))
//  //  let p6 = SkipSecond(p5, Prefix("-"[...].utf8))
//  //  let p7 = SkipSecond(p6, Prefix("-"[...].utf8))
//  //  let p8 = SkipSecond(p7, Prefix("-"[...].utf8))
//  //  let p9 = SkipSecond(p8, Prefix("-"[...].utf8))
//  //  let p10 = SkipSecond(p9, Prefix("-"[...].utf8))
//    let protocolParser = Take2(p5, IntParser())
//
//    let q1 = Take2(First<Substring.UTF8View>(), First())
//    let q2 = Take2(q1, First())
//    let q3 = Take2(q2, First())
//    let q4 = Take2(q3, First())
//    let q5 = Take2(q4, First())
//    let q6 = Take2(q5, First())
//    let q7 = Take2(q6, First())
//
//    suite.benchmark("Comma Separated: Protocol") {
//      var string = "12345678"[...].utf8
//
//      let output = q7
//      .parse(&string)
//      precondition(output != nil)
//    }
////
