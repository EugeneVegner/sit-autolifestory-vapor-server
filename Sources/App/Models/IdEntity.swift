//
//  IdEntity.swift
//  Server
//
//  Created by Eugene Vegner on 15.04.17.
//
//

import Vapor
import Fluent
import HTTP
import Foundation

public class IdEntity: Model {
    
    public var id: Node?
    public var created: Double
    public var updated: Double?
    
    public var exists: Bool = false
    
    public required init(from: String) {
        self.id = UUID().uuidString.makeNode()
        self.created = Date().timeIntervalSince1970.doubleValue
        self.updated = nil
    }
    
    public required init(node: Node, in context: Context) throws {
        id = try node.extract("_id")
        created = try node.extract("created")
        updated = try node.extract("updated")
    }
    
    public func makeNode(context: Context) throws -> Node {
        return try Node(node: [
            "_id": id,
            "created": created,
            "updated": updated
            ])
    }
    
    public required init(request: Request) throws {
        print(#function)
        //self.id = UUID().uuidString.makeNode()
        self.created = Date().timeIntervalSince1970.doubleValue
        self.updated = nil
    }

}

extension IdEntity {
    /**
     This will automatically fetch from database, using example here to load
     automatically for example. Remove on real models.
     */
    
    public convenience init(_ from: String) {
        self.init(from)
    }
    
//    public convenience init?(from string: String) throws {
//        self.init(content: string)
//    }
}

extension IdEntity: Preparation {
    public static func prepare(_ database: Database) throws {
        //
    }
    
    public static func revert(_ database: Database) throws {
        //
    }
}
