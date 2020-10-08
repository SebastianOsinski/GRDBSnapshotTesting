// swift-tools-version:5.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "GRDBSnapshotTesting",
    platforms: [
      .iOS(.v11),
      .macOS(.v10_10),
      .tvOS(.v10)
    ],
    products: [
        .library(
            name: "GRDBSnapshotTesting",
            targets: ["GRDBSnapshotTesting"]),
    ],
    dependencies: [
        .package(name: "GRDB", url: "https://github.com/groue/GRDB.swift.git", .upToNextMajor(from: "5.0.0")),
        .package(name: "SnapshotTesting", url: "https://github.com/pointfreeco/swift-snapshot-testing.git", .upToNextMajor(from: "1.8.1")),
    ],
    targets: [
        .target(
            name: "GRDBSnapshotTesting",
            dependencies: ["GRDB", "SnapshotTesting"],
            path: "GRDBSnapshotTesting/Sources")
    ]
)
