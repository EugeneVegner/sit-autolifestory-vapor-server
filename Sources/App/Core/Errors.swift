//import Foundation
//import Core
//import Vapor
//import HTTP
//
//
//class Errors  {
//    static let unknownError: Error = Error(-1, type:"unknown", message: "Something went wrong. Please try again Later", description: "Unknown error" )
//
//    
//}
//

import HTTP
import Node


extension Server {
    enum Error: Swift.Error {
        case unknown
        case new(code: Int, info: String, message: String? , type: String?)
        case status(Status)
    }
}

extension Server.Error {
    
    var node: Node {
        get {
            return [
                "code": code.node,
                "message": message.node,
                "info": info.node,
                "type": type.node
            ]
        }
    }
    
    public var code: Int {
        
        switch self {
        case .unknown: return 500
        case .new(code: let code, info: _, message: _, type: _):
            return code
        case .status(let status):
            return status.statusCode
        }
    }

    public var info: String {
        switch self {
        case .unknown: return "Something went wrong"
        case .new(code: _, info: let info, message: _, type: _):
            return info
        case .status(let status):
            return status.reasonPhrase
        }
    }
    
    public var message: String {
        switch self {
        case .unknown: return "Something went wrong"
        case .new(code: _, info: let info, message: let message, type: _):
            guard let msg = message else {
                return info
            }
            return msg
        case .status(let status):
            return status.reasonPhrase
        }
    }

    public var type: String {
        switch self {
        case .unknown: return "unknown"
        case .new(code: _, info: _, message: _, type: let type):
            guard let type = type else {
                return "unknown"
            }
            return type
        case .status(let status):
            return String(describing: status)

        }
    }

}
