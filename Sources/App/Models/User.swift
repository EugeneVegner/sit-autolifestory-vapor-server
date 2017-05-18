import Vapor
import HTTP
import Fluent
import Foundation
import BSON
import MongoKitten

final class User: MongoEntity {
    //var id: Node?
    var username: String
    var firstName: String
    var lastName: String
    var email: String
    var password: String?
    var fid: Int64?
    var provider: ProviderType
    var country: String
    
    required public init(request: Request) throws {
        fatalError("init(request:) has not been implemented")
    }

    //let title = Valid(Count<String>.max(5))
    
//    public required init(from: String) {
//        self.id = nil
//        fatalError("init(from:) has not been implemented")
//    }
    
//    init?(email: String, username: String, password: String) {
//        //super.init(email)
//        self.id = nil
//        do {
//            self.username = try username.validated()
//            self.email = try email.validated()
//            self.password = try password.validated()
//        } catch  {
//            print(error)
//            return nil
//        }
//    }

//    init?(username: String, email: String, password: String) {
//
//        self.id = UUID().uuidString.makeNode()
//        do {
//            self.username = try username.validated()
//            self.email = try email.validated()
//            self.password = try password.validated()
//        } catch  {
//            print(error)
//            return nil
//        }
//    }
    
    init(username: String, email: String, password: String?, firstName: String, lastName: String, fid: Int64? = nil, provider: ProviderType, country: String ) {
        self.username = username
        self.email = email
        self.password = password
        self.firstName = firstName
        self.lastName = lastName
        self.fid = fid
        self.provider = provider
        self.country = country
        super.init(uuid: nil)
    }

    
    required init(node: Node, in context: Context) throws {
        //print(#function)
        //print("context: \(context)")
        //print("node: \(node)")
        
//        self.username = node["username"]!.string!.validated()//.validated()
//        self.email = try node.extract("email").string.validated()
//        self.password = try node.extract("password").string.validated()
//        try super.init(node: node, in: context)
        do {
            self.username = try node.extract("username")
            self.email = try node.extract("email")
            self.password = try node.extract("password")
            self.firstName = try node.extract("firstName")
            self.lastName = try node.extract("lastName")
            self.fid = try node.extract("fid")
            self.provider = ConnectionProvider(rawValue: try node.extract("provider")) ?? .unknown
            self.country = try node.extract("country")
            
            try super.init(node: node, in: context)
//            self.id = try node.extract("_id")
//            let ddd = self.id?.string ?? "none"
//            
//            print("_id: \(ddd)")
//            
//            self.created = try node.extract("created")
//            self.updated = try node.extract("updated")

        } catch  {
            print(error)
            throw Abort.badRequest
        }
    }
    
    public required init(request: Request, provider: ProviderType, data: Data? = nil) throws {
        print(#function)
        self.provider = provider
        
        switch provider {
        case .email:
            let username: Valid<Username> = try request.data["username"].validated()
            let email: Valid<Email> = try request.data["email"].validated()
            let password: Valid<Password> = try request.data["password"].validated()
            let country: Valid<Country> = try request.data["country"].validated()
            
            self.username = username.value
            self.email = email.value
            self.password = password.value
            self.country = country.value
            
            self.firstName = ""
            self.lastName = ""
            
            break
            
        case .fb:
            
            self.password = nil
            if let p = params {
                let username: Valid<Username> = try p["name"].validated()
                let firstName: Valid<Username> = try p["first_name"].validated()
                let lastName: Valid<Username> = try p["last_name"].validated()
                let email: Valid<Username> = try p["email"].validated()
                let id: Valid<Username> = try p["id"].validated()
                
                
                self.firstName
            
            
            
            }
            
            
            break

        }
        
        
        try super.init(request: request)
    }
    

////    init(request: Request) throws {
////        print(#function)
////        //id = try request["id"]
//        username = try request.data["username"].validated()//   extract("username").string.validated()
//        email = try request.data["email"].validated()
//        password = try request.data["password"].validated()
////    }
    
    override func makeNode(context: Context) throws -> Node {
        var node = try super.makeNode(context: context)
        
        //let drop = Droplet()
        node.append(node: try Node(node: [
            "username": username,
            "email": email,
            "password": password//drop.hash(password),
            ]))
        return node
    }
    
    override func json() throws -> Node {
        var node = try super.json()
        node.append(node: try Node(node: [
            "username": username,
            "email": email,
            ]))
//        node["email"] = email.node
//        node["keyId"] = keyId.node
        return node
    }
    
}



//extension User {
//    /**
//     This will automatically fetch from database, using example here to load
//     automatically for example. Remove on real models.
//     */
//    public convenience init?(email: String, username: String, password: String) {
//        self.init(email)
//    }
//    
//}

//extension User: Preparation {
//    static func prepare(_ database: Database) throws {
//        
//        try database.create("users") { users in
//            users.id()
//            users.string("name", unique: true)
//            users.custom("data", type: "JSON")
//            users.custom("time", type: "TIMESTAMP", default: 1234)
//        }
//
//    }
//    
//    static func revert(_ database: Database) throws {
//        //
//    }
//}


// MARK: - Database requests

extension User {
    
    
    static func getByFacebookId(fid: Int64) throws -> User? {
        let filter = Filter(self, .compare("fid", .equals, try fid.makeNode()))
        let query = try User.query()
        query.filters = [filter]
        return try query.limit(1).run().first
    }

//    static func getById(fid: Int64) throws -> User? {
//        let filter = Filter(self, .compare("fid", .equals, try fid.makeNode()))
//        let query = try User.query()
//        query.filters = [filter]
//        return try query.limit(1).run().first
//    }










}

// MARK: - Custom validators

class Username: ValidationSuite {
    static func validate(input value: String) throws {
        print(#function)
        let evaluation = OnlyAlphanumeric.self
            && Count.min(2)
            && Count.max(20)
        try evaluation.validate(input: value)
    }
}

class Password: ValidationSuite {
    static func validate(input value: String) throws {
        print(#function)
        let evaluation = OnlyAlphanumeric.self
            && Count.min(4)
            && Count.max(16)
        try evaluation.validate(input: value)
    }
}

class Country: ValidationSuite {
    static func validate(input value: String) throws {
        print(#function)
        let evaluation = OnlyAlphanumeric.self
            && Count.min(2)
            && Count.max(4)
        try evaluation.validate(input: value)
    }
}


//class PasswordValidation: ValidationSuite {
//    
//    static func validate(input value: String) throws {
//        // 1 upper 1 lower 1 special 1 number at least 8 long
//        let regex =  Matches("^(?=.*[A-Z])(?=.*[a-z])(?=.*[!@#$&*])(?=.*[0-9]).{8}$")
//        
//        /*
//         let evaluation = Matches.validate(regex)
//         try evaluation.validate(input: value)
//         */
//        
//        let evaluation = OnlyAlphanumeric.self
//            && Count.min(8)
//            && Matches.validate(Matches<regex & value>)
//        
//        try evaluation.validate(input: value)
//    }
//    
//}


