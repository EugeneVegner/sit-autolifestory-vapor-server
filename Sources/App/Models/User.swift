import Vapor
import Fluent
import Foundation

final class User: Model {
    var id: Node?
//    var content: String
    var username: String
    var email: String
    var password: String
//    var firstName: String
//    var lastName: String
    
  
    init(username: String, email: String, password: String) {
        self.id = UUID().uuidString.makeNode()
        self.username = username
        self.email = email
        self.password = password
    }
    
    init(node: Node, in context: Context) throws {
        id = try node.extract("id")
        username = try node.extract("username")
        email = try node.extract("email")
        password = try node.extract("password")
    }
    
    func makeNode(context: Context) throws -> Node {
        return try Node(node: [
            "id": id,
            "username": username,
            "email": email
            ])
    }
}

extension User {
    /**
     This will automatically fetch from database, using example here to load
     automatically for example. Remove on real models.
     */
//    public convenience init?(from string: String) throws {
//        self.init(content: string)
//    }
}

extension User: Preparation {
    static func prepare(_ database: Database) throws {
        //
    }
    
    static func revert(_ database: Database) throws {
        //
    }
}
