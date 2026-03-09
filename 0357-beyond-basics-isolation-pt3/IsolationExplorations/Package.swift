// swift-tools-version: 6.2

import PackageDescription

let package = Package(
  name: "IsolationExplorations",
  platforms: [.macOS(.v26)],
  products: [
    .library(
      name: "IsolationExploration",
      targets: ["IsolationExploration"]
    )
  ],
  targets: [
    .target(
      name: "IsolationExploration"
    ),
    .testTarget(
      name: "IsolationExplorationsTests",
      dependencies: ["IsolationExploration"]
    ),
  ],
  swiftLanguageModes: [.v5]
)
