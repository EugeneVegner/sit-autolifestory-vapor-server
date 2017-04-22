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

public enum ServerError: Swift.Error {
    case unknown
    case new(code: Int, info: String, message: String? , type: String?)
    case error(error: Error)
}

extension ServerError {
    
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
        case .error(error: _):
            return 1
        }
    }

    public var info: String {
        switch self {
        case .unknown: return "Something went wrong"
        case .new(code: _, info: let info, message: _, type: _):
            return info
        case .error(error: let err):
            return err.localizedDescription

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
        case .error(error: let err):
            return err.localizedDescription

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
        case .error(error: _):
            return "error"

        }
    }

}
