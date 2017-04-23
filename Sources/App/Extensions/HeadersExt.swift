//
//  HeadersExt.swift
//  Server
//
//  Created by Eugene Vegner on 24.04.17.
//
//

import Vapor
import HTTP

extension HeaderKey {
    
    static public var client: HeaderKey {
        return HeaderKey("Client")
    }
}
