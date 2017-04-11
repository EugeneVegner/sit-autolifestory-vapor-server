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

//drop.middleware.append(ClientMiddleware())

drop.grouped(ClientMiddleware()).group("api") { api in
    
    api.group("v1", closure: { v1 in

        v1.group("auth", closure: { (authV1) in
            let auth = AuthController()
            authV1.get("signIn", handler: auth.signIn)
            authV1.get("signUp", handler: auth.signIn)
            authV1.get("fb", handler: auth.signIn)
            
        })
        
    })
    
    api.grouped(SessionMiddleware()).group("v1", closure: { v1 in
        
    })
    
}

//drop.grouped([ClientMiddleware(),ClientMiddleware()]).group("api/v1") { v1 in
//    
//    v1.group("auth", closure: { (authV1) in
//        
//        let auth = AuthController()
//        authV1.get("signIn", handler: auth.signIn)
//        authV1.get("signUp", handler: auth.signIn)
//        authV1.get("fb", handler: auth.signIn)
//        
//    })
//    
//    
//}




drop.group("api/v1") { v1 in
    
    
    
    v1.get("users") { request in
        throw Abort.custom(status: .badRequest, message: "Please POST the name firsteeee.")
    }
    
//    v1.group("auth", closure: { (authV1) in
//       
//        let auth = AuthController()
//        authV1.get("signIn", handler: auth.signIn)
//        authV1.get("signUp", handler: auth.signIn)
//        authV1.get("fb", handler: auth.signIn)
//        
//        
//        
//        
//        
//    })
    
    
    let ping = PingController()
    v1.get(handler: ping.test)

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
