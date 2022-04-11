import Parsing

let string = String(repeating: "A", count: 10_000)
let substring = string.dropFirst(10).dropLast(10)

"café"
"\u{00E9}"
"e\u{0301}"

"\u{00E9}" == "e\u{0301}"

"\u{00E9}".utf8
"e\u{0301}".utf8
Array("\u{00E9}".utf8)
Array("e\u{0301}".utf8)
"\u{00E9}".utf8.elementsEqual("e\u{0301}".utf8)
"\u{00E9}".elementsEqual("e\u{0301}")

struct Dot {
  let x, y: Int
}
enum Direction: String, CaseIterable {
  case x, y
}
struct Fold {
  let direction: Direction
  let position: Int
}
struct Instructions {
  let dots: [Dot]
  let folds: [Fold]
}

let dotTuple = ParsePrint {
  Digits()
  ","
  Digits()
}
try dotTuple.print((3, 1))

let dot = ParsePrint(.memberwise(Dot.init)) {
  Digits()
  ","
  Digits()
}
try dot.print(Dot(x: 3, y: 1))

do {
  try dot.parse("6,10")
} catch {
  print(error)
}

let dots = Many {
  dot
} separator: {
  "\n"
}

try dots.parse("""
6,10
0,14
9,10
0,3
""")
try dots.print([
  Dot(x: 3, y: 1),
  Dot(x: 2, y: 0),
  Dot(x: 1, y: 4),
])

// fold ➡️ y=7
let fold = ParsePrint(.memberwise(Fold.init)) {
  "fold ➡️ "
  Direction.parser()
  "="
  Digits()
}
do {
  try fold.parse("fold ➡️ y=7")
} catch {
  print(error)
}
try fold.print(Fold(direction: .x, position: 5))

let folds = Many {
  fold
} separator: {
  "\n"
}

let instructions = ParsePrint(.memberwise(Instructions.init)) {
  dots
  "\n\n"
  folds
}

do {
  let dot = ParsePrint(.memberwise(Dot.init)) {
    Digits()
    ",".utf8
    Digits()
  }
  let dots = Many {
    dot
  } separator: {
    "\n".utf8
  }
  let fold = ParsePrint(.memberwise(Fold.init)) {
    "fold ➡️ ".utf8
    Direction.parser()
    "=".utf8
    Digits()
  }
  let folds = Many {
    fold
  } separator: {
    "\n".utf8
  }
  let instructions = ParsePrint(.memberwise(Instructions.init)) {
    dots
    "\n\n".utf8
    folds
  }
}

let input = """
6,10
0,14
9,10
0,3
10,4
4,11
6,0
6,12
4,1
0,13
10,12
3,4
3,0
8,4
1,10
2,14
8,10
9,0

fold ➡️ y=7
fold ➡️ x=5
"""

let output = try instructions.parse(input)
try instructions.print(output) == input
