// swift-tools-version:5.5
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "PillboxView",
    platforms: [
        .iOS(.v13),
        .macCatalyst(.v13),
        .tvOS(.v13),
        .macOS(.v11)
    ],
    products: [
        // Products define the executables and libraries a package produces, and make them visible to other packages.
        .library(
            name: "PillboxView",
            targets: ["PillboxView"]),
    ],
    dependencies: [
        // Add NSUI to support macOS compatibility
        .package(url: "https://github.com/mattmassicotte/nsui", branch: "main"),
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages this package depends on.
        .target(
            name: "PillboxView",
            dependencies: [
                .product(name: "NSUI", package: "nsui")
            ],
            path: "Sources"),
        .testTarget(
            name: "PillboxViewTests",
            dependencies: ["PillboxView"]),
    ]
)
