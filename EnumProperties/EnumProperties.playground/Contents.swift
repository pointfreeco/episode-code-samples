import EnumProperties
import Foundation
import SwiftSyntax

let url = Bundle.main.url(forResource: "Enums", withExtension: "swift")!
let tree = try SyntaxTreeParser.parse(url)
let visitor = Visitor()
tree.walk(visitor)
