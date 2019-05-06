
Int("42")
Int("42-")
Double("42")
Double("42.32435")
Bool("true")
Bool("false")
Bool("f")

import Foundation

UUID.init(uuidString: "DEADBEEF-DEAD-BEEF-DEAD-BEEFDEADBEEF")
UUID.init(uuidString: "DEADBEEF-DEAD-BEEF-DEAD-BEEFDEADBEE")
UUID.init(uuidString: "DEADBEEF-DEAD-BEEF-DEAD-BEEFDEADBEEZ")

URL.init(string: "https://www.pointfree.co")
URL.init(string: "^https://www.pointfree.co")

let components = URLComponents.init(string: "https://www.pointfree.co?ref=twitter")
components?.queryItems

let df = DateFormatter()
df.timeStyle = .none
df.dateStyle = .short
type(of: df.date(from: "1/29/17"))
df.date(from: "-1/29/17")


let emailRegexp = try NSRegularExpression(pattern: #"\S+@\S+"#)
let emailString = "You're logged in as blob@pointfree.co"
let emailRange = emailString.startIndex..<emailString.endIndex
let match = emailRegexp.firstMatch(
  in: emailString,
  range: NSRange(emailRange, in: emailString)
  )!
emailString[Range(match.range(at: 0), in: emailString)!]

//let scanner = Scanner.init(string: "A42 Hello World")
//var int = 0
//scanner.scanInt(&int)
//int

// 40.6782° N, 73.9442° W
struct Coordinate {
  let latitude: Double
  let longitude: Double
}

func parseLatLong(_ str: String) -> Coordinate? {
  let parts = str.split(separator: " ")
  guard parts.count == 4 else { return nil }
  guard
    let lat = Double(parts[0].dropLast()),
    let long = Double(parts[2].dropLast())
    else { return nil }
  let latCard = parts[1].dropLast()
  guard latCard == "N" || latCard == "S" else { return nil }
  let longCard = parts[3]
  guard longCard == "E" || longCard == "W" else { return nil }
  let latSign = latCard == "N" ? 1.0 : -1
  let longSign = longCard == "E" ? 1.0 : -1
  return Coordinate(latitude: lat * latSign, longitude: long * longSign)
}

print(parseLatLong("40.6782% N- 73.9442% W"))
