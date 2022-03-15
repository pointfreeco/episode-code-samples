import Benchmark
import Foundation
import Parsing

/// This benchmarks implements an [RFC-3339-compliant](https://www.ietf.org/rfc/rfc3339.txt) date
/// parser in a relatively naive way and pits it against `DateFormatter` and `ISO8601DateFormatter`.
///
/// Not only is the parser faster than both formatters, it is more flexible and accurate: it will parse
/// parse fractional seconds and time zone offsets automatically, and it will parse to the nanosecond,
/// while the formatters do not parse beyond the millisecond.
let dateSuite = BenchmarkSuite(name: "Date") { suite in
  let digits = { (n: Int) in
    Prefix<Substring.UTF8View>(n).pipe {
      Int.parser(isSigned: false)
      End()
    }
  }

  let dateFullyear = digits(4)
  let dateMonth = digits(2)
  let dateMday = digits(2)

  let timeDelim = OneOf {
    "T".utf8
    "t".utf8
    " ".utf8
  }

  let timeHour = digits(2)
  let timeMinute = digits(2)
  let timeSecond = digits(2)

  let nanoSecfrac = Prefix(while: (.init(ascii: "0") ... .init(ascii: "9")).contains)
    .map { $0.prefix(9) }

  let timeSecfrac = Parse {
    ".".utf8
    nanoSecfrac
  }
  .compactMap { n in
    Int(String(decoding: n, as: UTF8.self))
      .map { $0 * Int(pow(10, 9 - Double(n.count))) }
  }

  let timeNumoffset = Parse {
    OneOf {
      "+".utf8.map { 1 }
      "-".utf8.map { -1 }
    }
    timeHour
    ":".utf8
    timeMinute
  }

  let timeOffset = OneOf {
    "Z".utf8.map { ( /*sign: */1, /*minute: */ 0, /*second: */ 0) }
    timeNumoffset
  }
  .compactMap { TimeZone(secondsFromGMT: $0 * ($1 * 60 + $2)) }

  let partialTime = Parse {
    timeHour
    ":".utf8
    timeMinute
    ":".utf8
    timeSecond
    Optionally {
      timeSecfrac
    }
  }

  let fullDate = Parse {
    dateFullyear
    "-".utf8
    dateMonth
    "-".utf8
    dateMday
  }

  let offsetDateTime = Parse {
    fullDate
    timeDelim
    partialTime
    timeOffset
  }
  .map { date, time, timeZone -> DateComponents in
    let (year, month, day) = date
    let (hour, minute, second, nanosecond) = time
    return DateComponents(
      timeZone: timeZone,
      year: year, month: month, day: day,
      hour: hour, minute: minute, second: second, nanosecond: nanosecond
    )
  }

  let localDateTime = Parse {
    fullDate
    timeDelim
    partialTime
  }
  .map { date, time -> DateComponents in
    let (year, month, day) = date
    let (hour, minute, second, nanosecond) = time
    return DateComponents(
      year: year, month: month, day: day,
      hour: hour, minute: minute, second: second, nanosecond: nanosecond
    )
  }

  let localDate =
    fullDate
    .map { DateComponents(year: $0, month: $1, day: $2) }

  let localTime =
    partialTime
    .map { DateComponents(hour: $0, minute: $1, second: $2, nanosecond: $3) }

  let dateTime = OneOf {
    offsetDateTime
    localDateTime
    localDate
    localTime
  }

  let input = "1979-05-27T00:32:00Z"
  let expected = Date(timeIntervalSince1970: 296_613_120)
  var output: Date!

  let dateTimeParser = dateTime.compactMap(Calendar.current.date(from:))
  suite.benchmark("Parser") {
    var input = input[...].utf8
    output = try dateTimeParser.parse(&input)
  } tearDown: {
    precondition(output == expected)
  }

  let dateFormatter = DateFormatter()
  dateFormatter.dateFormat = "yyyy'-'MM'-'dd'T'HH':'mm':'ss'Z'"
  dateFormatter.locale = Locale(identifier: "en_US_POSIX")
  dateFormatter.timeZone = TimeZone(secondsFromGMT: 0)!
  suite.benchmark("DateFormatter") {
    output = dateFormatter.date(from: input)
  } tearDown: {
    precondition(output == expected)
  }

  if #available(macOS 10.12, *) {
    let iso8601DateFormatter = ISO8601DateFormatter()
    iso8601DateFormatter.timeZone = TimeZone(secondsFromGMT: 0)
    suite.benchmark("ISO8601DateFormatter") {
      output = iso8601DateFormatter.date(from: input)
    } tearDown: {
      precondition(output == expected)
    }
  }
}
