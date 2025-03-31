// swift-tools-version: 6.0

import PackageDescription

let package = Package(
  name: "QueryBuilder",
  platforms: [.macOS(.v14)],
  products: [
    .library(name: "QueryBuilder", targets: ["QueryBuilder"])
  ],
  dependencies: [
    .package(url: "https://github.com/pointfreeco/swift-snapshot-testing", from: "1.0.0")
  ],
  targets: [
    .target(name: "QueryBuilder"),
    .testTarget(
      name: "QueryBuilderTests",
      dependencies: [
        "QueryBuilder",
        .product(name: "InlineSnapshotTesting", package: "swift-snapshot-testing")
      ]
    ),
  ],
  swiftLanguageModes: [.v6]
)
