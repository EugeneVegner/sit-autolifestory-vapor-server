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

final class ClientMiddleware: Middleware {
    
    func respond(to request: Request, chainingTo next: Responder) throws -> Response {
        
        if let val = request.headers["Client"]?.string {
            
            let values = val.characters
                .split(separator: "/")
                .map { String($0) }
                .map { $0.trim() }
                .map { $0 as Polymorphic }
            
            if values.count != 3 {
                let error = Server.Error.new(code: 5, info: "Invalid \"Client\" header", message: nil, type: "client")
                return try Server.failure(status: .badRequest, errors: [error]).makeResponse()
            }
                        
            let cl = Client(values: values)
            if cl.isValid() == false {
                let status: Status = .serviceUnavailable
                return try Server.failure(status: status, errors: [Server.Error.new(code: 5, info: status.reasonPhrase, message: "Current clien not supported", type: "client")]).makeResponse()
            }
            
            request.client = cl
            let response = try next.respond(to: request)
            return response
            
        }
        else {
            return try Server.failure(status: .badRequest, errors: [Server.Error.unknown]).makeResponse()
        }
    }
}
