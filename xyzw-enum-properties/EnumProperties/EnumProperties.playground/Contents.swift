import SwiftSyntax
import Foundation

let tree = try SyntaxTreeParser.parse(
  Bundle.main.url(forResource: "Enums", withExtension: "swift")!
)

// extension Validated {
//   var valid: Valid? {
//     guard case let .valid(value) = self else { return nil }
//     return value
//   }
//   var invalid: [Invalid?] {
//     guard case let .valid(value) = self else { return nil }
//     return value
//   }
// }

class Visitor: SyntaxVisitor {
  override func visitPre(_ node: Syntax) {

  }
  override func visitPost(_ node: Syntax) {
    if node is EnumDeclSyntax {
      print("}")
    }
  }
  override func visit(_ node: EnumDeclSyntax) -> SyntaxVisitorContinueKind {
    print("extension \(node.identifier.withoutTrivia()) {")
    return .visitChildren
  }

  override func visit(_ node: EnumCaseDeclSyntax) -> SyntaxVisitorContinueKind {
    node.elements.forEach {

      let propertyType: String
      let pattern: String
      let returnValue: String
      if let associatedValue = $0.associatedValue {
        propertyType = associatedValue.parameterList.count == 1
          ? "\(associatedValue.parameterList[0].type!)"
          : "\(associatedValue)"
        pattern = "let .\($0.identifier)(value)"
        returnValue = "value"
      } else {
        propertyType = "Void"
        pattern = ".\($0.identifier)"
        returnValue = "()"
      }
      print("  var \($0.identifier): \(propertyType)? {")
      print("    guard case \(pattern) = self else { return nil }")
      print("    return \(returnValue)")
      print("  }")
      let identifier = "\($0.identifier)"
      let capitalizedIdentifier = "\(identifier.first!.uppercased())\(identifier.dropFirst())"
      print("  var is\(capitalizedIdentifier): Bool {")
      print("    return self.\($0.identifier) != nil")
      print("  }")
    }
    return .skipChildren
  }
}

let visitor = Visitor()
//visitor.visit(tree)
tree.walk(visitor)

enum Validated<Valid, Invalid> {
  case valid(Valid)
  case invalid([Invalid])
}

enum Node {
  case element(tag: String, attributes: [String: String], children: [Node])
  case text(content: String)
}

enum Loading<A> {
  case loading
  case loaded(A)
  case cancelled
}
extension Validated {
  var valid: Valid? {
    guard case let .valid(value) = self else { return nil }
    return value
  }
  var isValid: Bool {
    return self.valid != nil
  }
  var invalid: [Invalid]? {
    guard case let .invalid(value) = self else { return nil }
    return value
  }
  var isInvalid: Bool {
    return self.invalid != nil
  }
}
extension Node {
  var element: (tag: String, attributes: [String: String], children: [Node])? {
    guard case let .element(value) = self else { return nil }
    return value
  }
  var isElement: Bool {
    return self.element != nil
  }
  var text: String? {
    guard case let .text(value) = self else { return nil }
    return value
  }
  var isText: Bool {
    return self.text != nil
  }
}
extension Loading {
  var loading: Void? {
    guard case .loading = self else { return nil }
    return ()
  }
  var isLoading: Bool {
    return self.loading != nil
  }
  var loaded: A? {
    guard case let .loaded(value) = self else { return nil }
    return value
  }
  var isLoaded: Bool {
    return self.loaded != nil
  }
  var cancelled: Void? {
    guard case .cancelled = self else { return nil }
    return ()
  }
  var isCancelled: Bool {
    return self.cancelled != nil
  }
}


//
//extension Validated {
//  var valid: Valid? {
//    guard case let .valid(value) = self else { return nil }
//    return value
//  }
//  var isValid: Bool {
//    return self.valid != nil
//  }
//  var invalid: [Invalid]? {
//    guard case let .invalid(value) = self else { return nil }
//    return value
//  }
//  var isInvalid: Bool {
//    return self.invalid != nil
//  }
//}
//extension Node {
//  var element: (tag: String, attributes: [String: String], children: [Node])? {
//    guard case let .element(value) = self else { return nil }
//    return value
//  }
//  var isElement: Bool {
//    return self.element != nil
//  }
//  var text: String? {
//    guard case let .text(value) = self else { return nil }
//    return value
//  }
//  var isText: Bool {
//    return self.text != nil
//  }
//}
//extension Loading {
//  var loading: Void? {
//    guard case .loading = self else { return nil }
//    return ()
//  }
//  var isLoading: Bool {
//    return self.loading != nil
//  }
//  var loaded: A? {
//    guard case let .loaded(value) = self else { return nil }
//    return value
//  }
//  var isLoaded: Bool {
//    return self.loaded != nil
//  }
//  var cancelled: Void? {
//    guard case .cancelled = self else { return nil }
//    return ()
//  }
//  var isCancelled: Bool {
//    return self.cancelled != nil
//  }
//}
//
//let link = Node.element(tag: "a", attributes: ["href": "/"], children: [.text(content: "There's no place like home")])
//
//link.element?.tag
//
//link.element?.children
//  .compactMap { $0.text }
//
//link.text
//
//let status = Loading<String>.loading
////status == .loading
//status.loading != nil
//status.isLoading
//
//let requests: [Loading<String>] = [
//  .cancelled,
//  .loaded("Blob's Travel Blog"),
//  .loading,
//  .loading,
//  .loaded("Blob's Food Blog"),
//  .loading,
//]
//
//requests.compactMap { $0.loaded }
//
//requests.filter { $0.isLoading }.count
//
//requests.filter { $0.isCancelled }.count


1


