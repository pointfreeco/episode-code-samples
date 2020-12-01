
let bigString = String.init(repeating: "A", count: 1_000_000)

var copy = bigString
copy.removeFirst()

var anotherCopy = bigString
anotherCopy.removeFirst()

let truncatedBigString = bigString.dropFirst() as Substring

bigString.index(after: bigString.startIndex) == truncatedBigString.startIndex

var copy1 = truncatedBigString.dropFirst(100)
var copy2 = truncatedBigString.dropFirst(1_000)
var copy3 = truncatedBigString.dropFirst(10_000)

let acuteE1 = "é"
let acuteE2 = "é"
acuteE1 == acuteE2
acuteE1.count
acuteE2.count

acuteE1.unicodeScalars.count
acuteE2.unicodeScalars.count

Array(acuteE1.unicodeScalars)
Array(acuteE2.unicodeScalars)

acuteE1.unicodeScalars.elementsEqual(acuteE2.unicodeScalars)

"🇺"
"🇸"
"🇺" + "🇸"
"\u{1F1FA}\u{1F1F8}"



"🇺🇸".dropFirst()

String("🇺🇸".unicodeScalars.dropFirst())

Array(acuteE1.utf8)
Array(acuteE2.utf8)

Array("🇺🇸".unicodeScalars)
Array("🇺🇸".utf8)
Array("👨‍👨‍👧‍👧".unicodeScalars)
Array("👨‍👨‍👧‍👧".utf8)
"👨‍👨‍👧‍👧".utf8.count

"🇺🇸".unicodeScalars.first == ("🇺" as Unicode.Scalar)

"🇺🇸".utf8.starts(with: [240, 159, 135, 186])


let collection = [1, 2, 3]
  .lazy
  .filter { _ in true }
  .map { $0 + 1 }
  .map { $0 + 1 }

import Combine

let publisher = Future<Int, Never> { $0(.success(1)) }
  .filter { _ in true }
  .map { $0 + 1 }
  .map { $0 + 1 }

import SwiftUI

let view: VStack<
  TupleView<(
    Text,
    HStack<
      TupleView<(
        Text,
        Button<Text>
      )>
    >,
    TextField<Text>
  )>
> = VStack {
  Text("Hi")
  HStack {
    Text("Go")
    Button("Now") {}
  }
  TextField("Enter password", text: .constant(""))
}

