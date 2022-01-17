// swift-tools-version:5.2

import PackageDescription

let package = Package(
  name: "swift-parsing",
  products: [
    .library(
      name: "Parsing",
      targets: ["Parsing"]
    )
  ],
  dependencies: [
    .package(name: "Benchmark", url: "https://github.com/google/swift-benchmark", from: "0.1.1")
  ],
  targets: [
    .target(
      name: "Parsing"
    ),
    .target(
      name: "swift-parsing-benchmark",
      dependencies: [
        "Parsing",
        .product(name: "Benchmark", package: "Benchmark"),
      ]
    ),
  ]
)
