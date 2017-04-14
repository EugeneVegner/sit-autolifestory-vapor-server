import Vapor
import Fluent
import Foundation

final class User: Model {
    var id: Node?
    var username: Valid<Name>
    var email: Valid<Email>
    var password: Valid<Password>
    //let title = Valid(Count<String>.max(5))
    
    var exists: Bool = false
    
    init?(username: String, email: String, password: String) {
        self.id = UUID().uuidString.makeNode()
        do {
            self.username = try username.validated()
            self.email = try email.validated()
            self.password = try password.validated()
        } catch  {
            print(error)
            return nil
        }
    }
    
    init(node: Node, in context: Context) throws {
        id = try node.extract("id")
        username = try node.extract("username").string.validated()
        email = try node.extract("email").string.validated()
        password = try node.extract("password").string.validated()
    }
    
    func makeNode(context: Context) throws -> Node {
        return try Node(node: [
            "id": id,
            "username": username.value,
            "email": email.value,
            "password": password.value
            ])
    }
}

extension User {
    /**
     This will automatically fetch from database, using example here to load
     automatically for example. Remove on real models.
     */
    public convenience init?(from username: String, email: String, password: String) throws {
        self.init(username: username, email: email, password: password)
    }
}

extension User: Preparation {
    static func prepare(_ database: Database) throws {
        //
    }
    
    static func revert(_ database: Database) throws {
        //
    }
}

// MARK: - Custom validators

class Name: ValidationSuite {
    static func validate(input value: String) throws {
        let evaluation = OnlyAlphanumeric.self
            && Count.min(2)
            && Count.max(20)

        try evaluation.validate(input: value)
    }
}

class Password: ValidationSuite {
    static func validate(input value: String) throws {
        let evaluation = OnlyAlphanumeric.self
            && Count.min(4)
            && Count.max(16)
        
        try evaluation.validate(input: value)
    }
}


