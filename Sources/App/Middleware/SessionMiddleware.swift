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
        
        guard let sessionToken = request.headers[.authorization] else {
            throw Abort.custom(status: .ok, message: "Incorrect token")
        }
        
        do {
            let result = try Session.query().filter("token", sessionToken).limit(1).run()
            guard let session = result.first else {
                print("Token not found")
                throw Abort.custom(status: .ok, message: "Token not found")
            }
            
            guard let userId = session.userId else {
                print("userId not found")
                throw Abort.custom(status: .ok, message: "Invalid session")
            }
            
            let users = try User.query().filter("_id", userId.makeBsonValue().string).limit(1).run()
            guard let user = users.first else {
                print("user not found")
                throw Abort.custom(status: .ok, message: "User not found")
            }
            
            request.currentUser = user
            let response = try next.respond(to: request)
            return response
            
        } catch {
            log("ERROR: Get session's user error: \(error)")
            throw Abort.custom(status: .ok, message: "Token error")
        }

    }
}
