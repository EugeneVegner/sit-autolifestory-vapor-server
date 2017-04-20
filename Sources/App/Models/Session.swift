//
//  Session.swift
//  Server
//
//  Created by Eugene Vegner on 18.04.17.
//
//

import Vapor
import HTTP
import Fluent
import Foundation

final class Session: IdEntity {
    //var id: Node?
    var userId: Node?
    var token: String
    var expired: Double
    
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
        self.userId = try node.extract("userId")
        self.token = try node.extract("token")
        self.expired = try node.extract("expired")
        try super.init(node: node, in: context)
        //        do {
        //            print("Step 1: \(node)")
        //            id = try node.extract("_id")
        //            username = try node.extract("username").string.validated()//   extract("username").string.validated()
        //            email = try node.extract("email").string.validated()
        //            password = try node.extract("password").string.validated()
        //            print("Step 2")
        //        } catch  {
        //            print(error)
        //            throw Abort.badRequest
        //        }
    }
    
//    public required init(request: Request) throws {
//        
//        
//        
//        
//        
//        self.userId = try request.data["userId"]?.string ?? Node.null
//        //self.email = try request.data["email"].validated()
//        //self.password = try request.data["password"].validated()
//        //try super.init(request: request)
//    }
    
    public required init(from: String) {
        fatalError("init(from:) has not been implemented")
    }
    
    public required init(request: Request) throws {
        fatalError("init(request:) has not been implemented")
    }
    
    init() throws {
        self.token = ""
        self.expired = 0
        super.init(from: "")
    }
    
    ////    init(request: Request) throws {
    ////        print(#function)
    ////        //id = try request["id"]
    //        username = try request.data["username"].validated()//   extract("username").string.validated()
    //        email = try request.data["email"].validated()
    //        password = try request.data["password"].validated()
    ////    }
    
    
    override func makeNode(context: Context) throws -> Node {
        return try Node(node: [
            "_id": id,
            "userId": userId,
            "token": token,
            "expired": expired,
            "created": created,
            "updated": updated ?? Node.null
            ])
    }
    
    func makeJSON() throws -> JSON {
        
        var r: [String: Node] = [:]
        r["id"] = id ?? Node.null
        r["userId"] = userId
        r["token"] = Node.string(token)
        r["expired"] = Node.number(Node.Number(expired))
        
        return JSON(Node.object(r))
    }
        
    
    func generateToken() throws {
        let date = Date()
        let dateHex = date.hashValue.hex
        token = try CryptoHasher(method: .sha1, defaultKey: nil).make(dateHex)
        expired = date.addingTimeInterval(60*60*1).timeIntervalSince1970.doubleValue
        updated = Int32(date.timeIntervalSince1970)
    }
    
}

struct SessionX {
    let id: String
    let content: String
    let createdAt: NSDate
}


extension SessionX: ResponseRepresentable {
    
    func makeResponse() throws -> Response {
        print(#function)
       return try Response(headers: ["Content-Type": "text/plain; charset=utf-8"], body: JSON(node:
            [
                "id": Node.string(id),
                "content": Node.string(content),
                "created-at": Node.number(Node.Number(Int32(createdAt.timeIntervalSince1970)))
            ]
        ))
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
//        //
//    }
//
//    static func revert(_ database: Database) throws {
//        //
//    }
//}

// MARK: - Custom validators

//class Username: ValidationSuite {
//    static func validate(input value: String) throws {
//        print(#function)
//        let evaluation = OnlyAlphanumeric.self
//            && Count.min(2)
//            && Count.max(20)
//        try evaluation.validate(input: value)
//    }
//}
//
//class Password: ValidationSuite {
//    static func validate(input value: String) throws {
//        print(#function)
//        let evaluation = OnlyAlphanumeric.self
//            && Count.min(4)
//            && Count.max(16)
//        try evaluation.validate(input: value)
//    }
//}

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
public enum SessionError: Error {
    case notConfigured
}


