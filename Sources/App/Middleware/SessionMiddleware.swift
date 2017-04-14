//
//  SessionMiddleware.swift
//  Server
//
//  Created by Eugene Vegner on 12.04.17.
//
//

import HTTP
import Vapor

class SessionMiddleware: Middleware {

    func respond(to request: Request, chainingTo next: Responder) throws -> Response {
        
        let response = try next.respond(to: request)
        //response.client = cl
        return response

        
        throw Abort.custom(status: .ok, message: "test")
        //return Server.successCallback(data: Node(["test":"sd"]))
        
        
        
        
        
        //        do {
        //            return try next.respond(to: request)
        //        } catch FooError.fooServiceUnavailable {
        //            throw Abort.custom(
        //                status: .badRequest,
        //                message: "Sorry, we were unable to query the Foo service."
        //            )
        //        }

    }
}
