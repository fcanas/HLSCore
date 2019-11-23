// swift-tools-version:5.0
import PackageDescription

let package = Package(
    name: "HLSCore",
    platforms: [
    	.macOS(.v10_12),
        .iOS(.v10),
        .tvOS(.v10)
    ],
    products: [
        .library(name: "HLSCore", type:.static, targets: ["Types", "Serialization", "Parsing"])
    ],
    targets: [
        .target(name: "Types"),
        .testTarget(name: "TypesTests",
                    dependencies:["Types"]),
        .target(name: "Serialization",
               dependencies: ["Types"]),
        .testTarget(name: "SerializationTests",
                    dependencies:["Serialization"]),
        .target(name: "Parsing",
               dependencies: ["Types", "ParserCombinator"]),
        .testTarget(name: "ParsingTests",
                    dependencies:["Parsing"]),
        .target(name: "ParserCombinator"),
        .testTarget(name: "ParserCombinatorTests",
                    dependencies: ["ParserCombinator"])
    ],
    swiftLanguageVersions:[.v5]
)
