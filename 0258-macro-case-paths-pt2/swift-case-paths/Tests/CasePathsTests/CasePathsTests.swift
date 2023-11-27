import CasePaths
import XCTest

protocol TestProtocol {}
extension Int: TestProtocol {}
protocol TestClassProtocol: AnyObject {}

final class CasePathsTests: XCTestCase {
  func testSimplePayload() {
    enum Enum { case payload(Int) }
    let path = /Enum.payload
    for _ in 1...2 {
      XCTAssertEqual(path.extract(from: .payload(42)), 42)
      XCTAssertEqual(path.extract(from: .payload(42)), 42)
    }
    XCTAssertEqual(CasePath(Enum.payload).extract(from: .payload(42)), 42)
  }

  func testSimpleLabeledPayload() {
    enum Enum { case payload(label: Int) }
    let path = /Enum.payload(label:)
    for _ in 1...2 {
      XCTAssertEqual(path.extract(from: .payload(label: 42)), 42)
    }
    XCTAssertEqual(CasePath(Enum.payload(label:)).extract(from: .payload(label: 42)), 42)
  }

  // This test crashes Xcode 11.7's compiler.
  #if compiler(>=5.3)
    func testSimpleOverloadedPayload() {
      enum Enum {
        case payload(a: Int)
        case payload(b: Int)
      }
      let pathA = /Enum.payload(a:)
      let pathB = /Enum.payload(b:)
      for _ in 1...2 {
        XCTAssertEqual(pathA.extract(from: .payload(a: 42)), 42)
        XCTAssertEqual(pathA.extract(from: .payload(b: 42)), nil)
        XCTAssertEqual(pathB.extract(from: .payload(a: 42)), nil)
        XCTAssertEqual(pathB.extract(from: .payload(b: 42)), 42)
      }
      XCTAssertEqual(CasePath(Enum.payload(a:)).extract(from: .payload(a: 42)), 42)
      XCTAssertEqual(CasePath(Enum.payload(a:)).extract(from: .payload(b: 42)), nil)
      XCTAssertEqual(CasePath(Enum.payload(b:)).extract(from: .payload(a: 42)), nil)
      XCTAssertEqual(CasePath(Enum.payload(b:)).extract(from: .payload(b: 42)), 42)
    }
  #endif

  func testMultiPayload() {
    enum Enum { case payload(Int, String) }
    let path: CasePath<Enum, (Int, String)> = /Enum.payload
    for _ in 1...2 {
      XCTAssert(try unwrap(path.extract(from: .payload(42, "Blob"))) == (42, "Blob"))
    }
    XCTAssert(
      try unwrap(CasePath(Enum.payload).extract(from: .payload(42, "Blob"))) == (42, "Blob")
    )
  }

  func testMultiLabeledPayload() {
    enum Enum { case payload(a: Int, b: String) }
    let path: CasePath<Enum, (Int, String)> = /Enum.payload
    for _ in 1...2 {
      XCTAssert(
        try unwrap(path.extract(from: .payload(a: 42, b: "Blob"))) == (42, "Blob")
      )
      XCTAssert(
        try unwrap(path.extract(from: .payload(a: 42, b: "Blob"))) == (a: 42, b: "Blob")
      )
    }
    XCTAssert(
      try unwrap(CasePath(Enum.payload).extract(from: .payload(a: 42, b: "Blob"))) == (42, "Blob")
    )
    XCTAssert(
      try unwrap(CasePath(Enum.payload).extract(from: .payload(a: 42, b: "Blob")))
        == (a: 42, b: "Blob")
    )
  }

  func testNoPayload() {
    enum Enum { case a, b }
    let pathA = /Enum.a
    let pathB = /Enum.b
    for _ in 1...2 {
      XCTAssertNotNil(pathA.extract(from: .a))
      XCTAssertNotNil(pathB.extract(from: .b))
      XCTAssertNil(pathA.extract(from: .b))
      XCTAssertNil(pathB.extract(from: .a))
    }
    XCTAssertNotNil(CasePath(Enum.a).extract(from: .a))
    XCTAssertNotNil(CasePath(Enum.b).extract(from: .b))
    XCTAssertNil(CasePath(Enum.a).extract(from: .b))
    XCTAssertNil(CasePath(Enum.b).extract(from: .a))
  }

  func testZeroMemoryLayoutPayload() {
    struct Unit1 {}
    enum Unit2 { case unit }
    enum Enum {
      case void(Void)
      case unit1(Unit1)
      case unit2(Unit2)
    }
    let path1 = /Enum.void
    let path2 = /Enum.unit1
    let path3 = /Enum.unit2
    for _ in 1...2 {
      XCTAssertNotNil(path1.extract(from: .void(())))
      XCTAssertNotNil(path2.extract(from: .unit1(.init())))
      XCTAssertNotNil(path3.extract(from: .unit2(.unit)))
      XCTAssertNil(path1.extract(from: .unit1(.init())))
      XCTAssertNil(path1.extract(from: .unit2(.unit)))
      XCTAssertNil(path2.extract(from: .void(())))
      XCTAssertNil(path2.extract(from: .unit2(.unit)))
      XCTAssertNil(path3.extract(from: .void(())))
      XCTAssertNil(path3.extract(from: .unit1(.init())))
    }
    XCTAssertNotNil(CasePath(Enum.void).extract(from: .void(())))
    XCTAssertNotNil(CasePath(Enum.unit1).extract(from: .unit1(.init())))
    XCTAssertNotNil(CasePath(Enum.unit2).extract(from: .unit2(.unit)))
    XCTAssertNil(CasePath(Enum.void).extract(from: .unit1(.init())))
    XCTAssertNil(CasePath(Enum.void).extract(from: .unit2(.unit)))
    XCTAssertNil(CasePath(Enum.unit1).extract(from: .void(())))
    XCTAssertNil(CasePath(Enum.unit1).extract(from: .unit2(.unit)))
    XCTAssertNil(CasePath(Enum.unit2).extract(from: .void(())))
    XCTAssertNil(CasePath(Enum.unit2).extract(from: .unit1(.init())))
  }

  func testUninhabitedPayload() {
    enum Uninhabited {}
    enum Enum {
      case never(Never)
      case uninhabited(Uninhabited)
      case value
    }
    let path1 = /Enum.never
    let path2 = /Enum.uninhabited
    for _ in 1...2 {
      XCTAssertNil(path1.extract(from: .value))
      XCTAssertNil(path2.extract(from: .value))
    }
    XCTAssertNil(CasePath(Enum.never).extract(from: .value))
    XCTAssertNil(CasePath(Enum.uninhabited).extract(from: .value))
  }

  func testClosurePayload() throws {
    enum Enum { case closure(() -> Void) }
    let path = /Enum.closure
    for _ in 1...2 {
      var invoked = false
      let closure = try unwrap(path.extract(from: .closure { invoked = true }))
      closure()
      XCTAssertTrue(invoked)
    }
    var invoked = false
    let closure = try unwrap(CasePath(Enum.closure).extract(from: .closure { invoked = true }))
    closure()
    XCTAssertTrue(invoked)
  }

  func testRecursivePayload() {
    indirect enum Enum: Equatable {
      case indirect(Enum)
      case direct
    }
    let shallowPath = /Enum.indirect
    let deepPath = /Enum.indirect
    for _ in 1...2 {
      XCTAssertEqual(shallowPath.extract(from: .indirect(.direct)), .direct)
      XCTAssertEqual(
        deepPath.extract(from: .indirect(.indirect(.direct))), .indirect(.direct)
      )
    }
    XCTAssertEqual(CasePath(Enum.indirect).extract(from: .indirect(.direct)), .direct)
    XCTAssertEqual(
      CasePath(Enum.indirect).extract(from: .indirect(.indirect(.direct))), .indirect(.direct)
    )
  }

  func testIndirectSimplePayload() {
    enum Enum: Equatable {
      indirect case indirect(Int)
      case direct(Int)
    }

    let indirectPath = /Enum.indirect
    let directPath = /Enum.direct

    for _ in 1...2 {
      XCTAssertEqual(indirectPath.extract(from: .indirect(42)), 42)
      XCTAssertEqual(indirectPath.extract(from: .direct(42)), nil)
      XCTAssertEqual(directPath.extract(from: .indirect(42)), nil)
      XCTAssertEqual(directPath.extract(from: .direct(42)), 42)
    }
    XCTAssertEqual(CasePath(Enum.indirect).extract(from: .indirect(42)), 42)
    XCTAssertEqual(CasePath(Enum.indirect).extract(from: .direct(42)), nil)
    XCTAssertEqual(CasePath(Enum.direct).extract(from: .indirect(42)), nil)
    XCTAssertEqual(CasePath(Enum.direct).extract(from: .direct(42)), 42)
  }

  fileprivate class Object: Equatable {
    static func == (lhs: Object, rhs: Object) -> Bool {
      return lhs === rhs
    }
  }

  func testIndirectCompoundPayload() throws {
    let object = Object()

    enum Enum: Equatable {
      indirect case indirect(Int, Object?, Int, Object?)
      case direct(Int, Object?, Int, Object?)
    }

    let indirectPath: CasePath<Enum, (Int, Object?, Int, Object?)> = /Enum.indirect
    let directPath: CasePath<Enum, (Int, Object?, Int, Object?)> = /Enum.direct

    for _ in 1...2 {
      XCTAssert(
        try unwrap(indirectPath.extract(from: .indirect(42, nil, 43, object)))
          == (42, nil, 43, object)
      )
      XCTAssertNil(indirectPath.extract(from: .direct(42, nil, 43, object)))
      XCTAssertNil(directPath.extract(from: .indirect(42, nil, 43, object)))
      XCTAssert(
        try unwrap(directPath.extract(from: .direct(42, nil, 43, object))) == (42, nil, 43, object)
      )
    }
    XCTAssert(
      try unwrap(CasePath(Enum.indirect).extract(from: .indirect(42, nil, 43, object)))
        == (42, nil, 43, object)
    )
    XCTAssertNil(CasePath(Enum.indirect).extract(from: .direct(42, nil, 43, object)))
    XCTAssertNil(CasePath(Enum.direct).extract(from: .indirect(42, nil, 43, object)))
    XCTAssert(
      try unwrap(CasePath(Enum.direct).extract(from: .direct(42, nil, 43, object))) == (
        42, nil, 43, object
      )
    )
  }

  #if RELEASE
    func testNonEnumExtract() {
      // This is a bogus CasePath, intended to verify that it just returns nil.
      let path: CasePath<Int, Int> = /{ $0 }

      for _ in 1...2 {
        XCTAssertNil(path.extract(from: 42))
      }
      XCTAssertNil(CasePath { $0 }.extract(from: 42))
    }
  #endif

  func testOptionalPayload() {
    enum Enum { case int(Int?) }
    let path = /Enum.int
    for _ in 1...2 {
      XCTAssertEqual(path.extract(from: .int(.some(42))), .some(.some(42)))
      XCTAssertEqual(path.extract(from: .int(.none)), .some(.none))
    }
    XCTAssertEqual(CasePath(Enum.int).extract(from: .int(.some(42))), .some(.some(42)))
    XCTAssertEqual(CasePath(Enum.int).extract(from: .int(.none)), .some(.none))
  }

  func testAnyPayload() {
    enum Enum { case any(Any) }
    let path = /Enum.any
    for _ in 1...2 {
      XCTAssertEqual(path.extract(from: .any(42)) as? Int, 42)
    }
    XCTAssertEqual(CasePath(Enum.any).extract(from: .any(42)) as? Int, 42)
  }

  func testAnyObjectPayload() {
    class Class {}
    enum Enum { case anyObject(AnyObject) }
    let object = Class()
    let nsObject = NSObject()
    let path = /Enum.anyObject
    for _ in 1...2 {
      XCTAssert(try unwrap(path.extract(from: .anyObject(object))) === object)
      XCTAssert(try unwrap(path.extract(from: .anyObject(nsObject))) === nsObject)
    }
    XCTAssert(try unwrap(CasePath(Enum.anyObject).extract(from: .anyObject(object))) === object)
    XCTAssert(try unwrap(CasePath(Enum.anyObject).extract(from: .anyObject(nsObject))) === nsObject)
  }

  func testProtocolPayload() {
    struct Error: Swift.Error, Equatable {}
    enum Enum { case error(Swift.Error) }
    let path = /Enum.error
    for _ in 1...2 {
      XCTAssertEqual(path.extract(from: .error(Error())) as? Error, Error())
    }
    XCTAssertEqual(CasePath(Enum.error).extract(from: .error(Error())) as? Error, Error())
  }

  func testSubclassPayload() {
    class Superclass {}
    class Subclass: Superclass {}
    enum Enum {
      case superclass(Superclass)
      case subclass(Subclass)
    }
    let superclass = Superclass()
    let subclass = Subclass()
    let superclassPath = /Enum.superclass
    let subclassPath = /Enum.subclass
    for _ in 1...2 {
      XCTAssert(
        try unwrap(superclassPath.extract(from: .superclass(superclass))) === superclass
      )
      XCTAssert(
        try unwrap(superclassPath.extract(from: .superclass(subclass))) === subclass
      )
      XCTAssert(
        try unwrap(subclassPath.extract(from: .subclass(subclass))) === subclass
      )
    }
    XCTAssert(
      try unwrap(CasePath(Enum.superclass).extract(from: .superclass(superclass))) === superclass
    )
    XCTAssert(
      try unwrap(CasePath(Enum.superclass).extract(from: .superclass(subclass))) === subclass
    )
    XCTAssert(
      try unwrap(CasePath(Enum.subclass).extract(from: .subclass(subclass))) === subclass
    )
  }

  func testDefaults() {
    enum Enum { case n(Int, m: Int? = nil, file: String = #file, line: UInt = #line) }
    let path: CasePath<Enum, (Int, Int?, String, UInt)> = /Enum.n
    for _ in 1...2 {
      XCTAssert(
        try unwrap(path.extract(from: .n(42))) == (42, nil, #file, #line)
      )
    }
    XCTAssert(
      try unwrap(CasePath(Enum.n).extract(from: .n(42))) == (42, nil, #file, #line)
    )
  }

  func testDifferentMemoryLayouts() {
    struct Struct { var array: [Int] = [1, 2, 3], string: String = "Blob" }
    enum Enum {
      case bool(Bool)
      case int(Int)
      case void(Void)
      case structure(Struct)
      case any(Any)
    }

    let boolPath = /Enum.bool
    let intPath = /Enum.int
    let voidPath = /Enum.void
    let structPath = /Enum.structure
    let anyPath = /Enum.any
    for _ in 1...2 {
      XCTAssertNil(boolPath.extract(from: .int(42)))
      XCTAssertNil(boolPath.extract(from: .void(())))
      XCTAssertNil(boolPath.extract(from: .structure(.init())))
      XCTAssertNil(boolPath.extract(from: .any("Blob")))
      XCTAssertNil(intPath.extract(from: .bool(true)))
      XCTAssertNil(intPath.extract(from: .void(())))
      XCTAssertNil(intPath.extract(from: .structure(.init())))
      XCTAssertNil(intPath.extract(from: .any("Blob")))
      XCTAssertNil(voidPath.extract(from: .bool(true)))
      XCTAssertNil(voidPath.extract(from: .int(42)))
      XCTAssertNil(voidPath.extract(from: .structure(.init())))
      XCTAssertNil(voidPath.extract(from: .any("Blob")))
      XCTAssertNil(structPath.extract(from: .bool(true)))
      XCTAssertNil(structPath.extract(from: .int(42)))
      XCTAssertNil(structPath.extract(from: .void(())))
      XCTAssertNil(structPath.extract(from: .any("Blob")))
      XCTAssertNil(anyPath.extract(from: .bool(true)))
      XCTAssertNil(anyPath.extract(from: .int(42)))
      XCTAssertNil(anyPath.extract(from: .void(())))
      XCTAssertNil(anyPath.extract(from: .structure(.init())))

      XCTAssertNotNil(boolPath.extract(from: .bool(true)))
      XCTAssertNotNil(intPath.extract(from: .int(42)))
      XCTAssertNotNil(voidPath.extract(from: .void(())))
      XCTAssertNotNil(anyPath.extract(from: .any("Blob")))
    }
    XCTAssertNil(CasePath(Enum.bool).extract(from: .int(42)))
    XCTAssertNil(CasePath(Enum.bool).extract(from: .void(())))
    XCTAssertNil(CasePath(Enum.bool).extract(from: .structure(.init())))
    XCTAssertNil(CasePath(Enum.bool).extract(from: .any("Blob")))
    XCTAssertNil(CasePath(Enum.int).extract(from: .bool(true)))
    XCTAssertNil(CasePath(Enum.int).extract(from: .void(())))
    XCTAssertNil(CasePath(Enum.int).extract(from: .structure(.init())))
    XCTAssertNil(CasePath(Enum.int).extract(from: .any("Blob")))
    XCTAssertNil(CasePath(Enum.void).extract(from: .bool(true)))
    XCTAssertNil(CasePath(Enum.void).extract(from: .int(42)))
    XCTAssertNil(CasePath(Enum.void).extract(from: .structure(.init())))
    XCTAssertNil(CasePath(Enum.void).extract(from: .any("Blob")))
    XCTAssertNil(CasePath(Enum.structure).extract(from: .bool(true)))
    XCTAssertNil(CasePath(Enum.structure).extract(from: .int(42)))
    XCTAssertNil(CasePath(Enum.structure).extract(from: .void(())))
    XCTAssertNil(CasePath(Enum.structure).extract(from: .any("Blob")))
    XCTAssertNil(CasePath(Enum.any).extract(from: .bool(true)))
    XCTAssertNil(CasePath(Enum.any).extract(from: .int(42)))
    XCTAssertNil(CasePath(Enum.any).extract(from: .void(())))
    XCTAssertNil(CasePath(Enum.any).extract(from: .structure(.init())))

    XCTAssertNotNil(CasePath(Enum.bool).extract(from: .bool(true)))
    XCTAssertNotNil(CasePath(Enum.int).extract(from: .int(42)))
    XCTAssertNotNil(CasePath(Enum.void).extract(from: .void(())))
    XCTAssertNotNil(CasePath(Enum.structure).extract(from: .structure(.init())))
    XCTAssertNotNil(CasePath(Enum.any).extract(from: .any("Blob")))
  }

  func testAssociatedValueIsExistential() {
    enum Enum {
      case proto(TestProtocol)
      case int(Int)
    }

    let protoPath = /Enum.proto
    let intPath = /Enum.int

    for _ in 1...2 {
      XCTAssertNil(protoPath.extract(from: .int(100)))
      XCTAssertEqual(protoPath.extract(from: .proto(100)) as? Int, 100)

      XCTAssertNil(intPath.extract(from: .proto(100)))
      XCTAssertEqual(intPath.extract(from: .int(100)), 100)
    }
    XCTAssertNil(CasePath(Enum.proto).extract(from: .int(100)))
    XCTAssertEqual(CasePath(Enum.proto).extract(from: .proto(100)) as? Int, 100)

    XCTAssertNil(CasePath(Enum.int).extract(from: .proto(100)))
    XCTAssertEqual(CasePath(Enum.int).extract(from: .int(100)), 100)
  }

  func testClassConstrainedExistential() {
    class Class: TestClassProtocol {}
    enum Enum {
      case proto(TestClassProtocol)
      case int(Int)
    }
    let protoPath = /Enum.proto
    let intPath = /Enum.int

    let object = Class()

    for _ in 1...2 {
      XCTAssertNil(protoPath.extract(from: .int(100)))
      XCTAssertTrue(protoPath.extract(from: .proto(object)) === object)

      XCTAssertNil(intPath.extract(from: .proto(object)))
      XCTAssertEqual(intPath.extract(from: .int(100)), 100)
    }
    XCTAssertNil(CasePath(Enum.proto).extract(from: .int(100)))
    XCTAssertTrue(CasePath(Enum.proto).extract(from: .proto(object)) === object)

    XCTAssertNil(CasePath(Enum.int).extract(from: .proto(object)))
    XCTAssertEqual(CasePath(Enum.int).extract(from: .int(100)), 100)
  }

  func testContravariantEmbed() {
    enum Enum {
      // associated value type is TestProtocol existential
      case directExistential(TestProtocol)

      // associated value type is single-element tuple (TestProtocol existential)
      case directTuple(label: TestProtocol)

      indirect case indirectExistential(TestProtocol)

      indirect case indirectTuple(label: TestProtocol)

      static let cdeCase = Enum.directExistential(Conformer())
      static let cdtCase = Enum.directTuple(label: Conformer())
      static let cieCase = Enum.indirectExistential(Conformer())
      static let citCase = Enum.indirectTuple(label: Conformer())

      static let ideCase = Enum.directExistential(100)
      static let idtCase = Enum.directTuple(label: 100)
      static let iieCase = Enum.indirectExistential(100)
      static let iitCase = Enum.indirectTuple(label: 100)
    }

    // This is intentionally too big to fit in the three-word buffer of a protocol existential, so
    // that it is stored indirectly.
    struct Conformer: TestProtocol, Equatable {
      var a, b, c, d: Int
      init() {
        (a, b, c, d) = (100, 300, 200, 400)
      }
    }

    var dePath: CasePath<Enum, Conformer> = /Enum.directExistential
    var dtPath: CasePath<Enum, Conformer> = /Enum.directTuple
    var iePath: CasePath<Enum, Conformer> = /Enum.indirectExistential
    var itPath: CasePath<Enum, Conformer> = /Enum.indirectTuple

    for _ in 1...2 {
      XCTAssertNil(dePath.extract(from: .cdtCase))
      XCTAssertNil(dePath.extract(from: .cieCase))
      XCTAssertNil(dePath.extract(from: .citCase))
      XCTAssertNil(dePath.extract(from: .ideCase))
      XCTAssertNil(dePath.extract(from: .idtCase))
      XCTAssertNil(dePath.extract(from: .iieCase))
      XCTAssertNil(dePath.extract(from: .iitCase))
      XCTAssertEqual(dePath.extract(from: .cdeCase), .some(Conformer()))

      XCTAssertNil(dtPath.extract(from: .cdeCase))
      XCTAssertNil(dtPath.extract(from: .cieCase))
      XCTAssertNil(dtPath.extract(from: .citCase))
      XCTAssertNil(dtPath.extract(from: .ideCase))
      XCTAssertNil(dtPath.extract(from: .idtCase))
      XCTAssertNil(dtPath.extract(from: .iieCase))
      XCTAssertNil(dtPath.extract(from: .iitCase))
      XCTAssertEqual(dtPath.extract(from: .cdtCase), .some(Conformer()))

      XCTAssertNil(iePath.extract(from: .cdeCase))
      XCTAssertNil(iePath.extract(from: .cdtCase))
      XCTAssertNil(iePath.extract(from: .citCase))
      XCTAssertNil(iePath.extract(from: .ideCase))
      XCTAssertNil(iePath.extract(from: .idtCase))
      XCTAssertNil(iePath.extract(from: .iieCase))
      XCTAssertNil(iePath.extract(from: .iitCase))
      XCTAssertEqual(iePath.extract(from: .cieCase), .some(Conformer()))

      XCTAssertNil(itPath.extract(from: .cdeCase))
      XCTAssertNil(itPath.extract(from: .cdtCase))
      XCTAssertNil(itPath.extract(from: .cieCase))
      XCTAssertNil(itPath.extract(from: .ideCase))
      XCTAssertNil(itPath.extract(from: .idtCase))
      XCTAssertNil(itPath.extract(from: .iieCase))
      XCTAssertNil(itPath.extract(from: .iitCase))
      XCTAssertEqual(itPath.extract(from: .citCase), .some(Conformer()))
    }

    dePath = CasePath(Enum.directExistential)
    dtPath = CasePath(Enum.directTuple)
    iePath = CasePath(Enum.indirectExistential)
    itPath = CasePath(Enum.indirectTuple)

    XCTAssertNil(dePath.extract(from: .cdtCase))
    XCTAssertNil(dePath.extract(from: .cieCase))
    XCTAssertNil(dePath.extract(from: .citCase))
    XCTAssertNil(dePath.extract(from: .ideCase))
    XCTAssertNil(dePath.extract(from: .idtCase))
    XCTAssertNil(dePath.extract(from: .iieCase))
    XCTAssertNil(dePath.extract(from: .iitCase))
    XCTAssertEqual(dePath.extract(from: .cdeCase), .some(Conformer()))

    XCTAssertNil(dtPath.extract(from: .cdeCase))
    XCTAssertNil(dtPath.extract(from: .cieCase))
    XCTAssertNil(dtPath.extract(from: .citCase))
    XCTAssertNil(dtPath.extract(from: .ideCase))
    XCTAssertNil(dtPath.extract(from: .idtCase))
    XCTAssertNil(dtPath.extract(from: .iieCase))
    XCTAssertNil(dtPath.extract(from: .iitCase))
    XCTAssertEqual(dtPath.extract(from: .cdtCase), .some(Conformer()))

    XCTAssertNil(iePath.extract(from: .cdeCase))
    XCTAssertNil(iePath.extract(from: .cdtCase))
    XCTAssertNil(iePath.extract(from: .citCase))
    XCTAssertNil(iePath.extract(from: .ideCase))
    XCTAssertNil(iePath.extract(from: .idtCase))
    XCTAssertNil(iePath.extract(from: .iieCase))
    XCTAssertNil(iePath.extract(from: .iitCase))
    XCTAssertEqual(iePath.extract(from: .cieCase), .some(Conformer()))

    XCTAssertNil(itPath.extract(from: .cdeCase))
    XCTAssertNil(itPath.extract(from: .cdtCase))
    XCTAssertNil(itPath.extract(from: .cieCase))
    XCTAssertNil(itPath.extract(from: .ideCase))
    XCTAssertNil(itPath.extract(from: .idtCase))
    XCTAssertNil(itPath.extract(from: .iieCase))
    XCTAssertNil(itPath.extract(from: .iitCase))
    XCTAssertEqual(itPath.extract(from: .citCase), .some(Conformer()))
  }

  func testCompoundContravariantEmbed() {
    enum Enum {
      case c(TestProtocol, Int)
    }

    let path: CasePath<Enum, (Int, Int)> = /Enum.c

    for _ in 1...2 {
      XCTAssert(try XCTUnwrap(path.extract(from: .c(34, 12))) == (34, 12))
    }
  }

  func testPathExtractFromOptionalRoot() {
    enum Authentication {
      case authenticated(token: String)
      case unauthenticated
    }

    let root: Authentication? = .authenticated(token: "deadbeef")
    let path: CasePath<Authentication?, String> = /Authentication.authenticated
    for _ in 1...2 {
      let actual = path.extract(from: root)
      XCTAssertEqual(actual, "deadbeef")
    }
    XCTAssertEqual(CasePath(Authentication.authenticated).extract(from: root), "deadbeef")
  }

  func testPathExtractFromOptionalRoot_AnyHashable() {
    enum Authentication {
      case authenticated(token: AnyHashable)
      case unauthenticated
    }

    let root: Authentication? = .authenticated(token: "deadbeef")
    let path: CasePath<Authentication?, String> = /Authentication.authenticated
    for _ in 1...2 {
      let actual = path.extract(from: root)
      XCTAssertEqual(actual, "deadbeef")
    }
  }

  func testEmbed() {
    enum Foo: Equatable { case bar(Int) }

    let fooBar = /Foo.bar
    XCTAssertEqual(.bar(42), fooBar.embed(42))
    XCTAssertEqual(.bar(42), (/Foo.self).embed(Foo.bar(42)))
    XCTAssertEqual(.bar(42), CasePath(Foo.bar).embed(42))
    XCTAssertEqual(.bar(42), CasePath(Foo.self).embed(Foo.bar(42)))
  }

  func testNestedEmbed() {
    enum Foo: Equatable { case bar(Bar) }
    enum Bar: Equatable { case baz(Int) }

    let fooBaz = /Foo.bar .. Bar.baz
    XCTAssertEqual(.bar(.baz(42)), fooBaz.embed(42))
    XCTAssertEqual(.bar(.baz(42)), CasePath(Foo.bar).appending(path: .init(Bar.baz)).embed(42))
  }

  func testVoidCasePath() {
    enum Foo: Equatable { case bar }

    let fooBar = /Foo.bar
    XCTAssertEqual(.bar, fooBar.embed(()))
    XCTAssertEqual(.bar, CasePath(Foo.bar).embed(()))
  }

  func testCasePaths() {
    let some = /String?.some
    XCTAssertEqual(
      .some("Hello"),
      some.extract(from: "Hello")
    )
    XCTAssertNil(
      some.extract(from: .none)
    )
    XCTAssertEqual(
      .some("Hello"),
      CasePath(String?.some).extract(from: "Hello")
    )
    XCTAssertNil(
      CasePath(String?.some).extract(from: .none)
    )

    struct MyError: Equatable, Error {}
    var success = /Result<String, Error>.success
    var failure = /Result<String, Error>.failure
    var mySuccess = /Result<String, MyError>.success
    var myFailure = /Result<String, MyError>.failure

    for _ in 1...2 {
      XCTAssertEqual(
        .some("Hello"),
        success.extract(from: .success("Hello"))
      )
      XCTAssertNil(
        failure.extract(from: .success("Hello"))
      )
      XCTAssertEqual(
        .some(MyError()),
        failure.extract(from: .failure(MyError())) as? MyError
      )
      XCTAssertNil(
        success.extract(from: .failure(MyError()))
      )
      XCTAssertEqual(
        .some(MyError()),
        myFailure.extract(from: .failure(MyError()))
      )
      XCTAssertNil(
        mySuccess.extract(from: .failure(MyError()))
      )
    }

    success = CasePath(Result<String, Error>.success)
    failure = CasePath(Result<String, Error>.failure)
    mySuccess = CasePath(Result<String, MyError>.success)
    myFailure = CasePath(Result<String, MyError>.failure)

    XCTAssertEqual(
      .some("Hello"),
      success.extract(from: .success("Hello"))
    )
    XCTAssertNil(
      failure.extract(from: .success("Hello"))
    )
    XCTAssertEqual(
      .some(MyError()),
      failure.extract(from: .failure(MyError())) as? MyError
    )
    XCTAssertNil(
      success.extract(from: .failure(MyError()))
    )
    XCTAssertEqual(
      .some(MyError()),
      myFailure.extract(from: .failure(MyError()))
    )
    XCTAssertNil(
      mySuccess.extract(from: .failure(MyError()))
    )
  }

  func testIdentity() {
    let id = /Int.self
    XCTAssertEqual(
      .some(42),
      id.extract(from: 42)
    )
    XCTAssertEqual(
      .some(42),
      (/.self)
        .extract(from: 42)
    )

    XCTAssertEqual(
      .some(42),
      CasePath(Int.self).extract(from: 42)
    )
    XCTAssertEqual(
      .some(42),
      CasePath(Int.self)
        .extract(from: 42)
    )
  }

  func testSome() {
    XCTAssertEqual(
      (/.some).extract(from: Optional(42)),
      .some(42)
    )
  }

  func testLabeledCases() {
    enum Foo: Equatable {
      case bar(some: Int)
      case bar(none: Int)
    }

    let fooBarSome = /Foo.bar(some:)
    XCTAssertEqual(
      .some(42),
      fooBarSome.extract(from: .bar(some: 42))
    )
    XCTAssertNil(
      fooBarSome.extract(from: .bar(none: 42))
    )

    XCTAssertEqual(
      .some(42),
      CasePath(Foo.bar(some:)).extract(from: .bar(some: 42))
    )
    XCTAssertNil(
      CasePath(Foo.bar(some:)).extract(from: .bar(none: 42))
    )
  }

  func testMultiCases() {
    enum Foo {
      case bar(Int, String)
    }

    guard let fizzBuzz = (/Foo.bar).extract(from: .bar(42, "Blob"))
    else {
      XCTFail()
      return
    }
    XCTAssertEqual(42, fizzBuzz.0)
    XCTAssertEqual("Blob", fizzBuzz.1)
  }

  func testMultiLabeledCases() {
    enum Foo {
      case bar(fizz: Int, buzz: String)
    }

    let fooBar: CasePath<Foo, (fizz: Int, buzz: String)> = /Foo.bar(fizz:buzz:)
    guard let fizzBuzz = fooBar.extract(from: .bar(fizz: 42, buzz: "Blob"))
    else {
      XCTFail()
      return
    }
    XCTAssertEqual(42, fizzBuzz.fizz)
    XCTAssertEqual("Blob", fizzBuzz.buzz)
  }

  func testMultiMixedCases() {
    enum Foo {
      case bar(Int, buzz: String)
    }

    guard let fizzBuzz = (/Foo.bar).extract(from: .bar(42, buzz: "Blob"))
    else {
      XCTFail()
      return
    }
    XCTAssertEqual(42, fizzBuzz.0)
    XCTAssertEqual("Blob", fizzBuzz.1)
  }

  func testNestedZeroMemoryLayout() {
    enum Foo {
      case bar(Bar)
    }
    enum Bar: Equatable {
      case baz
    }

    let fooBar = /Foo.bar
    XCTAssertEqual(
      .baz,
      fooBar.extract(from: .bar(.baz))
    )
  }

  func testCompoundUninhabitedType() {
    // Under Swift 5.1 (Xcode 11.3), this test creates a bogus instance of the tuple
    // `(Never, Never)`, but remarkably, doesn't cause a crash and extracts the correct answer
    // (`nil`).

    enum Enum {
      case nevers(Never, Never)
      case something(Void)
    }

    let path: CasePath<Enum, (Never, Never)> = /Enum.nevers(_:_:)

    for _ in 1...2 {
      XCTAssertNil(path.extract(from: Enum.something(())))
    }
  }

  func testNestedUninhabitedTypes() {
    enum Uninhabited {}

    enum Foo {
      case foo
      case bar(Uninhabited)
      case baz(Never)
    }

    let fooBar = /Foo.bar
    XCTAssertNil(fooBar.extract(from: Foo.foo))

    let fooBaz = /Foo.baz
    XCTAssertNil(fooBaz.extract(from: Foo.foo))
  }

  func testEnumsWithoutAssociatedValues() {
    enum Foo: Equatable {
      case bar
      case baz
    }

    XCTAssertNotNil(
      (/Foo.bar)
        .extract(from: .bar)
    )
    XCTAssertNil(
      (/Foo.bar)
        .extract(from: .baz)
    )

    XCTAssertNotNil(
      (/Foo.baz)
        .extract(from: .baz)
    )
    XCTAssertNil(
      (/Foo.baz)
        .extract(from: .bar)
    )
  }

  func testEnumsWithClosures() {
    enum Foo {
      case bar(() -> Void)
    }

    var didRun = false
    let fooBar = /Foo.bar
    guard let bar = fooBar.extract(from: .bar { didRun = true })
    else {
      XCTFail()
      return
    }
    bar()
    XCTAssertTrue(didRun)
  }

  func testRecursive() {
    indirect enum Foo {
      case foo(Foo)
      case bar(Int)
    }

    XCTAssertEqual(
      .some(42),
      (/Foo.foo .. /Foo.foo .. /Foo.foo .. /Foo.bar).extract(from: .foo(.foo(.foo(.bar(42)))))
    )
    XCTAssertNil(
      (/Foo.foo .. /Foo.foo .. /Foo.foo .. /Foo.bar).extract(from: .foo(.foo(.bar(42))))
    )
  }

  func testExtract() {
    struct MyError: Error {}

    XCTAssertEqual(
      [1],
      [Result.success(1), .success(nil), .failure(MyError())]
        .compactMap(/Result.success .. Optional.some)
    )

    enum Authentication {
      case authenticated(token: String)
      case unauthenticated
    }

    XCTAssertEqual(
      ["deadbeef"],
      [Authentication.authenticated(token: "deadbeef"), .unauthenticated]
        .compactMap(/Authentication.authenticated)
    )

    XCTAssertEqual(
      1,
      [Authentication.authenticated(token: "deadbeef"), .unauthenticated]
        .compactMap(/Authentication.unauthenticated)
        .count
    )

    enum Foo { case bar(Int, Int) }
    XCTAssertEqual(
      [3],
      [Foo.bar(1, 2)].compactMap(/Foo.bar).map(+)
    )

    enum Case {
      case one(One)
      case none
    }
    enum One {
      case two(Two)
    }
    enum Two {
      case value(Int)
    }

    XCTAssertEqual(
      [1],
      [Case.one(.two(.value(1))), .none].compactMap(/Case.one .. One.two .. Two.value)
    )
  }

  func testAppending() {
    let success = /Result<Int?, Error>.success
    let int = /Int?.some
    let success2int = success .. int
    XCTAssertEqual(
      .some(42),
      success2int.extract(from: .success(.some(42)))
    )
  }

  func testExample() {
    XCTAssertEqual("Blob", (/Result<String, Error>.success).extract(from: .success("Blob")))
    XCTAssertNil((/Result<String, Error>.failure).extract(from: .success("Blob")))

    XCTAssertEqual(42, (/Int??.some .. Int?.some).extract(from: Optional(Optional(42))))
  }

  func testConstantCasePath() {
    XCTAssertEqual(.some(42), CasePath.constant(42).extract(from: ()))
    XCTAssertNotNil(CasePath.constant(42).embed(42))
  }

  func testNeverCasePath() {
    XCTAssertNil(CasePath.never.extract(from: 42))
  }

  func testRawValuePath() {
    enum Foo: String { case bar, baz }

    XCTAssertEqual(.some(.bar), CasePath<String, Foo>.rawValue.extract(from: "bar"))
    XCTAssertEqual("baz", CasePath.rawValue.embed(Foo.baz))
  }

  func testDescriptionPath() {
    XCTAssertEqual(.some(42), CasePath.description.extract(from: "42"))
    XCTAssertEqual("42", CasePath.description.embed(42))
  }

  func testA() {
    enum EnumWithLabeledCase {
      case labeled(label: Int, otherLabel: Int)
      case labeled(Int, Int)
    }
    XCTAssertNil((/EnumWithLabeledCase.labeled(label:otherLabel:)).extract(from: .labeled(2, 2)))
    XCTAssertNotNil(
      (/EnumWithLabeledCase.labeled(label:otherLabel:)).extract(
        from: .labeled(label: 2, otherLabel: 2)))
  }

  func testPatternMatching() {
    let results = [
      Result<Int, NSError>.success(1),
      .success(2),
      .failure(NSError(domain: "co.pointfree", code: -1)),
      .success(3),
    ]
    XCTAssertEqual(
      Array(results.lazy.prefix(while: { /Result.success ~= $0 }).compactMap(/Result.success)),
      [1, 2]
    )

    switch results[0] {
    case /Result.success:
      break
    default:
      XCTFail()
    }
  }

  func testCustomStringConvertible() {
    XCTAssertEqual(
      "\(/Result<String, Error>.success)",
      "CasePath<Result<String, Error>, String>"
    )
  }

  func testOptionalInsideResult() {
    let result: Result<String?, Error> = .success("hello, world")
    let path: CasePath<Result<String?, Error>, String> = /Result.success
    let actual = path.extract(from: result)
    XCTAssertEqual(
      actual,
      "hello, world")

    XCTAssertNil((/Result.failure).extract(from: result))

    let success: (Result<String?, Error>) -> String? = /Result.success
    XCTAssertEqual(success(result), "hello, world")
    let failure: (Result<String?, Error>) -> Error? = /Result.failure
    XCTAssertNil(failure(result))
  }

  func testExtractFromOptionalRoot() {
    enum Foo {
      case foo(String)
      case bar(String)
      case baz
    }

    var opt: Foo? = .foo("blob1")
    XCTAssertEqual("blob1", (/Foo.foo).extract(from: opt))
    XCTAssertNil((/Foo.bar).extract(from: opt))
    XCTAssertNil((/Foo.baz).extract(from: opt))

    opt = .bar("blob2")
    XCTAssertNil((/Foo.foo).extract(from: opt))
    XCTAssertEqual("blob2", (/Foo.bar).extract(from: opt))
    XCTAssertNil((/Foo.baz).extract(from: opt))

    opt = .baz
    XCTAssertNil((/Foo.foo).extract(from: opt))
    XCTAssertNil((/Foo.bar).extract(from: opt))
    XCTAssertNotNil((/Foo.baz).extract(from: opt))

    opt = nil
    XCTAssertNil((/Foo.foo).extract(from: opt))
    XCTAssertNil((/Foo.bar).extract(from: opt))
    XCTAssertNil((/Foo.baz).extract(from: opt))

    let extractExpression: (Foo?) -> String? = /Foo.foo
    XCTAssertNotNil(extractExpression(.some(.foo("blob1"))))
    XCTAssertNil(extractExpression(.some(.bar("blob2"))))
    XCTAssertNil(extractExpression(.some(.baz)))
    XCTAssertNil(extractExpression(nil))

    let voidExtractExpression: (Foo?) -> Void? = /Foo.baz
    XCTAssertNil(voidExtractExpression(.some(.foo("blob1"))))
    XCTAssertNil(voidExtractExpression(.some(.bar("blob2"))))
    XCTAssertNotNil(voidExtractExpression(.some(.baz)))
    XCTAssertNil(voidExtractExpression(nil))
  }

  func testExtractFromOptionalRootWithEmbeddedTagBits() {
    enum E {
      case c1(TestObject)
      case c2(TestObject)
    }

    let o = TestObject()
    let c1Path: CasePath<E?, TestObject> = /E.c1
    let c2Path: CasePath<E?, TestObject> = /E.c2

    func check(_ path: CasePath<E?, TestObject>, _ input: E?, _ expected: TestObject?) {
      let actual = path.extract(from: input)
      XCTAssertEqual(actual, expected)
    }

    for _ in 1...2 {
      check(c1Path, nil, nil)
      check(c1Path, .c1(o), o)
      check(c1Path, .c2(o), nil)
      check(c2Path, nil, nil)
      check(c2Path, .c1(o), nil)
      check(c2Path, .c2(o), o)
    }
  }

  func testExtractSuccessFromFailedResultWithErrorProtocolError() {
    let path = /Result<String, Error>.success

    func check(_ error: Error) {
      let result = Result<String, Error>.failure(error)
      XCTAssertNil(path.extract(from: result))
    }

    struct EmptyError: Error {
    }

    struct LittleError: Error {
      var a = 42
    }

    struct BigError: Error {
      var a = ""
      var b = ""
      var c = ""
      var d = ""
      var e = ""
      var f = ""
    }

    for _ in 1...2 {
      check(EmptyError())
      check(LittleError())
      check(BigError())
      XCTAssertEqual(path.extract(from: .success("hello")), "hello")
    }
  }

  func testExtractionFailureOfOptional() {
    enum Action {
      case child1(Child1)
      case child2(Child2?)
    }
    enum Child1 {
      case a
    }
    enum Child2 {
      case b
    }

    XCTAssertNil((/Action.child1).extract(from: .child2(.b)))
  }

  func testModify() throws {
    enum Foo: Equatable { case bar(Int) }
    var foo = Foo.bar(42)
    try (/Foo.bar).modify(&foo) { $0 *= 2 }
    XCTAssertEqual(foo, .bar(84))
  }

  func testRegression_gh72() throws {
    enum E1 {
      case c1(E2)
    }

    enum E2 {
      case c1(Bool)
      case c2(Bool)
      case c3(Any)
    }

    XCTAssertNotNil(
      (/E1.c1).extract(from: .c1(.c1(true)))
    )
    XCTAssertNotNil(
      (/E1.c1).extract(from: .c1(.c2(true)))
    )
  }

  #if canImport(_Concurrency) && compiler(>=5.5.2)
    #if os(Windows)
      // There seems to be some strangeness with the current
      // concurrency implmentation on Windows that breaks if
      // you have more than 100 tasks here.
      let maxIterations = 100
    #else
      let maxIterations = 100_000
    #endif

    func testConcurrency_SharedCasePath() async throws {
      enum Enum { case payload(Int) }
      let casePath = /Enum.payload

      await withTaskGroup(of: Void.self) { group in
        for index in 1...maxIterations {
          group.addTask {
            XCTAssertEqual(casePath.extract(from: Enum.payload(index)), index)
          }
        }
      }
    }

    func testConcurrency_NonSendableEmbed() async throws {
      enum Enum: Equatable { case payload(Int) }
      var count = 0

      await withTaskGroup(of: Void.self) { group in
        for index in 1...maxIterations {
          let casePath1 = CasePath<Enum, Int> {
            count += 1
            return .payload($0)
          }
          group.addTask {
            XCTAssertEqual(casePath1.extract(from: Enum.payload(index)), index)
            XCTAssertEqual(casePath1.embed(index), .payload(index))
          }

          let casePath2 = CasePath<Enum, Int> {
            count += 1
            return .payload($0)
          }
          group.addTask {
            XCTAssertEqual(casePath2.extract(from: Enum.payload(index)), index)
            XCTAssertEqual(casePath2.embed(index), .payload(index))
          }
        }
      }

      XCTAssertEqual(count, maxIterations * 4)
    }
  #endif
}

private class TestObject: Equatable {
  static func == (lhs: TestObject, rhs: TestObject) -> Bool { lhs === rhs }
}

// Replace this with XCTUnwrap when we drop support for Xcode 11.3.
private func unwrap<Wrapped>(_ optional: Wrapped?) throws -> Wrapped {
  guard let wrapped = optional else { throw UnexpectedNil() }
  return wrapped
}
private struct UnexpectedNil: Error {}
