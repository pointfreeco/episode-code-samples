import Foundation
import MacroKit

@StaticMemberIterable
struct Value {
    static let foo = Value(value: "foo")
    static let bar = Value(value: "bar")
    static let baz = Value(value: "baz")

    var value: String
}

func testStaticMemberIterable() {
    for value in Value.allStaticMembers {
        print(value.value)
    }
}
