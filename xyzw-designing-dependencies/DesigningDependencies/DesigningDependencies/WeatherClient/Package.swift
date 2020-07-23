// swift-tools-version:5.2

import PackageDescription

let package = Package(
  name: "WeatherClient",
  platforms: [.iOS(.v13)],
  products: [
  .library(
    name: "WeatherClient",
    type: .dynamic,
    targets: ["WeatherClient"]),
    .library(
      name: "WeatherClientLive",
      type: .dynamic,
      targets: ["WeatherClientLive"]),
  ],
  dependencies: [
  ],
  targets: [
    .target(
      name: "WeatherClient",
      dependencies: []),
    .testTarget(
      name: "WeatherClientTests",
      dependencies: ["WeatherClient"]),

    .target(
      name: "WeatherClientLive",
      dependencies: ["WeatherClient"]),
  ]
)
