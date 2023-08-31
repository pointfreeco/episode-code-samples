import Foundation
import MacroKit

@KeyPathIterable
struct Bar {
    var a: String
    var b: Int
    var c: Int { b + 1 }
}

func testKeyPathIterable() {
    let bar = Bar(a: "hello", b: 41)

    for kp in Bar.allKeyPaths {
        print(bar[keyPath: kp])
    }
}
