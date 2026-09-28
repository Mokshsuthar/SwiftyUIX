// swift-tools-version:5.9
import PackageDescription

let package = Package(
    name: "SwiftyUIX",
    platforms: [
        .iOS(.v17),
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
