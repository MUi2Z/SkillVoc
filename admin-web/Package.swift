// swift-tools-version:5.9
import PackageDescription

let package = Package(
    name: "AdminWeb",
    platforms: [.macOS(.v11)],
    products: [
        .executable(name: "AdminWeb", targets: ["AdminWeb"])
    ],
    dependencies: [
        // Masukkan Tokamak untuk UI SwiftUI di Web
        .package(url: "https://github.com/TokamakDOM/Tokamak", from: "0.14.0"),
        // Masukkan Carton plugin secara rasmi di sini sebagai pengganti brew
        .package(url: "https://github.com/swiftwasm/carton.git", from: "1.0.0")
    ],
    targets: [
        .executableTarget(
            name: "AdminWeb",
            dependencies: [
                .product(name: "TokamakDOM", package: "Tokamak")
            ]
        )
    ]
)
