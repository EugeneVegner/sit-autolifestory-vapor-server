import Foundation
import Core
import Vapor
import HTTP

enum CallbackType {
    case success, failure
}

class Server {
    
    static func callback(data: Node? = nil, errors: [Error]? = nil, code: Int = 0) -> ResponseRepresentable {
        
        var success: Bool = true
        var nodeErr: [Node]? = nil
        
        if let errs = errors {
            success = false
            
            for err in errs {
                nodeErr?.append(err.makeNode())
            }
        }
        var resp: [String: Node] = [:]
        resp["success"] = Node(success)
        resp["code"] = Node(code)
        resp["data"] = data == nil ? Node.null : data!
        resp["errors"] = nodeErr == nil ? Node.null : Node(nodeErr!)
        
        return JSON(Node(resp))

    }
    
    static func successCallback(data: Node) -> ResponseRepresentable {
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