// swift-tools-version:5.7

import PackageDescription

let package = Package(
    name: "BasicBlog",
    platforms: [.macOS(.v12)],
    products: [
        .executable(name: "BasicBlog", targets: ["BasicBlog"])
    ],
    dependencies: [
        .package(url: "https://github.com/johnsundell/publish.git", from: "0.9.0"),
        .package(url: "https://github.com/johnsundell/plot.git", from: "0.11.0"),
        .package(url: "https://github.com/tgymnich/PygmentsPublishPlugin.git", from: "0.1.0"),
        .package(url: "https://github.com/tgymnich/FaviconPublishPlugin.git", from: "0.1.0")
    ],
    targets: [
        .executableTarget(
            name: "BasicBlog",
            dependencies: [
                .product(name: "Publish", package: "publish"),
                .product(name: "PygmentsPublishPlugin", package: "PygmentsPublishPlugin"),
                .product(name: "FaviconPublishPlugin", package: "FaviconPublishPlugin"),
                .product(name: "Plot", package: "Plot")
            ]
        )
    ]
)
