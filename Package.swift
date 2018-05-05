// swift-tools-version:4.0
import PackageDescription

let package = Package(
    name: "HLSCore",
    products: [
        .library(
            name: "HLSCore",
            type: .dynamic,
            targets: [
                "Utilities",
                "Types",
                "Serialization",
                "Parsing"
            ]
        )
    ],
    dependencies: [
        .package(url: "https://github.com/fcanas/FFCParserCombinator.git", from: "0.0.6"),
        .package(url: "https://github.com/fcanas/FFCLog.git", .revision("2065d65b29b6c6e296c204c094597e325a905121")),
    ],
    targets: [
        .target(name: "Utilities",
               dependencies: []),
        .testTarget(name: "UtilitiesTests",
                    dependencies:["Utilities"]),
        .target(name: "Types",
               dependencies: ["Utilities"]),
        .testTarget(name: "TypesTests",
                    dependencies:["Types"]),
        .target(name: "Serialization",
               dependencies: ["Types"]),
        .testTarget(name: "SerializationTests",
                    dependencies:["Serialization"]),
        .target(name: "Parsing",
               dependencies: ["Types", "FFCParserCombinator", "FFCLog"]),
        .testTarget(name: "ParsingTests",
                    dependencies:["Parsing"]),
    ],
    swiftLanguageVersions: [4]


)
