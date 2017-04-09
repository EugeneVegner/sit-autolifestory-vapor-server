import Vapor
import VaporMongo

let drop = Droplet()

//let drop = Droplet(
//    arguments: nil,
//    workDir: nil,
//    environment: .development,
//    config: nil,
//    localization: nil,
//    log: nil)

//print("Server environment is \(drop.environment)")


//try drop.addProvider(VaporMongo.Provider.self)

do {
    try drop.addProvider(VaporMongo.Provider.self)

    //let mongo = try VaporMongo.Provider(database: "local", user: "admin1", password: "qwerty", host: "localhost", port: 27017)
    //drop.addProvider(mongo)
}
catch {
    print(error)
}


drop.group("api/v1") { v1 in
    v1.get("users") { request in
        throw Abort.custom(status: .badRequest, message: "Please POST the name firsteeee.")
    }
}



drop.get { req in
    
    guard let name = try req.session().data["name"]?.string else {
        throw Abort.custom(status: .badRequest, message: "Please POST the name first.")
    }

    return try drop.view.make("welcome", [
        "message": drop.localization[req.lang, "welcome", "title"]
        ])
}

drop.resource("posts", PostController())


//let mongo = try VaporMongo.Provider(database: "local", user: "admin", password: "qwerty")
//drop.addProvider(mongo)


drop.run()
