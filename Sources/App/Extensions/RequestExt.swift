//
//  RequestExt.swift
//  Server
//
//  Created by Eugene Vegner on 18.04.17.
//
//

import Vapor
import HTTP

extension Request {
    
    var client: Client? {
        get { return storage["client"] as? Client }
        set { storage["client"] = newValue }
    }
    
    var currentUser: User? {
        get { return storage["user"] as? User }
        set { storage["user"] = newValue }
    }
 
    var currentSession: Session? {
        get { return storage["current_session"] as? Session }
        set { storage["current_session"] = newValue }
    }

    
}

