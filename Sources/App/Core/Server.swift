import Foundation
import Core
import Vapor
import HTTP

enum CallbackType {
    case success, failure
}

enum ProviderType: String {
    case email = "email"
    case fb = "fb"
}


class Server {
    
    struct Failure {
        var code: Int = 0
        var errors: [Swift.Error]?
    }
    
    struct Success {
        var data: [IdEntity]
    }
    
    var headers: [String: String] {
        return [
            "Content-Type": "application/json",
            "SecureX": "D"
        ]
    }
    
    static func callback(data: Node? = nil, errors: [Error]? = nil, code: Int = 0) -> JSON {
        
        var success: Bool = true
        var nodeErr: [Node]? = nil
        
        if let errs = errors {
            success = false
            
            for err in errs {
                //nodeErr?.append(err.makeNode())
            }
        }
        var resp: [String: Node] = [:]
        resp["success"] = Node(success)
        resp["code"] = Node(code)
        resp["data"] = data == nil ? Node.null : data!
        resp["errors"] = nodeErr == nil ? Node.null : Node(nodeErr!)
        
        return JSON(Node(resp))

    }
    
    static func successCallback(data: Node) -> JSON {
        return callback(data: data, errors: nil, code: 0)
    }


    

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}


extension Server.Success: ResponseRepresentable {
    
    func makeResponse() throws -> Response {
        print(#function)
        return try Response(headers: Server.headers, body: JSON(node:
            [
                "id": Node.string(id),
                "content": Node.string(content),
                "created-at": Node.number(Node.Number(Int32(createdAt.timeIntervalSince1970)))
            ]
        ))
    }
}




