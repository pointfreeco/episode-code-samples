// swift-tools-version: 6.3

import PackageDescription

let package = Package(
  name: "StoreIsolation",
  platforms: [.iOS(.v26), .macOS(.v26)],
  products: [
    .library(
      name: "StoreIsolation",
      targets: ["StoreIsolation"]
    )
  ],
  targets: [
    .target(
      name: "StoreIsolation"
    ),
    .testTarget(
      name: "StoreIsolationTests",
      dependencies: ["StoreIsolation"]
    ),
  ],
  swiftLanguageModes: [.v6]
)
