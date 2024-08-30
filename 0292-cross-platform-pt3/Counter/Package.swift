// swift-tools-version: 6.0

import PackageDescription

let package = Package(
  name: "Counter",
  platforms: [.iOS(.v16), .macOS(.v14)],
  products: [
    .library(
      name: "Counter",
      targets: ["Counter"]
    ),
    .library(
      name: "FactClient",
      targets: ["FactClient"]
    ),
  ],
  dependencies: [
    .package(url: "https://github.com/pointfreeco/swift-dependencies", from: "1.0.0"),
    .package(url: "https://github.com/pointfreeco/swift-navigation", from: "2.0.0"),
    .package(url: "https://github.com/pointfreeco/swift-perception", from: "1.0.0"),
    .package(url: "https://github.com/swiftwasm/carton", from: "1.0.0"),
    .package(url: "https://github.com/swiftwasm/JavaScriptKit", exact: "0.19.2"),
  ],
  targets: [
    .executableTarget(
      name: "WasmApp",
      dependencies: [
        "Counter",
        "FactClientLive",
        .product(name: "SwiftNavigation", package: "swift-navigation"),
        .product(name: "JavaScriptEventLoop", package: "JavaScriptKit"),
        .product(name: "JavaScriptKit", package: "JavaScriptKit"),
      ]
    ),
    .target(
      name: "Counter",
      dependencies: [
        "FactClient",
        .product(name: "SwiftNavigation", package: "swift-navigation"),
        .product(name: "Perception", package: "swift-perception")
      ]
    ),
    .target(
      name: "FactClient",
      dependencies: [
        .product(name: "Dependencies", package: "swift-dependencies"),
        .product(name: "DependenciesMacros", package: "swift-dependencies"),
      ]
    ),
    .target(
      name: "FactClientLive",
      dependencies: [
        "FactClient",
        .product(name: "JavaScriptKit", package: "JavaScriptKit", condition: .when(platforms: [.wasi])),
        .product(name: "JavaScriptEventLoop", package: "JavaScriptKit", condition: .when(platforms: [.wasi])),
      ]
    )
  ],
  swiftLanguageVersions: [.v6]
)
