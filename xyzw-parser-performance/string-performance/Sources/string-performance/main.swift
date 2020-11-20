import Benchmark

let string = String.init(repeating: "A", count: 1_000_000)

benchmark("Copying: String") {
  var copy = string
  copy.removeFirst()
  var copy1 = copy
  copy1.removeFirst()
  var copy2 = copy1
  copy2.removeFirst()
  var copy3 = copy2
  copy3.removeFirst()
}

benchmark("Copying: Substring") {
  var copy = string[...]
  copy.removeFirst()
  var copy1 = copy
  copy1.removeFirst()
  var copy2 = copy1
  copy2.removeFirst()
  var copy3 = copy2
  copy3.removeFirst()
}

Benchmark.main()

