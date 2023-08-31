import Experimentation

let a = 17
let b = 25

let (result, code) = #stringify(a + b)

//let (result1, code1) = #stringify()

print("The value \(result) was produced by the code \"\(code)\"")
