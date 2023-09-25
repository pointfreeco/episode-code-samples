// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription
import CompilerPluginSupport

let package = Package(
    name: "MacroKit",
    platforms: [.macOS(.v10_15), .iOS(.v13)],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "MacroKit",
            targets: ["MacroKit"]
        ),
        .executable(
            name: "MacroKitClient",
            targets: ["MacroKitClient"]
        ),
    ],
    dependencies: [
        // Depend on the latest Swift 5.9 prerelease of SwiftSyntax
      //  "509.0.0-swift-DEVELOPMENT-SNAPSHOT-2023-08-07-a"
      .package(
        url: "https://github.com/apple/swift-syntax.git",
        from: "509.0.0-swift-DEVELOPMENT-SNAPSHOT-2023-08-07-a"
      ),
      .package(url: "https://github.com/pointfreeco/swift-macro-testing", from: "0.1.0")
    ],
    targets: [
        // Macro implementation that performs the source transformation of a macro.
        .macro(
            name: "MacroKitMacros",
            dependencies: [
                .product(name: "SwiftSyntaxMacros", package: "swift-syntax"),
                .product(name: "SwiftCompilerPlugin", package: "swift-syntax")
            ]
        ),

        // Library that exposes a macro as part of its API, which is used in client programs.
        .target(name: "MacroKit", dependencies: ["MacroKitMacros"]),

        // A client of the library, which is able to use the macro in its own code.
        .executableTarget(name: "MacroKitClient", dependencies: ["MacroKit"]),

        // A test target used to develop the macro implementation.
        .testTarget(
            name: "MacroKitTests",
            dependencies: [
                "MacroKitMacros",
                .product(name: "MacroTesting", package: "swift-macro-testing"),
                .product(name: "SwiftSyntaxMacrosTestSupport", package: "swift-syntax"),
            ]
        ),
    ]
)
