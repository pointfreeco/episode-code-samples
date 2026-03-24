// swift-tools-version: 6.2

import PackageDescription

let package = Package(
  name: "IsolationExplorations",
  platforms: [.macOS(.v26)],
  products: [
    .library(
      name: "LegacyIsolation",
      targets: ["LegacyIsolation"]
    ),
    .library(
      name: "ActorIsolation",
      targets: ["ActorIsolation"]
    )
  ],
  targets: [
    .target(
      name: "LegacyIsolation"
    ),
    .target(
      name: "ActorIsolation"
    ),
    .testTarget(
      name: "IsolationExplorationsTests",
      dependencies: ["LegacyIsolation"]
    ),
    .testTarget(
      name: "ActorIsolationTests",
      dependencies: ["ActorIsolation"]
    ),
  ],
  swiftLanguageModes: [.v6]
)
