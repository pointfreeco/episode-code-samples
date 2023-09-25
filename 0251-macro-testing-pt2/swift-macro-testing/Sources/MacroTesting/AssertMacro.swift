import InlineSnapshotTesting
import SwiftDiagnostics
import SwiftParser
import SwiftParserDiagnostics
import SwiftSyntax
import SwiftSyntaxMacroExpansion
import SwiftSyntaxMacros
import XCTest

/// Asserts that a given Swift source string matches an expected string with all macros expanded.
///
/// To write a macro assertion, you simply pass the mapping of macros to expand along with the
/// source code that should be expanded:
///
/// ```swift
/// func testMacro() {
///   assertMacro(["stringify": StringifyMacro.self]) {
///     """
///     #stringify(a + b)
///     """
///   }
/// }
/// ```
///
/// When this test is run, the result of the expansion is automatically written to the test file,
/// inlined, as a trailing argument:
///
/// ```swift
/// func testMacro() {
///   assertMacro(["stringify": StringifyMacro.self]) {
///     """
///     #stringify(a + b)
///     """
///   } matches: {
///     """
///     (a + b, "a + b")
///     """
///   }
/// }
/// ```
///
/// If the expansion fails, diagnostics are inlined instead:
///
/// ```swift
/// assertMacro(["MetaEnum": MetaEnumMacro.self]) {
///   """
///   @MetaEnum struct Cell {
///     let integer: Int
///     let text: String
///     let boolean: Bool
///   }
///   """
/// } matches: {
///   """
///   @MetaEnum struct Cell {
///   ┬────────
///   ╰─ 🛑 '@MetaEnum' can only be attached to an enum, not a struct
///     let integer: Int
///     let text: String
///     let boolean: Bool
///   }
///   """
/// }
/// ```
///
/// > Tip: Use ``withMacroTesting(isRecording:macros:operation:)-2vypn`` in your test case's
/// > `invokeTest` to avoid the repetitive work of passing the macro mapping to every `assertMacro`:
/// >
/// > ```swift
/// > override func invokeTest() {
/// >   // By wrapping each test with macro testing configuration...
/// >   withMacroTesting(macros: ["stringify": StringifyMacro.self]) {
/// >     super.invokeTest()
/// >   }
/// > }
/// >
/// > func testMacro() {
/// >   assertMacro {  // ...we can omit it from the assertion.
/// >     """
/// >     #stringify(a + b)
/// >     """
/// >   } matches: {
/// >     """
/// >     (a + b, "a + b")
/// >     """
/// >   }
/// > }
/// > ```
/// 
/// - Parameters:
///   - macros: The macros to expand in the original source string. Required, either implicitly via
///     ``withMacroTesting(isRecording:macros:operation:)-2vypn``, or explicitly via this parameter.
///   - applyFixIts: Applies fix-its to the original source and snapshots the result. If there are
///     no fix-its to apply, or if any diagnostics are unfixable, the assertion will fail.
///   - isRecording: Always records new snapshots when enabled.
///   - originalSource: A string of Swift source code.
///   - expandedOrDiagnosedSource: The expected Swift source string with macros or diagnostics
///     expanded.
///   - file: The file where the assertion occurs. The default is the filename of the test case
///     where you call this function.
///   - function: The function where the assertion occurs. The default is the name of the test
///     method where you call this function.
///   - line: The line where the assertion occurs. The default is the line number where you call
///     this function.
///   - column: The column where the assertion occurs. The default is the line number where you call
///     this function.
public func assertMacro(
  _ macros: [String: Macro.Type]? = nil,
  applyFixIts: Bool = false,
  record isRecording: Bool? = nil,
  of originalSource: () throws -> String,
  matches expandedOrDiagnosedSource: (() -> String)? = nil,
  file: StaticString = #filePath,
  function: StaticString = #function,
  line: UInt = #line,
  column: UInt = #column
) {
  let macros = macros ?? MacroTestingConfiguration.current.macros
  guard !macros.isEmpty else {
    XCTFail(
      """
      No macros configured for assertion. Pass a mapping to this function, e.g.:

          assertMacro(["stringify": StringifyMacro.self]) { … }

      Or wrap your assertion using 'withMacroTesting', e.g. in 'invokeTest':

          class StringifyMacroTests: XCTestCase {
            override func invokeTest() {
              withMacroTesting(macros: ["stringify": StringifyMacro.self]) {
                super.invokeTest()
              }
            }
            …
          }
      """,
      file: file,
      line: line
    )
    return
  }

  let wasRecording = SnapshotTesting.isRecording
  SnapshotTesting.isRecording = isRecording ?? MacroTestingConfiguration.current.isRecording
  defer { SnapshotTesting.isRecording = wasRecording }

  assertInlineSnapshot(
    of: try originalSource(),
    as: .macroExpansion(macros, applyFixIts: applyFixIts, file: file, line: line),
    message: """
      Actual output (\(actualPrefix)) differed from expected output (\(expectedPrefix)). \
      Difference: …
      """,
    syntaxDescriptor: InlineSnapshotSyntaxDescriptor(
      trailingClosureLabel: "matches",
      trailingClosureOffset: 1
    ),
    matches: expandedOrDiagnosedSource,
    file: file,
    function: function,
    line: line,
    column: column
  )
}

/// Customizes `assertMacro` for the duration of an operation.
///
/// Use this operation to customize how the `assertMacro` behaves in a test. It is most convenient
/// to use this tool to wrap `invokeTest` in a `XCTestCase` subclass so that the configuration
/// applies to every test method.
///
/// For example, to specify which macros will be expanded during an assertion for an entire test
/// case you can do the following:
///
/// ```swift
/// class StringifyTests: XCTestCase {
///   override func invokeTest() {
///     withMacroTesting(macros: [StringifyMacro.self]) {
///       super.invokeTest()
///     }
///   }
/// }
/// ```
///
/// And to re-record all macro expansions in a test case you can do the following:
///
/// ```swift
/// class StringifyTests: XCTestCase {
///   override func invokeTest() {
///     withMacroTesting(isRecording: true, macros: [StringifyMacro.self]) {
///       super.invokeTest()
///     }
///   }
/// }
/// ```
///
/// - Parameters:
///   - isRecording: Determines if a new macro expansion will be recorded.
///   - macros: Specifies the macros to be expanded in the input Swift source string.
///   - operation: The operation to run with the configuration updated.
public func withMacroTesting<R>(
  isRecording: Bool? = nil,
  macros: [String: Macro.Type]? = nil,
  operation: () async throws -> R
) async rethrows {
  var configuration = MacroTestingConfiguration.current
  if let isRecording = isRecording { configuration.isRecording = isRecording }
  if let macros = macros { configuration.macros = macros }
  try await MacroTestingConfiguration.$current.withValue(configuration) {
    try await operation()
  }
}

/// Customizes `assertMacro` for the duration of an operation.
///
/// See ``withMacroTesting(isRecording:macros:operation:)-2vypn`` for more details.
public func withMacroTesting<R>(
  isRecording: Bool? = nil,
  macros: [String: Macro.Type]? = nil,
  operation: () throws -> R
) rethrows {
  var configuration = MacroTestingConfiguration.current
  if let isRecording = isRecording { configuration.isRecording = isRecording }
  if let macros = macros { configuration.macros = macros }
  try MacroTestingConfiguration.$current.withValue(configuration) {
    try operation()
  }
}

/// Customizes `assertMacro` for the duration of an operation.
///
/// See ``withMacroTesting(isRecording:macros:operation:)-2vypn`` for more details.
public func withMacroTesting<R>(
  isRecording: Bool? = nil,
  macros: [Macro.Type],
  operation: () async throws -> R
) async rethrows {
  try await withMacroTesting(
    isRecording: isRecording,
    macros: Dictionary(macros: macros),
    operation: operation
  )
}

/// Customizes `assertMacro` for the duration of an operation.
///
/// See ``withMacroTesting(isRecording:macros:operation:)-2vypn`` for more details.
public func withMacroTesting<R>(
  isRecording: Bool? = nil,
  macros: [Macro.Type],
  operation: () throws -> R
) rethrows {
  try withMacroTesting(
    isRecording: isRecording,
    macros: Dictionary(macros: macros),
    operation: operation
  )
}

extension Snapshotting where Value == String, Format == String {
  fileprivate static let _lines = Snapshotting(
    pathExtension: "txt",
    diffing: Diffing(
      toData: { Data($0.utf8) },
      fromData: { String(decoding: $0, as: UTF8.self) }
    ) { actual, expected in
      guard expected != actual else { return nil }

      let actualLines = actual.split(separator: "\n", omittingEmptySubsequences: false)

      let expectedLines = expected.split(separator: "\n", omittingEmptySubsequences: false)
      let difference = actualLines.difference(from: expectedLines)

      var result = ""

      var insertions = [Int: Substring]()
      var removals = [Int: Substring]()

      for change in difference {
        switch change {
        case let .insert(offset, element, _):
          insertions[offset] = element
        case let .remove(offset, element, _):
          removals[offset] = element
        }
      }

      var expectedLine = 0
      var actualLine = 0

      while expectedLine < expectedLines.count || actualLine < actualLines.count {
        if let removal = removals[expectedLine] {
          result += "\(expectedPrefix) \(removal)\n"
          expectedLine += 1
        } else if let insertion = insertions[actualLine] {
          result += "\(actualPrefix) \(insertion)\n"
          actualLine += 1
        } else {
          result += "\(prefix) \(expectedLines[expectedLine])\n"
          expectedLine += 1
          actualLine += 1
        }
      }

      let attachment = XCTAttachment(
        data: Data(result.utf8),
        uniformTypeIdentifier: "public.patch-file"
      )
      return (result, [attachment])
    }
  )
}

extension Snapshotting where Value == String, Format == String {
  fileprivate static func macroExpansion(
    _ macros: [String: Macro.Type],
    applyFixIts: Bool,
    testModuleName: String = "TestModule",
    testFileName: String = "Test.swift",
    indentationWidth: Trivia? = nil,
    file: StaticString = #filePath,
    line: UInt = #line
  ) -> Self {
    Snapshotting<String, String>._lines.pullback { input in
      let origSourceFile = Parser.parse(source: input)
      let origDiagnostics = ParseDiagnosticsGenerator.diagnostics(for: origSourceFile)

      let context = BasicMacroExpansionContext(
        sourceFiles: [
          origSourceFile: .init(moduleName: testModuleName, fullFilePath: testFileName)
        ]
      )
      let indentationWidth =
        indentationWidth
        ?? Trivia(
          stringLiteral: String(
            SourceLocationConverter(fileName: "-", tree: origSourceFile).sourceLines
              .first(where: { $0.first?.isWhitespace == true && $0 != "\n" })?
              .prefix(while: { $0.isWhitespace })
              ?? "    "
          )
        )
      let expandedSourceFile = origSourceFile.expand(
        macros: macros,
        in: context,
        indentationWidth: indentationWidth
      )

      guard
        origDiagnostics.isEmpty,
        context.diagnostics.isEmpty
      else {
        let allDiagnostics = origDiagnostics + context.diagnostics

        func anchor(_ diag: Diagnostic) -> Diagnostic {
          let location = context.location(for: diag.position, anchoredAt: diag.node, fileName: "")
          return Diagnostic(
            node: diag.node,
            position: AbsolutePosition(utf8Offset: location.offset),
            message: diag.diagMessage,
            highlights: diag.highlights,
            notes: diag.notes,
            fixIts: diag.fixIts
          )
        }

        let unfixableDiagnostics = allDiagnostics.filter { $0.fixIts.isEmpty }
        if applyFixIts, unfixableDiagnostics.isEmpty {
          let fixedSourceFile = FixItApplier.applyFixes(
            context: context, in: allDiagnostics.map(anchor), to: origSourceFile
          )
          return diagnosticsOrTree(context: context, diags: [], tree: fixedSourceFile)
        } else {
          if applyFixIts {
            XCTFail("Not all diagnostics are fixable.", file: file, line: line)
          }
          return diagnosticsOrTree(
            context: context, diags: allDiagnostics.map(anchor), tree: origSourceFile
          )
        }
      }

      if applyFixIts {
        XCTFail("No fix-its to apply.", file: file, line: line)
      }

      return diagnosticsOrTree(
        context: context,
        diags: ParseDiagnosticsGenerator.diagnostics(for: expandedSourceFile),
        tree: expandedSourceFile
      )
    }
  }
}

internal func macroName(className: String, isExpression: Bool) -> String {
  var name =
    className
    .replacingOccurrences(of: "Macro$", with: "", options: .regularExpression)
  if !name.isEmpty, isExpression {
    var prefix = name.prefix(while: \.isUppercase)
    if prefix.count > 1, name[prefix.endIndex...].first?.isLowercase == true {
      prefix.removeLast()
    }
    name.replaceSubrange(prefix.startIndex..<prefix.endIndex, with: prefix.lowercased())
  }
  return name
}

private func diagnosticsOrTree(
  context: BasicMacroExpansionContext,
  diags: [Diagnostic],
  tree: some SyntaxProtocol
) -> String {
  guard !diags.isEmpty
  else { return tree.description.trimmingCharacters(in: .newlines) }

  let converter = SourceLocationConverter(fileName: "-", tree: tree)
  let lineCount = converter.location(for: tree.endPosition).line
  return
    DiagnosticsFormatter
    .annotatedSource(tree: tree, diags: diags, context: context, contextSize: lineCount)
    .description
    .replacingOccurrences(of: #"(^|\n) *\d* +│ "#, with: "$1", options: .regularExpression)
    .trimmingCharacters(in: .newlines)
}

private struct MacroTestingConfiguration {
  @TaskLocal static var current = Self()

  var isRecording = false
  var macros: [String: Macro.Type] = [:]
}

extension Dictionary where Key == String, Value == Macro.Type {
  fileprivate init(macros: [Macro.Type]) {
    self.init(
      macros.map {
        let name = macroName(
          className: String(describing: $0),
          isExpression: $0 is ExpressionMacro.Type
        )
        return (key: name, value: $0)
      },
      uniquingKeysWith: { _, rhs in rhs }
    )
  }
}

private class FixItApplier: SyntaxRewriter {
  let context: BasicMacroExpansionContext
  let diagnostics: [Diagnostic]

  init(context: BasicMacroExpansionContext, diagnostics: [Diagnostic]) {
    self.context = context
    self.diagnostics = diagnostics
    super.init(viewMode: .all)
  }

  public override func visitAny(_ node: Syntax) -> Syntax? {
    for diagnostic in diagnostics {
      for fixIts in diagnostic.fixIts {
        for change in fixIts.changes {
          switch change {
          case .replace(let oldNode, let newNode):
            let offset = context
              .location(for: oldNode.position, anchoredAt: oldNode, fileName: "")
              .offset
            if node.position.utf8Offset == offset {
              return newNode
            }
          default:
            break
          }
        }
      }
    }
    return nil
  }

  override func visit(_ node: TokenSyntax) -> TokenSyntax {
    var modifiedNode = node
    for diagnostic in diagnostics {
      for fixIts in diagnostic.fixIts {
        for change in fixIts.changes {
          switch change {
          case .replaceLeadingTrivia(token: let changedNode, let newTrivia)
          where changedNode.id == node.id:
            modifiedNode = node.with(\.leadingTrivia, newTrivia)
          case .replaceTrailingTrivia(token: let changedNode, let newTrivia)
          where changedNode.id == node.id:
            modifiedNode = node.with(\.trailingTrivia, newTrivia)
          default:
            break
          }
        }
      }
    }
    return modifiedNode
  }

  public static func applyFixes(
    context: BasicMacroExpansionContext,
    in diagnostics: [Diagnostic],
    to tree: some SyntaxProtocol
  ) -> Syntax {
    let applier = FixItApplier(context: context, diagnostics: diagnostics)
    return applier.rewrite(tree)
  }
}

private let expectedPrefix = "\u{2212}"
private let actualPrefix = "+"
private let prefix = "\u{2007}"
