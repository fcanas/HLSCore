import PackageDescription

let package = Package(
    name: "HLSCore",
    
    targets: [
        Target(name: "Utilities",
               dependencies: []),
        Target(name: "Types",
               dependencies: ["Utilities"]),
        Target(name: "Serialization",
               dependencies: ["Types"]),
        Target(name: "Parsing",
               dependencies: ["Types"]),
        Target(name: "Strip",
               dependencies: ["Utilities"])
    ]
)
