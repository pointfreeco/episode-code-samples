// swift-tools-version:5.5

import PackageDescription

let package = Package(
  name: "Inventory",
  platforms: [.iOS(.v15)],
  products: [
    .library(name: "Models", targets: ["Models"]),
    .library(name: "ParsingHelpers", targets: ["ParsingHelpers"]),
    .library(name: "SwiftUIHelpers", targets: ["SwiftUIHelpers"])
  ],
  dependencies: [
    .package(url: "https://github.com/pointfreeco/swift-case-paths", from: "0.7.0"),
    .package(url: "https://github.com/pointfreeco/swift-parsing", from: "0.3.1"),
  ],
  targets: [
    .target(name: "Models"),
    .target(
      name: "ParsingHelpers",
      dependencies: [
        .product(name: "Parsing", package: "swift-parsing")
      ]
    ),
    .target(
      name: "SwiftUIHelpers",
      dependencies: [
        .product(name: "CasePaths", package: "swift-case-paths")
      ]
    ),
  ]
)
