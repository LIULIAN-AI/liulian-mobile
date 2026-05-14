// swift-tools-version: 5.9
// LIULIAN UI library — SwiftUI components matching liulian-design-system ui-spec.

import PackageDescription

let package = Package(
    name: "LiulianUI",
    platforms: [
        .iOS(.v16),
        .macOS(.v13),  // for SwiftUI previews on Mac
    ],
    products: [
        .library(name: "LiulianUI", targets: ["LiulianUI"]),
    ],
    targets: [
        .target(
            name: "LiulianUI",
            path: "Sources/LiulianUI"
        ),
        .testTarget(
            name: "LiulianUITests",
            dependencies: ["LiulianUI"],
            path: "Tests/LiulianUITests"
        ),
    ]
)
