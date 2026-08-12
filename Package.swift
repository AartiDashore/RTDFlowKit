// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "RTDFlowKit",
    platforms: [
        .iOS(.v16),
        .macOS(.v13)
    ],
    products: [
        .library(
            name: "RTDFlowKit",
            targets: ["RTDFlowKit"]
        ),
    ],
    targets: [
        .target(
            name: "RTDFlowKit",
            path: "Sources/RTDFlowKit"
        ),
        .testTarget(
            name: "RTDFlowKitTests",
            dependencies: ["RTDFlowKit"],
            path: "Tests/RTDFlowKitTests"
        ),
    ]
)
