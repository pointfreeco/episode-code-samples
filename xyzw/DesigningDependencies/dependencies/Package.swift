// swift-tools-version:5.5

import PackageDescription

let package = Package(
  name: "dependencies",
  platforms: [.iOS(.v15)],
  products: [
    .library(
      name: "ConcurrencyExtensions",
      targets: ["ConcurrencyExtensions"]
    ),
    .library(
      name: "LocationClient",
      targets: ["LocationClient"]
    ),
    .library(
      name: "LocationClientLive",
      targets: ["LocationClientLive"]
    ),
    .library(
      name: "PathMonitorClient",
      targets: ["PathMonitorClient"]
    ),
    .library(
      name: "PathMonitorClientLive",
      targets: ["PathMonitorClientLive"]
    ),
    .library(
      name: "WeatherClient",
      targets: ["WeatherClient"]
    ),
    .library(
      name: "WeatherClientLive",
      targets: ["WeatherClientLive"]
    ),
    .library(
      name: "WeatherFeature",
      targets: ["WeatherFeature"]
    ),
  ],
  dependencies: [
  ],
  targets: [
    .target(
      name: "ConcurrencyExtensions",
      dependencies: [],
      swiftSettings: [
        .unsafeFlags([
          "-Xfrontend", "-warn-concurrency",
          "-Xfrontend", "-enable-actor-data-race-checks",
        ]),
      ]
    ),
    .target(
      name: "LocationClient",
      dependencies: ["ConcurrencyExtensions"],
      swiftSettings: [
        .unsafeFlags([
          "-Xfrontend", "-warn-concurrency",
          "-Xfrontend", "-enable-actor-data-race-checks",
        ]),
      ]
    ),
    .target(
      name: "LocationClientLive",
      dependencies: ["LocationClient"],
      swiftSettings: [
        .unsafeFlags([
          "-Xfrontend", "-warn-concurrency",
          "-Xfrontend", "-enable-actor-data-race-checks",
        ]),
      ]
    ),
    .target(
      name: "PathMonitorClient",
      dependencies: ["ConcurrencyExtensions"],
      swiftSettings: [
        .unsafeFlags([
          "-Xfrontend", "-warn-concurrency",
          "-Xfrontend", "-enable-actor-data-race-checks",
        ]),
      ]
    ),
    .target(
      name: "PathMonitorClientLive",
      dependencies: ["PathMonitorClient"],
      swiftSettings: [
        .unsafeFlags([
          "-Xfrontend", "-warn-concurrency",
          "-Xfrontend", "-enable-actor-data-race-checks",
        ]),
      ]
    ),
    .target(
      name: "WeatherClient",
      dependencies: ["ConcurrencyExtensions"],
      swiftSettings: [
        .unsafeFlags([
          "-Xfrontend", "-warn-concurrency",
          "-Xfrontend", "-enable-actor-data-race-checks",
        ]),
      ]
    ),
    .target(
      name: "WeatherClientLive",
      dependencies: ["WeatherClient"],
      swiftSettings: [
        .unsafeFlags([
          "-Xfrontend", "-warn-concurrency",
          "-Xfrontend", "-enable-actor-data-race-checks",
        ]),
      ]
    ),
    .target(
      name: "WeatherFeature",
      dependencies: [
        "LocationClient",
        "PathMonitorClient",
        "WeatherClient"
      ],
      swiftSettings: [
        .unsafeFlags([
          "-Xfrontend", "-warn-concurrency",
          "-Xfrontend", "-enable-actor-data-race-checks",
        ]),
      ]
    ),
    .testTarget(
      name: "WeatherFeatureTests",
      dependencies: ["WeatherFeature"],
      swiftSettings: [
        .unsafeFlags([
          "-Xfrontend", "-warn-concurrency",
          "-Xfrontend", "-enable-actor-data-race-checks",
        ]),
      ]
    ),
  ]
)
