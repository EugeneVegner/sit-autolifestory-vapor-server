import Foundation
import Core
import Vapor
import HTTP

enum CallbackType {
    case success, failure
}

public func log(_ items: Any...) {
    print(items)
}


class Server {
    
    struct failure {
        var status: Status = .badRequest
        let errors: [Swift.Error]

        init(_ status: Status = .badRequest, errors: [Swift.Error]) {
            self.status = status
            self.errors = errors
        }
    }
    
    struct success {
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


extension Server.success: ResponseRepresentable {
    
    func makeResponse() throws -> Response {
        print(#function)
        let body = try JSON(node: [
            "code": 0,
            "success": true,
            "errors": nil,
            "data": data
            ])
        print("success: \(body)")
        return Response(headers: Server.headers, body: body)
    }
}

extension Server.failure: ResponseRepresentable {
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
        for error in errors {
            if let err = error as? Server.Error {
                array.append(err.node)
            } else {
                array.append(Server.Error.new(code: -1, info: error.localizedDescription, message: nil, type: "error").node)
            }
        }
        
        let body = try JSON(node: [
            "code": status.statusCode,
            "success": false,
            "errors": Node(array),
            "data": nil
            ])
        print("failure: \(body)")
        
        return Response(version: Version(major: 1), status: status, headers: Server.headers, body: body)
    }
}




