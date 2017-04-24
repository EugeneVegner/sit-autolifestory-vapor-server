import Vapor
import HTTP
import Fluent
import Foundation
import BSON

final class User: MongoEntity {
    //var id: Node?
    var username: String
    var email: String
    var password: String
    
    
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
    
    public required init(request: Request) throws {
        print(#function)
        let username: Valid<Username> = try request.data["username"].validated()
        let email: Valid<Email> = try request.data["email"].validated()
        let password: Valid<Password> = try request.data["password"].validated()
        
        self.username = username.value
        self.email = email.value
        self.password = password.value
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
        node["username"] = username.node
        node["email"] = email.node
        node["password"] = password.node

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


