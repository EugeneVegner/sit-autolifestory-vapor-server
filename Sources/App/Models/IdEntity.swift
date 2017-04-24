//
//  MongoEntity.swift
//  Server
//
//  Created by Eugene Vegner on 15.04.17.
//
//

import Vapor
import Fluent
import HTTP
import Foundation
import JSON
import TypeSafeRouting
//import VaporMongo
import FluentMongo

//@_exported import class FluentMongo.Database

//public protocol EntityProtocol: Entity, JSONRepresentable, StringInitializable, ResponseRepresentable { }
//
//extension EntityProtocol {
//    public func makeResponse() throws -> Response {
//        return try makeJSON().makeResponse()
//    }
//}
//
//// MARK: JSONRepresentable
//
//extension EntityProtocol {
//    public func makeJSON() throws -> JSON {
//        let node = try makeNode()
//        return try JSON(node: node)
//    }
//}
//
//// MARK: StringInitializable
//
//extension EntityProtocol {
//    public init?(from string: String) throws {
//        if let model = try Self.find(string) {
//            self = model
//        } else {
//            return nil
//        }
//    }
//}

public class MongoEntity: Entity {
    
    public var id: Node?
    public var created: Int32
    public var updated: Int32?
    
    public var exists: Bool = false
    
    public init(uuid: String) {
        self.id = uuid.makeNode()
        self.created = Int32(Date().timeIntervalSince1970)
        self.updated = nil
    }
    
    
    public func makeNode(context: Context) throws -> Node {
        if id == nil { id = UUID().uuidString.makeNode() }
        return try Node(node: [
            //"_id": id,
            "created": created,
            "updated": updated
            ])
    }
    
    public func json() throws -> Node {
        print(#function)
        print("self.id <---: \(self.id)")
        
        return try Node(node: [
            "id": self.id,
            "exists": self.exists,
            "created": created,
            "updated": updated
            ])
    }
    
    // MARK: - Requared

    required public init(request: Request) throws {
        let uuid = UUID().uuidString
        self.id = uuid.makeNode()
        self.created = Int32(Date().timeIntervalSince1970)
        self.updated = nil
    }
    required public init(node: Node, in context: Context) throws {
        self.id = node
        self.exists = true
        print("self.id: \(self.id)")
        
        self.created = try node.extract("created")
        self.updated = try node.extract("updated")
    }

}

public protocol Configure {
    /**
     The prepare method should call any methods
     it needs on the database to prepare.
     */
    static func json(_ database: Database) throws -> Node
}


//extension IdEntity {
//    /**
//     This will automatically fetch from database, using example here to load
//     automatically for example. Remove on real models.
//     */
//    
//    public convenience init(_ from: String) {
//        self.init(from)
//    }
//    
////    public convenience init?(from string: String) throws {
////        self.init(content: string)
////    }
//}


extension MongoEntity {
    public static var idKey: String {
        return database?.driver.idKey ?? "_id"
    }
}

extension MongoEntity: Preparation {
    public static func prepare(_ database: Database) throws {}
    public static func revert(_ database: Database) throws {}
}
