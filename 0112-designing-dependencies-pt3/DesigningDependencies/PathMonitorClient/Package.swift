// swift-tools-version:5.3

import PackageDescription

let package = Package(
  name: "PathMonitorClient",
  platforms: [.iOS(.v13)],
  products: [
    .library(
      name: "PathMonitorClient",
      type: .dynamic,
      targets: ["PathMonitorClient"]),
    .library(
      name: "PathMonitorClientLive",
      type: .dynamic,
      targets: ["PathMonitorClientLive"]),
  ],
  dependencies: [
  ],
  targets: [
    .target(
      name: "PathMonitorClient",
      dependencies: []),
    .testTarget(
      name: "PathMonitorClientTests",
      dependencies: ["PathMonitorClient"]),
    .target(
      name: "PathMonitorClientLive",
      dependencies: ["PathMonitorClient"]),
  ]
)
