// swift-tools-version:5.3

import PackageDescription

let package = Package(
  name: "LocationClient",
  platforms: [.iOS(.v13)],
  products: [
    .library(
      name: "LocationClient",
      type: .dynamic,
      targets: ["LocationClient"]),
    .library(
      name: "LocationClientLive",
      type: .dynamic,
      targets: ["LocationClientLive"]),
  ],
  dependencies: [
  ],
  targets: [
    .target(
      name: "LocationClient",
      dependencies: []),
    .testTarget(
      name: "LocationClientTests",
      dependencies: ["LocationClient"]),
    .target(
      name: "LocationClientLive",
      dependencies: ["LocationClient"]),
  ]
)
