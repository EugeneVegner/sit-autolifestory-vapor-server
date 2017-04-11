import Foundation
import Core
import Vapor
import HTTP

@_exported import Node

public struct SuccessJSON {
    public var json: JSON

    public init(_ json: JSON) {
        self.json = json
    }
    
    func send() -> ResponseRepresentable {
        return JSON([
                "success": true,
                "data": json.makeNode()
            ])
    }
}
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
