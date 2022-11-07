// swift-tools-version:5.7

import PackageDescription

let package = Package(
  name: "Inventory",
  platforms: [.iOS(.v16)],
  products: [
    .library(name: "AppFeature", targets: ["AppFeature"]),
    .library(name: "InventoryFeature", targets: ["InventoryFeature"]),
    .library(name: "ItemFeature", targets: ["ItemFeature"]),
    .library(name: "ItemRowFeature", targets: ["ItemRowFeature"]),
    .library(name: "Models", targets: ["Models"]),
  ],
  dependencies: [
    .package(url: "https://github.com/pointfreeco/swift-case-paths", from: "0.9.2"),
    .package(url: "https://github.com/pointfreeco/swift-identified-collections", from: "0.4.1"),
    .package(url: "https://github.com/pointfreeco/swift-parsing", from: "0.10.0"),
    .package(url: "https://github.com/pointfreeco/swift-url-routing", from: "0.3.1"),
    .package(url: "https://github.com/pointfreeco/swiftui-navigation", from: "0.3.0"),
    .package(url: "https://github.com/pointfreeco/xctest-dynamic-overlay", from: "0.4.1"),
  ],
  targets: [
    .target(
      name: "AppFeature",
      dependencies: [
        "InventoryFeature",
        "Models",
        .product(name: "Parsing", package: "swift-parsing"),
      ]
    ),
    .target(
      name: "InventoryFeature",
      dependencies: [
        "ItemRowFeature",
        "Models",
        .product(name: "CasePaths", package: "swift-case-paths"),
        .product(name: "Parsing", package: "swift-parsing"),
        .product(name: "IdentifiedCollections", package: "swift-identified-collections"),
        .product(name: "SwiftUINavigation", package: "swiftui-navigation"),
      ]
    ),
    .testTarget(
      name: "InventoryFeatureTests",
      dependencies: ["InventoryFeature"]
    ),
    .target(
      name: "ItemFeature",
      dependencies: [
        "Models",
        .product(name: "CasePaths", package: "swift-case-paths"),
        .product(name: "SwiftUINavigation", package: "swiftui-navigation"),
      ]
    ),
    .testTarget(
      name: "ItemFeatureTests",
      dependencies: ["ItemFeature"]
    ),
    .target(
      name: "ItemRowFeature",
      dependencies: [
        "ItemFeature",
        "Models",
        .product(name: "CasePaths", package: "swift-case-paths"),
        .product(name: "Parsing", package: "swift-parsing"),
        .product(name: "URLRouting", package: "swift-url-routing"),
        .product(name: "SwiftUINavigation", package: "swiftui-navigation"),
        .product(name: "XCTestDynamicOverlay", package: "xctest-dynamic-overlay"),
      ]
    ),
    .testTarget(
      name: "ItemRowFeatureTests",
      dependencies: ["ItemRowFeature"]
    ),
    .target(name: "Models"),
  ]
)
