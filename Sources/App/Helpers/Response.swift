import Foundation
//import Core
import Vapor
import HTTP

@_exported import Node

//extension Request {
//    
//    private func callback(data: Node? = nil, errors: [Error]? = nil, code: Int = 0) -> ResponseRepresentable {
//        
//        var success: Bool = true
//        var nodeErr: [Node]? = nil
//        
//        if let errs = errors {
//            success = false
//            
//            for err in errs {
//                nodeErr?.append(err.makeNode())
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
//    func callbackSuccess(data: Node) -> ResponseRepresentable {
//        return callback(data: data, errors: nil, code: 0)
//    }
//
//    func callbackFailure(errors:[Error]) -> ResponseRepresentable {
//       
//        if errors.count == 0 {
//            return callback(data: nil, errors: [Errors.unknownError], code: -1)
//        }
//        
//        let err = errors.first
//        return callback(data: nil, errors: errors, code: err?.code ?? -2)
//    }
//
//    
//}



//public struct SuccessJSON: JSON {
//    public var node: Node
//
//    public init(_ node: Node) {
//        self.node = node
//    }
//}



//import Vapor
//import HTTP
//import Fluent
//import Foundation
//import Core
//
////import Foundation
////import Core
//@_exported import Node
//
////public struct SuccessJSON: NodeBacked {
////    public var node: Node
////    public init(_ node: Node) {
////        self.node = [
////            "success": true,
////            "code": 0,
////            "errors": nil,
////            "data": node
////        ]
////        
//////        self.node["success"] = true
//////        self.node["code"] = 0
//////        self.node["errors"] = nil
//////        self.node["data"] = node
////    }
////}
//
//
//
//
//
//final class SuccessJSON {
//    public var data: Node
//    var code: Int = 0
//    
//    public init(_ data: Node) {
//        self.data = data
//    }
//
//    init(data: JSON, code: Int = 0) {
//        self.data = data.node
//        self.code = code
//    }
//    
//    func send() -> Node  {
//        return Node([
//            "success": true,
//            "code": Node(self.code),
//            "data": data
//        ])
//    }
//    
//
//    
//    func index(request: Request) throws -> ResponseRepresentable {
//        return try Post.all().makeNode().converted(to: JSON.self)
//    }
//    
//    func test(request: Request) throws -> ResponseRepresentable {
//        //        var post = try request.post()
//        //        try post.save()
//        //        return post
//        
//        
//        return JSON(["source":"val"])
//    }
//
//}
