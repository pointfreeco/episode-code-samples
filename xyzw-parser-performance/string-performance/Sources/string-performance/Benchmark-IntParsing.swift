import Benchmark
import Foundation
import Parsing

let f = {
  {
    {
      {
        {
          {
            {
              {
                {
                  max(1, 100)
                }
              }
            }
          }
        }
      }
    }
  }
}

let intParserSuite = BenchmarkSuite(name: "Int Parsing") { suite in

  suite.benchmark("External Closure", settings: Iterations(5_000_000)) {
    precondition(f()()()()()()()()() == 100)
  }

  suite.benchmark("Inlined Closure", settings: Iterations(5_000_000)) {
    let f = {
      {
        {
          {
            {
              {
                {
                  {
                    {
                      100
                    }
                  }
                }
              }
            }
          }
        }
      }
    }
    precondition(f()()()()()()()()() == 100)
  }

  let string = "1234567890"

  suite.benchmark("Int.init") {
    precondition(Int(string) == 1234567890)
  }

  suite.benchmark("Substring") {
    var string = string[...]
    precondition(Parser.int.run(&string) == 1234567890)
  }

  suite.benchmark("UnicodeScalar") {
    var string = string[...].unicodeScalars
    precondition(Parser.int.run(&string) == 1234567890)
  }

  suite.benchmark("UTF8") {
    var string = string[...].utf8
    precondition(Parser.int.run(&string) == 1234567890)
  }

  suite.benchmark("Protocol") {
    var input = string[...].utf8
    _ = IntParser().parse(&input)
  }

  let originalParser = Parser.int
    .skip(.prefix("-"[...].utf8))
    .skip(.prefix("-"[...].utf8))
    .skip(.prefix("-"[...].utf8))
    .skip(.prefix("-"[...].utf8))
    .skip(.prefix("-"[...].utf8))
    .skip(.prefix("-"[...].utf8))
    .skip(.prefix("-"[...].utf8))
    .skip(.prefix("-"[...].utf8))
    .skip(.prefix("-"[...].utf8))
    .skip(.prefix("-"[...].utf8))
    .take(.int)
  suite.benchmark("Comma Separated: Original") {
    var string = "1----------2"[...].utf8

    let output = originalParser
      .run(&string)

    precondition(output! == (1, 2))
  }

  let p1 = SkipSecond(IntParser(), Prefix("-"[...].utf8))
  let p2 = SkipSecond(p1, Prefix("-"[...].utf8))
  let p3 = SkipSecond(p2, Prefix("-"[...].utf8))
  let p4 = SkipSecond(p3, Prefix("-"[...].utf8))
  let p5 = SkipSecond(p4, Prefix("-"[...].utf8))
  let p6 = SkipSecond(p5, Prefix("-"[...].utf8))
  let p7 = SkipSecond(p6, Prefix("-"[...].utf8))
  let p8 = SkipSecond(p7, Prefix("-"[...].utf8))
  let p9 = SkipSecond(p8, Prefix("-"[...].utf8))
  let p10 = SkipSecond(p9, Prefix("-"[...].utf8))
  let protocolParser = Take2(p10, IntParser())

  suite.benchmark("Comma Separated: Protocol") {
    var string = "1----------2"[...].utf8

    let output = protocolParser
    .parse(&string)

    precondition(output! == (1, 2))
  }

  var scanner: Scanner!
  suite.register(
    benchmark: Benchmarking(
      name: "Scanner",
      setUp: { scanner = Scanner(string: string) }
    ) { _ in
      precondition(scanner.scanInt() == 1234567890)
    }
  )
}
