// swift-tools-version: 5.9
// LIULIAN UI library — SwiftUI components matching liulian-design-system ui-spec.

import PackageDescription

let package = Package(
    name: "LiulianUI",
    platforms: [
        .iOS(.v16),
        .macOS(.v13),  // for SwiftUI previews on Mac + snapshot tests in CI
    ],
    products: [
        .library(name: "LiulianUI", targets: ["LiulianUI"]),
    ],
    dependencies: [
        // Snapshot tests — runs in GitHub Actions on macos-26 (free for public repos).
        // See .github/workflows/ios-snapshots.yml at liulian-mobile root.
        .package(url: "https://github.com/pointfreeco/swift-snapshot-testing", from: "1.18.0"),
    ],
    targets: [
        .target(
            name: "LiulianUI",
            path: "Sources/LiulianUI"
        ),
        .testTarget(
            name: "LiulianUITests",
            dependencies: [
                "LiulianUI",
                .product(name: "SnapshotTesting", package: "swift-snapshot-testing"),
            ],
            path: "Tests/LiulianUITests"
        ),
    ]
)
