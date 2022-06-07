// swift-tools-version: 5.6
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
  name: "concurrency",
  platforms: [.macOS(.v12)],
  dependencies: [
  ],
  targets: [
    .executableTarget(
      name: "concurrency",
      dependencies: [],
      swiftSettings: [
        .unsafeFlags([
          "-Xfrontend", "-warn-concurrency",
        ]),
      ]
    ),
    .testTarget(
      name: "concurrencyTests",
      dependencies: ["concurrency"]),
  ]
)
