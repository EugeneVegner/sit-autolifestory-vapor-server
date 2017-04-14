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

/**
 Represents errors that can be thrown in any Vapor closure.
 Then, these errors can be caught in `Middleware` to give a
 desired response.
 */

public struct ServerError {
    var code: Int = 0
    var description: String?
    var message: String?
    var type: String?
    
    init(_ code: Int, type: String, message: String, description: String) {
        self.code = code
        self.type = type
        self.description = description
        self.message = message
    }
    
    func makeNode() -> Node {
        return Node([
            "code": Node(code),
            "type": Node(type ?? "unknown"),
            "description": Node(description ?? "Unknown"),
            "message": Node(message ?? "Sorry, something went wrong"),
            ])
    }
    
}


public protocol CallbackError: Error {
    var message: String { get }
    var description: String { get }
    var code: Int { get }
    var status: Status { get }
    var data: Node? { get }
    var metadata: Node? { get }
    var errors: [Error]? { get }
}

/**
 A handful of standard errors that can be thrown
 in any Vapor closure by calling `throw Abort.<case>`.
 These errors can be caught in Middleware to give
 a desired response.
 */
public enum Callback: Swift.Error {
    case badRequest
    case notFound
    case unknowError
    case serverError
    case seccess(data: Node)
    case failure(code: Int, errors: [Error])
}

extension Callback: CallbackError {
    public var data: Node? {
     return nil
    }

    
    public var message: String {
        switch self {
        case .badRequest: return "Invalid request"
        case .notFound: return "Page not found"
        case .unknowError, .serverError: return "Something went wrong"
        case .seccess(data: _): return ""
        case .failure(code: _, errors: let errors):
            if let err = errors.first {
                return err.localizedDescription
            }
            return ""
        }
    }

    public var description: String {
        switch self {
        case .badRequest: return "Invalid request"
        case .notFound: return "Page not found"
        case .unknowError, .serverError: return "Something went wrong"
        case .seccess(data: _): return ""
        case .failure(code: _, errors: let errors):
            if let err = errors.first {
                return err.localizedDescription
            }
            return ""
        }
    }
    
    public var code: Int {
        switch self {
        case .badRequest:
            return 400
        case .notFound:
            return 404
        case .serverError:
            return 500
        case .unknowError:
            return 500
        case .seccess(data: _): return 200
        case .failure(code: _, errors: let errors): return 400
        }
    }
    
    public var status: Status {
        switch self {
        case .badRequest:
            return .badRequest
        case .notFound:
            return .notFound
        case .serverError:
            return .internalServerError
        case .unknowError:
            return .ok
        case .seccess(data: _): return .ok
        case .failure(code: _, errors: let errors): return .expectationFailed
        }
    }
    
//    public var data: Node? {
//        return nil
//    }

    public var metadata: Node? {
        switch self {
        case .seccess(data: let dt): return dt
        default: return nil
        }
    }

    
    public var errors: [Error]? {
        switch self {
        case .badRequest:
            return nil
        case .notFound:
            return nil
        case .serverError:
            return nil
        case .unknowError:
            return nil
        case .seccess(data: _): return nil
        case .failure(code: _, errors: let errors): return errors
        }

    }

    
}
