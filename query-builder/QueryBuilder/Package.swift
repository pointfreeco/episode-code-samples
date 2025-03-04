// swift-tools-version: 6.0

import PackageDescription

let package = Package(
  name: "QueryBuilder",
  platforms: [.macOS(.v14)],
  products: [
    .library(name: "QueryBuilder", targets: ["QueryBuilder"])
  ],
  targets: [
    .target(name: "QueryBuilder"),
    .testTarget(name: "QueryBuilderTests", dependencies: ["QueryBuilder"]),
  ],
  swiftLanguageModes: [.v6]
)
