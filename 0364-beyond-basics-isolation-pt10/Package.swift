// swift-tools-version: 6.3

import PackageDescription

let package = Package(
    name: "Cache",
    platforms: [.macOS(.v26)],
    products: [
        .library(
            name: "Cache",
            targets: ["Cache"]
        ),
    ],
    dependencies: [
        .package(
            url: "https://github.com/ordo-one/package-benchmark",
            .upToNextMajor(from: "1.4.0"),
            traits: []
        ),
    ],
    targets: [
        .target(
            name: "Cache"
        ),
        .executableTarget(
            name: "CacheBenchmarks",
            dependencies: [
                "Cache",
                .product(name: "Benchmark", package: "package-benchmark"),
            ],
            path: "Benchmarks/CacheBenchmarks",
            plugins: [
                .plugin(name: "BenchmarkPlugin", package: "package-benchmark")
            ]
        ),
    ],
    swiftLanguageModes: [.v6]
)
