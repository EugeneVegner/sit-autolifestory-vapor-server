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
        var errors: [ServerError]?
    }
    
    struct Success {
        var data: Node?
    }
    
    static var headers: [HeaderKey: String] {
        return [
            .contentType: "application/json",
            "SecureX": "D"
        ]
    }
    
//    static func callback(data: Node? = nil, errors: [Error]? = nil, code: Int = 0) -> JSON {
//        
//        var success: Bool = true
//        var nodeErr: [Node]? = nil
//        
//        if let errs = errors {
//            success = false
//            
//            for err in errs {
//                //nodeErr?.append(err.makeNode())
//            }
//        }
//        var resp: [String: Node] = [:]
//        resp["success"] = Node(success)
//        resp["code"] = Node(code)
//        resp["data"] = data == nil ? Node.null : data!
//        resp["errors"] = nodeErr == nil ? Node.null : Node(nodeErr!)
//        
//        return JSON(Node(resp))
//
//    }
//    
//    static func successCallback(data: Node) -> JSON {
//        return callback(data: data, errors: nil, code: 0)
//    }


    

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
        let body = try JSON(node: [
            "code": 0,
            "success": true,
            "errors": nil,
            "data": data
            ])
        print("failure: \(body)")
        return Response(headers: Server.headers, body: body)
    }
}

extension Server.Failure: ResponseRepresentable {
//    public func makeResponse() -> Response {
//        do {
//            try <#throwing expression#>
//        } catch pattern {
//            <#statements#>
//        }
//        
//        
//        let body =  JSON(node: [
//            "code": 1,
//            "success": false,
//            "errors": "dsf",
//            "data": nil
//            ])
//        print("failure: \(body)")
//        return Response(headers: Server.headers, body: body)
//
//    
//    }
    func makeResponse() throws -> Response {
        print(#function)
        var array: [Node] = []
        if let errors = errors {
            for err in errors {
                array.append(err.node)
            }
        }
        
        let body = try JSON(node: [
            "code": code,
            "success": false,
            "errors": Node(array),
            "data": nil
            ])
        print("failure: \(body)")
        return Response(headers: Server.headers, body: body)
    }
}




