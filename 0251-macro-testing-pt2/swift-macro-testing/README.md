# Macro Testing

[![CI](https://github.com/pointfreeco/swift-macro-testing/workflows/CI/badge.svg)](https://github.com/pointfreeco/swift-macro-testing/actions?query=workflow%3ACI)
[![Slack](https://img.shields.io/badge/slack-chat-informational.svg?label=Slack&logo=slack)](https://www.pointfree.co/slack-invite)
[![](https://img.shields.io/endpoint?url=https%3A%2F%2Fswiftpackageindex.com%2Fapi%2Fpackages%2Fpointfreeco%2Fswift-macro-testing%2Fbadge%3Ftype%3Dswift-versions)](https://swiftpackageindex.com/pointfreeco/swift-macro-testing)
[![](https://img.shields.io/endpoint?url=https%3A%2F%2Fswiftpackageindex.com%2Fapi%2Fpackages%2Fpointfreeco%2Fswift-macro-testing%2Fbadge%3Ftype%3Dplatforms)](https://swiftpackageindex.com/pointfreeco/swift-macro-testing)

Powerful testing tools for Swift macros.

## Learn more

This library was designed to support libraries and episodes produced for [Point-Free][point-free], a
video series exploring the Swift programming language hosted by [Brandon Williams][mbrandonw] and
[Stephen Celis][stephencelis].

You can watch all of the episodes [here](TODO).

<a href="TODO">
  <img alt="video poster image" src="https://d3rccdn33rt8ze.cloudfront.net/episodes/0250.jpeg" width="600">
</a>

## Motivation

This library comes with a tool for testing macros that is more powerful and ergonomic than the
default tool that comes with SwiftSyntax. To use the tool, simply specify the array of macros that
you want to expand as well as a string of Swift source code that makes use of the macro.

For example, to test the `#stringify` macro that comes with SPM's macro template all one needs to
do is write the following: 

```swift
import MacroTesting
import XCTest

class StringifyTests: XCTestCase {
  func testStringify() {
    assertMacro([StringifyMacro.self]) {
      """
      #stringify(a + b)
      """
    }
  }
}
```

When you run this test the library will automatically expand the macros in the source code string
and write the expansion into the test file:

```swift
func testStringify() {
  assertMacro([StringifyMacro.self]) {
    """
    #stringify(a + b)
    """
  } matches: {
    """
    (a + b, "a + b")
    """
  }
}
```

That is all it takes.

Further, if the macro expansion emits a diagnostic, such as a warning or an error, it will render
inline in the test. For example, if a macro can only be applied to enums but you apply it to a 
struct, then the diagnostic will be rendered like so:

```swift
func testNonEnum() {
  assertMacro {
    """
    @MetaEnum
    struct User {
      let id: UUID
      var name: String
    }
    """
  } matches: {
    """
    @MetaEnum
    ┬────────
    ╰─ 🛑 '@MetaEnum' can only be attached to an enum, not a struct
    struct User {
      let id: UUID
      var name: String
    }
    """
  }
}
```

[point-free]: https://www.pointfree.co
[mbrandonw]: https://github.com/mbrandonw
[stephencelis]: https://github.com/stephencelis
