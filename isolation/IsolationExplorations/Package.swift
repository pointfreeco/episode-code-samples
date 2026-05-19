// swift-tools-version: 6.2

import PackageDescription

let package = Package(
  name: "IsolationExplorations",
  platforms: [.macOS(.v26)],
  products: [
    .library(
      name: "MyApp",
      targets: ["MyApp"]
    ),
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
      name: "MyApp",
      swiftSettings: [
        .defaultIsolation(MainActor.self),
        .enableUpcomingFeature("NonisolatedNonsendingByDefault"),
        .enableUpcomingFeature("InferIsolatedConformances"),
      ]
    ),
    .target(
      name: "LegacyIsolation"
    ),
    .target(
      name: "ActorIsolation",
      swiftSettings: [
        //.enableUpcomingFeature("NonisolatedNonsendingByDefault")
        .enableUpcomingFeature("InferIsolatedConformances")
      ]
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
