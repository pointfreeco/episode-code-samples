## [Point-Free](https://www.pointfree.co)

> #### This directory contains code from Point-Free Episode: [Swift Syntax Command Line Tool](https://www.pointfree.co/episodes/ep55-swift-syntax-command-line-tool)
>
> Today we finally extract our enum property code generator to a Swift Package Manager library and CLI tool. We’ll also do some next-level snapshot testing: not only will we snapshot-test our generated code, but we’ll leverage the Swift compiler to verify that our snapshot builds.

### Getting Started

* Clone repo
* `cd` into `EnumProperties`
* run `swift package generate-xcodeproj` and explore the project file
* run `swift run generate-enum-properties` against Swift source code
* run `swift test` to test the library
