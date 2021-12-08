// swift-tools-version:5.5

import PackageDescription

let package = Package(
  name: "Inventory",
  platforms: [.iOS(.v15)],
  products: [
    .library(name: "AppFeature", targets: ["AppFeature"]),
    .library(name: "InventoryFeature", targets: ["InventoryFeature"]),
    .library(name: "ItemFeature", targets: ["ItemFeature"]),
    .library(name: "ItemRowFeature", targets: ["ItemRowFeature"]),
    .library(name: "Models", targets: ["Models"]),
    .library(name: "ParsingHelpers", targets: ["ParsingHelpers"]),
    .library(name: "SwiftUIHelpers", targets: ["SwiftUIHelpers"])
  ],
  dependencies: [
    .package(url: "https://github.com/pointfreeco/swift-case-paths", from: "0.7.0"),
    .package(url: "https://github.com/pointfreeco/swift-identified-collections", from: "0.3.2"),
    .package(url: "https://github.com/pointfreeco/swift-parsing", from: "0.3.1"),
  ],
  targets: [
    .target(
      name: "AppFeature",
      dependencies: [
        "InventoryFeature",
        "Models",
        "ParsingHelpers",
        .product(name: "Parsing", package: "swift-parsing"),
      ]
    ),
    .target(
      name: "InventoryFeature",
      dependencies: [
        "ItemRowFeature",
        "Models",
        "ParsingHelpers",
        "SwiftUIHelpers",
        .product(name: "CasePaths", package: "swift-case-paths"),
        .product(name: "Parsing", package: "swift-parsing"),
        .product(name: "IdentifiedCollections", package: "swift-identified-collections"),
      ]
    ),
    .target(
      name: "ItemFeature",
      dependencies: [
        "Models",
        "SwiftUIHelpers",
        .product(name: "CasePaths", package: "swift-case-paths"),
      ]
    ),
    .target(
      name: "ItemRowFeature",
      dependencies: [
        "ItemFeature",
        "Models",
        "ParsingHelpers",
        "SwiftUIHelpers",
        .product(name: "CasePaths", package: "swift-case-paths"),
        .product(name: "Parsing", package: "swift-parsing"),
      ]
    ),
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
