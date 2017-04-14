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
    //try drop.addProvider(VaporMongo.Provider.self)
    let mongo = try VaporMongo.Provider(database: "local", user: "admin", password: "qwerty", host: "localhost", port: 27017)
    drop.addProvider(mongo)
    print("MongoDB provider has been added")
}
catch {
    print("MongoDB provider error: \(error)")
}

//drop.preparations += [
//    Post.self,
//    User.self
//    //Pivot<Toy, Pet>.self
//]

drop.preparations.append(Post.self)
drop.preparations.append(User.self)
//drop.preparations.append(Site.self)

//drop.middleware.append(ClientMiddleware())

drop.resource("users", UsersController())

drop.grouped(ClientMiddleware()).group("api") { api in
    
    api.group("v1", closure: { v1 in

        v1.group("auth", closure: { (authV1) in
            let auth = AuthController()
            authV1.get("signIn", handler: auth.signIn)
            authV1.get("signUp", handler: auth.signIn)
            authV1.get("fb", handler: auth.signIn)
            
        })
        
        let ping = PingController()
        v1.get("ping", handler: ping.test)

        v1.grouped(SessionMiddleware()).group("users", closure: { (usersV1) in
            let users = UsersController()
            usersV1.post(handler: users.create)
            usersV1.get(handler: ping.test)

            
            
        })
        
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




//drop.group("api/v1") { v1 in
//    
//    
//    
//    v1.get("users") { request in
//        throw Abort.custom(status: .badRequest, message: "Please POST the name firsteeee.")
//    }
//    
////    v1.group("auth", closure: { (authV1) in
////       
////        let auth = AuthController()
////        authV1.get("signIn", handler: auth.signIn)
////        authV1.get("signUp", handler: auth.signIn)
////        authV1.get("fb", handler: auth.signIn)
////        
////        
////        
////        
////        
////    })
//    
//    
//    let ping = PingController()
//    v1.get(handler: ping.test)
//
//}



//drop.get { req in
//    
//    guard let name = try req.session().data["name"]?.string else {
//        throw Abort.custom(status: .badRequest, message: "Please POST the name first.")
//    }
//
//    return try drop.view.make("welcome", [
//        "message": drop.localization[req.lang, "welcome", "title"]
//        ])
//}

//drop.resource("posts", PostController())


//let mongo = try VaporMongo.Provider(database: "local", user: "admin", password: "qwerty")
//drop.addProvider(mongo)


drop.run()
