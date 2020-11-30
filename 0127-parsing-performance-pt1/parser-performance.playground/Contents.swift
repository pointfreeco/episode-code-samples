
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
