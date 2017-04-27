//
//  RequestExt.swift
//  Server
//
//  Created by Eugene Vegner on 18.04.17.
//
//

import Vapor
import HTTP
import JSON
import TurnstileWeb
import Fluent

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
    
    
    
    // Validator
    
    func get(_ field: String, nulled: Bool = false) throws -> Polymorphic? {
        guard let val = self.data[field].extract() else {
            if nulled {
                return nil
            }
            throw Server.Error.new(code: 45, info: "\(field): is nil", message: nil, type: field)
        }
        
        //let value = try val.validated(by: DefaultValidationSuite()).value
        return try val.validated(by: DefaultValidationSuite()).value
        
    }

    
    func get<T: Validator>(_ field: String, nulled: Bool = false, by validator: T) throws -> T.InputType? where T.InputType: PolymorphicInitializable {
        guard let val = self.json?[field] else {
            if nulled {
                return nil
            }
            throw Server.Error.new(code: 46, info: "\(field): is nil", message: nil, type: field)
        }
        let input = try T.InputType.init(polymorphic: val)
        let value = try input.validated(by: validator).value
        return value
    }
    class DefaultValidationSuite: ValidationSuite {
        static func validate(input value: String) throws {
            print("ola.. la....")
            // Default ValidationSuite can be anything
            log("input: \(value)")
        }
    }

    
}

