// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
  name: "string-performance",
  platforms: [.macOS(.v10_15)],
  dependencies: [
    // Dependencies declare other packages that this package depends on.
    // .package(url: /* package url */, from: "1.0.0"),
    .package(name: "Benchmark", url: "https://github.com/google/swift-benchmark", .branch("main"))
  ],
  targets: [
    // Targets are the basic building blocks of a package. A target can define a module or a test suite.
    // Targets can depend on other targets in this package, and on products in packages this package depends on.
    .target(
      name: "string-performance",
      dependencies: [.product(name: "Benchmark", package: "Benchmark")]),
    .testTarget(
      name: "string-performanceTests",
      dependencies: ["string-performance"]),
  ]
)
