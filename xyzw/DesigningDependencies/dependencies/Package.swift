// swift-tools-version:5.5

import PackageDescription

let package = Package(
  name: "dependencies",
  platforms: [.iOS(.v13)],
  products: [
    .library(
      name: "ConcurrencyExtensions",
      targets: ["ConcurrencyExtensions"]),
    .library(
      name: "LocationClient",
      targets: ["LocationClient"]),
    .library(
      name: "LocationClientLive",
      targets: ["LocationClientLive"]),
    .library(
      name: "PathMonitorClient",
      targets: ["PathMonitorClient"]),
    .library(
      name: "PathMonitorClientLive",
      targets: ["PathMonitorClientLive"]),
    .library(
      name: "WeatherClient",
      targets: ["WeatherClient"]),
    .library(
      name: "WeatherClientLive",
      targets: ["WeatherClientLive"]),
    .library(
      name: "WeatherFeature",
      targets: ["WeatherFeature"]),
  ],
  dependencies: [
  ],
  targets: [
    .target(
      name: "ConcurrencyExtensions",
      dependencies: []),
    .target(
      name: "LocationClient",
      dependencies: ["ConcurrencyExtensions"]),
    .target(
      name: "LocationClientLive",
      dependencies: ["LocationClient"]),
    .target(
      name: "PathMonitorClient",
      dependencies: ["ConcurrencyExtensions"]),
    .target(
      name: "PathMonitorClientLive",
      dependencies: ["PathMonitorClient"]),
    .target(
      name: "WeatherClient",
      dependencies: ["ConcurrencyExtensions"]),
    .target(
      name: "WeatherClientLive",
      dependencies: ["WeatherClient"]),
    .target(
      name: "WeatherFeature",
      dependencies: [
        "LocationClient",
        "PathMonitorClient",
        "WeatherClient"
      ]),
    .testTarget(
      name: "WeatherFeatureTests",
      dependencies: ["WeatherFeature"]),
  ]
)
