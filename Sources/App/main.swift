import Vapor
import VaporMongo

let drop = Droplet()

drop.get { req in
    return try drop.view.make("welcome", [
    	"message": drop.localization[req.lang, "welcome", "title"]
    ])
}

drop.resource("posts", PostController())

//let mongo = try VaporMongo.Provider(database: "alsmongo", user: "admin", password: "admin")
//drop.addProvider(mongo)


drop.run()
