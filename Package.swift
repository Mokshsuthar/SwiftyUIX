// swift-tools-version:5.7
import PackageDescription

let package = Package(
    name: "SwiftyUIX",
    platforms: [
        .iOS(.v13),
        .macOS(.v12)
    ],
    products: [
        .library(
            name: "SwiftyUIX",
            targets: ["SwiftyUIX"]
        ),
    ],
    targets: [
        .target(
            name: "SwiftyUIX",
            path: "SwiftyUIX",
            sources: ["Classes"]
        )
    ]
)
