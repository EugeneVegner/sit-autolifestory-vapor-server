import Foundation
import Core
import Vapor
import HTTP


class Errors  {

    
}

public struct Error {
    var code: Int = 0
    var description: String?
    var message: String?
    var type: String?
    
    init(_ code: Int, type: String, message: String, description: String) {
        self.code = code
        self.type = type
        self.description = description
        self.message = message
    }
    
    func makeNode() -> Node {
        return Node([
            "code": Node(code),
            "type": Node(type ?? "unknown"),
            "description": Node(description ?? "Unknown"),
            "message": Node(message ?? "Sorry, something went wrong"),
            ])
    }
    
}

