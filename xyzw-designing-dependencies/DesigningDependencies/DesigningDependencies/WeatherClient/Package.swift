// swift-tools-version:5.2

import PackageDescription

let package = Package(
  name: "WeatherClient",
  platforms: [.iOS(.v13)],
  products: [
    .library(
      name: "WeatherClient",
      targets: ["WeatherClient"]),
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
  ]
)
