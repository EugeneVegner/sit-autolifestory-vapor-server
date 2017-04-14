//
//  ClientMiddleware.swift
//  Server
//
//  Created by Eugene Vegner on 11.04.17.
//
//

import HTTP
import Vapor
import Polymorphic
import Sessions


public struct Client {
    var version: Double?
    var platform: String?
    var sys: String?
    
    init(values: [Polymorphic]) {
        guard let version = values[0].double, let platform = values[1].string, let sys = values[2].string else {
            return
        }
        self.version = version
        self.platform = platform
        self.sys = sys
    }
    
    func isValid() -> Bool {
        return true
    }
    
}


extension Response {
    var client: Client? {
        get { return storage["client"] as? Client }
        set { storage["client"] = newValue }
    }
}

//final class Client {
//    var version: Double?
//    var platform: String?
//    var sys: String?
//}

final class ClientMiddleware: Middleware {
    
    func respond(to request: Request, chainingTo next: Responder) throws -> Response {
        
        if let val = request.headers["Client"]?.string {
            
            let values = val.characters
                .split(separator: "/")
                .map { String($0) }
                .map { $0.trim() }
                .map { $0 as Polymorphic }
            
            if values.count != 3 {
                
                throw Callback.unknowError
                
            }
                        
            let cl = Client(values: values)
            if cl.isValid() == false {
                
                //throw Server.successCallback(data: Node(["test":"sd"]))
                
                throw Abort.custom(status: .ok, message: "Incorrect vesrsion")
            }
            
            throw Callback.seccess(data: Node(["test":"sd"]))
            //throw Server.successCallback(data: Node(["test":"sd"]))
            
            
            //throw Abort.custom(status: .ok, message: "Incorrect vesrsion")
            
            let response = try next.respond(to: request)
            response.client = cl
            return response

            
//            let response = try next.respond(to: request)
//            response.headers["sadasdasd"] = "sad"
            
            
            //throw Abort.custom(status: .ok, message: "Incorrect clent's param2")
            
        }
        else {
            throw Callback.unknowError
            //throw Abort.custom(status: .unauthorized, message: "No client")
            
        }
    }
}
