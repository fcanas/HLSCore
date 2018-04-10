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
        .package(url: "https://github.com/fcanas/FFCParserCombinator.git", from: "0.0.4")
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
               dependencies: ["Types", "FFCParserCombinator"]),
        .testTarget(name: "ParsingTests",
                    dependencies:["Parsing"]),
    ],
    swiftLanguageVersions: [4]


)
