// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "GourmetAI",
    platforms: [
        .iOS(.v16),
        .macOS(.v13)
    ],
    products: [
        .library(
            name: "GourmetAI",
            targets: ["GourmetAI"]
        ),
    ],
    dependencies: [],
    targets: [
        .target(
            name: "GourmetAI",
            dependencies: [],
            path: "Sources"
        )
    ]
)
