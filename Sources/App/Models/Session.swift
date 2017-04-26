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

final class Session: MongoEntity {
    //var id: Node?
    var userId: Node?
    var token: String
    var expired: Int32
    var deviceId: String
    var udid: String?
    var platform: String
    var provider: ProviderType = .email//fb - logeed via fb, email - logged by email
    
    required init(node: Node, in context: Context) throws {
        self.userId = try node.extract("userId")
        self.token = try node.extract("token")
        self.expired = try node.extract("expired")
        self.deviceId = try node.extract("deviceId")
        self.udid = try node.extract("udid")
        self.platform = try node.extract("platform")
        self.provider = ProviderType(rawValue: try node.extract("provider")) ?? .email
        try super.init(node: node, in: context)
    }
    
    public init(userId: Node?, deviceId: String, udid: String?, platform: String, provider: ProviderType) throws {
        self.userId = userId
        self.token = ""
        self.deviceId = deviceId
        self.udid = udid
        self.platform = platform
        self.expired = 0
        self.provider = provider
        super.init(uuid: UUID().uuidString)
    }
    
//    public required init(from: String) {
//        fatalError("init(from:) has not been implemented")
//    }
    
    public required init(request: Request) throws {
        fatalError("init(from:) has not been implemented")
    }
        
    override func makeNode(context: Context) throws -> Node {
        var node = try super.makeNode(context: context)
        node.append(node: try Node(node: [
            "userId": userId,
            "token": token,
            "expired": expired,
            "deviceId": deviceId,
            "udid": udid,
            "platform": platform,
            "provider": provider.rawValue
            ]))

        return node
    }
    
    func makeJSON() throws -> JSON {
        fatalError("init(request:) has not been implemented")
    }
    
    func generateToken() throws {
        let date = Date()
        let dateHex = date.hashValue.hex
        token = try CryptoHasher(method: .sha1, defaultKey: nil).make(dateHex)
        expired = Int32(date.addingTimeInterval(60*60*1).timeIntervalSince1970)
        updated = Int32(date.timeIntervalSince1970)
    }
    
    override func json() throws -> Node {
        var node = try super.json()
        node.append(node: try Node(node: [
            "userId": userId,
            "token": token,
            "expired": expired,
            "provider": provider.rawValue
            ]))
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


