//struct Ten<A: Equatable>: Equatable {
//  var a, b, c, d, e, f, g, h, i, j: A
//}
//struct BoxedTen<A: Equatable>: Equatable {
//  private var box: [A]
//  init(a: A, b: A, c: A, d: A, e: A, f: A, g: A, h: A, i: A, j: A) {
//    self.box = [a, b, c, d, e, f, g, h, i, j]
//  }
//  var a: A {
//    get { self.box[0] }
//    set { self.box[0] = newValue }
//  }
//  var b: A {
//    get { self.box[1] }
//    set { self.box[1] = newValue }
//  }
//  var c: A {
//    get { self.box[2] }
//    set { self.box[2] = newValue }
//  }
//  var d: A {
//    get { self.box[3] }
//    set { self.box[3] = newValue }
//  }
//  var e: A {
//    get { self.box[4] }
//    set { self.box[4] = newValue }
//  }
//  var f: A {
//    get { self.box[5] }
//    set { self.box[5] = newValue }
//  }
//  var g: A {
//    get { self.box[6] }
//    set { self.box[6] = newValue }
//  }
//  var h: A {
//    get { self.box[7] }
//    set { self.box[7] = newValue }
//  }
//  var i: A {
//    get { self.box[8] }
//    set { self.box[8] = newValue }
//  }
//  var j: A {
//    get { self.box[9] }
//    set { self.box[9] = newValue }
//  }
//}
//
//import XCTest
//
//class StackOverflowTests: XCTestCase {
//  func testTen() {
//    let value1 = Ten(
//      a: "qndfjkasdf njkasdfnjsakd",
//      b: "qndfjkasdf njkasdfnjsakd",
//      c: "qndfjkasdf njkasdfnjsakd",
//      d: "qndfjkasdf njkasdfnjsakd",
//      e: "qndfjkasdf njkasdfnjsakd",
//      f: "qndfjkasdf njkasdfnjsakd",
//      g: "qndfjkasdf njkasdfnjsakd",
//      h: "qndfjkasdf njkasdfnjsakd",
//      i: "qndfjkasdf njkasdfnjsakd",
//      j: "qndfjkasdf njkasdfnjsakd"
//    )
//    let value2 = Ten(
//      a: value1,
//      b: value1,
//      c: value1,
//      d: value1,
//      e: value1,
//      f: value1,
//      g: value1,
//      h: value1,
//      i: value1,
//      j: value1
//    )
//    let value3 = Ten(
//      a: value2,
//      b: value2,
//      c: value2,
//      d: value2,
//      e: value2,
//      f: value2,
//      g: value2,
//      h: value2,
//      i: value2,
//      j: value2
//    )
////    let value4 = Ten(
////      a: value3,
////      b: value3,
////      c: value3,
////      d: value3,
////      e: value3,
////      f: value3,
////      g: value3,
////      h: value3,
////      i: value3,
////      j: value3
////    )
////    let value5 = Ten(
////      a: value4,
////      b: value4,
////      c: value4,
////      d: value4,
////      e: value4,
////      f: value4,
////      g: value4,
////      h: value4,
////      i: value4,
////      j: value4
////    )
////    var copy = value4
//    let start = Date()
//    for _ in 1...10_000 {
//      precondition(value3 == value3)
//    }
//    print("Ten equality", Date().timeIntervalSince(start))
//  }
//
//  func testBoxedTen() {
//    let value1 = BoxedTen(
//      a: "qndfjkasdf njkasdfnjsakd",
//      b: "qndfjkasdf njkasdfnjsakd",
//      c: "qndfjkasdf njkasdfnjsakd",
//      d: "qndfjkasdf njkasdfnjsakd",
//      e: "qndfjkasdf njkasdfnjsakd",
//      f: "qndfjkasdf njkasdfnjsakd",
//      g: "qndfjkasdf njkasdfnjsakd",
//      h: "qndfjkasdf njkasdfnjsakd",
//      i: "qndfjkasdf njkasdfnjsakd",
//      j: "qndfjkasdf njkasdfnjsakd"
//    )
//    let value2 = BoxedTen(
//      a: value1,
//      b: value1,
//      c: value1,
//      d: value1,
//      e: value1,
//      f: value1,
//      g: value1,
//      h: value1,
//      i: value1,
//      j: value1
//    )
//    let value3 = BoxedTen(
//      a: value2,
//      b: value2,
//      c: value2,
//      d: value2,
//      e: value2,
//      f: value2,
//      g: value2,
//      h: value2,
//      i: value2,
//      j: value2
//    )
//    let value4 = BoxedTen(
//      a: value3,
//      b: value3,
//      c: value3,
//      d: value3,
//      e: value3,
//      f: value3,
//      g: value3,
//      h: value3,
//      i: value3,
//      j: value3
//    )
//    let value5 = BoxedTen(
//      a: value4,
//      b: value4,
//      c: value4,
//      d: value4,
//      e: value4,
//      f: value4,
//      g: value4,
//      h: value4,
//      i: value4,
//      j: value4
//    )
//    var copy = value5
//    let start = Date()
//    for _ in 1...10_000 {
//      precondition(value5 == value5)
//    }
//    print("BoxedTen equality", Date().timeIntervalSince(start))
//  }
//}
