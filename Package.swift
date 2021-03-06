import PackageDescription

let package = Package(
    name: "Server",
    dependencies: [
        .Package(url: "https://github.com/vapor/vapor.git", majorVersion: 1, minor: 5),
        .Package(url: "https://github.com/vapor/mongo-provider.git", majorVersion: 1, minor: 1),
        //.Package(url: "https://github.com/Danappelxx/SwiftMongoDB", majorVersion: 0, minor: 5)
    ],
    exclude: [
        "Config",
        "Database",
        "Localization",
        "Public",
        "Resources",
        //"Tests",
    ]

)

/*
 http://swiftontheside.com/tag/vapor/
 https://medium.com/@joannis.orlandos/using-mongokitten-vapor-for-your-applications-24dbac2f5dd9
 
 
 Examples
 curl -H "Content-Type: application/json" -X POST -d '{}' http://0.0.0.0:8080/api/cars

 curl -H "Content-Type: application/json" -X POST -d '{"name":"Fiat"}' http://0.0.0.0:8080/api/cars

 
 */
