// swift-tools-version:6.0
import PackageDescription

let package = Package(
    name: "abhishek_rest_api",
    platforms: [
        .macOS(.v13),
        .iOS(.v13),
    ],
    dependencies: [
        // 💧 A server-side Swift web framework.
        .package(url: "https://github.com/vapor/vapor.git", from: "4.115.0"),
        // 🔵 Non-blocking, event-driven networking for Swift. Used for custom executors
        .package(url: "https://github.com/apple/swift-nio.git", from: "2.65.0"),
        
        // fluent for database
        .package(url: "https://github.com/vapor/fluent.git", from: "4.0.0"),
        .package(url: "https://github.com/vapor/fluent-mysql-driver.git", from: "4.0.0"),
        .package(url: "https://github.com/dankinsoid/VaporToOpenAPI.git", from: "4.8.1"),
        .package(url: "https://github.com/apple/swift-nio-ssl.git", from: "2.26.0"),
    ],
    targets: [
        .executableTarget(
            name: "abhishek_rest_api",
            dependencies: [
                .product(name: "Vapor", package: "vapor"),
                .product(name: "NIOCore", package: "swift-nio"),
                .product(name: "NIOPosix", package: "swift-nio"),
                .product(name: "Fluent", package: "fluent"),
                .product(name: "FluentMySQLDriver", package: "fluent-mysql-driver"),
                .product(name: "VaporToOpenAPI", package: "VaporToOpenAPI"),
                .product(name: "NIOSSL", package: "swift-nio-ssl")
            ],
            swiftSettings: swiftSettings
        )
    ]
)

var swiftSettings: [SwiftSetting] {
    [
        .enableUpcomingFeature("ExistentialAny")
    ]
}
