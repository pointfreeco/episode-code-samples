// swift-tools-version: 5.9

import PackageDescription

let package = Package(
  name: "swift-macro-testing",
  platforms: [
    .iOS(.v13),
    .macOS(.v10_15),
    .tvOS(.v13),
    .watchOS(.v6),
  ],
  products: [
    .library(
      name: "MacroTesting",
      targets: ["MacroTesting"]
    ),
  ],
  dependencies: [
    .package(
      url: "https://github.com/apple/swift-syntax.git",
      from: "509.0.0-swift-DEVELOPMENT-SNAPSHOT-2023-08-28-a"
    ),
    .package(url: "https://github.com/pointfreeco/swift-snapshot-testing", from: "1.12.0"),
    .package(url: "https://github.com/pointfreeco/swift-inline-snapshot-testing", from: "0.1.0"),
  ],
  targets: [
    .target(
      name: "MacroTesting",
      dependencies: [
        .product(name: "InlineSnapshotTesting", package: "swift-inline-snapshot-testing"),
        .product(name: "SnapshotTesting", package: "swift-snapshot-testing"),
        .product(name: "SwiftDiagnostics", package: "swift-syntax"),
        .product(name: "SwiftParserDiagnostics", package: "swift-syntax"),
        .product(name: "SwiftSyntaxMacros", package: "swift-syntax"),
        .product(name: "SwiftSyntaxMacrosTestSupport", package: "swift-syntax"),
      ]
    ),
    .testTarget(
      name: "MacroTestingTests",
      dependencies: [
        "MacroTesting",
        .product(name: "SwiftOperators", package: "swift-syntax"),
      ]
    ),
  ]
)
