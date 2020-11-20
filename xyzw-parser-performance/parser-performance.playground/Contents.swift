
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
