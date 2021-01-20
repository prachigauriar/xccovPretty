// swift-tools-version:5.2
import PackageDescription


let package = Package(
    name: "xccovPretty",
    platforms: [
        .macOS(.v10_13)
    ],
    products: [
        .executable(name: "xccovPretty", targets: ["xccovPretty"])
    ],
    targets: [
        .target(name: "xccovPretty")
    ]
)
