import Foundation
import EnumProperties
import SwiftSyntax

let urls = CommandLine.arguments.dropFirst()
  .map { URL(fileURLWithPath: $0) }

let visitor = Visitor()

try urls.forEach { url in
  let tree = try SyntaxTreeParser.parse(url)
  tree.walk(visitor)
}

print(visitor.output)
