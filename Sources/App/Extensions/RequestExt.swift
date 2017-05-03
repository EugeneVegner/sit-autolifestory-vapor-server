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
import BSON

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
    
    func get<T:PolymorphicInitializable>(_ field: String, nulled: Bool = false)
        throws -> T?
        where T: PolymorphicInitializable
    {
        guard let val = self.data[field].extract() else {
            if nulled {
                return nil
            }
            throw Server.Error.new(code: 45, info: "\(field): is nil", message: nil, type: field)
        }
        log("object type: \(T.self)")
        let value = try val.validated(by: DefaultValidationSuite()).value
        
        do {
            let output = try T.init(polymorphic: value)
            print("output: \(output)")
            return output
            
        } catch {
            log("error: \(error)")
            throw Server.Error.new(
                code: 46,
                info: "\"\(value)\" could not be converted to \(T.self)",
                message: "Please enter valid value",
                type: "validator")
        }
    }

    
    func get<T: Validator>(_ field: String, nulled: Bool = false, by validator: T)
        throws -> T.InputType?
        where T.InputType: PolymorphicInitializable
    {
        guard let val = self.data[field].extract() else {
            if nulled {
                return nil
            }
            throw Server.Error.new(code: 47, info: "\(field): is nil", message: nil, type: field)
        }
        print("T: \(T.self)")
        print("T.Type: \(T.InputType.self)")
        print("val [\(String(describing: val.self))]: \(val)")
        
        log("object type: \(T.self)")
        let value = try val.validated(by: DefaultValidationSuite()).value
        
        do {
            //let output = try T.init(polymorphic: value)
            let output = try T.InputType.init(polymorphic: value)
            print("output: \(output)")
            return output
            
        } catch {
            log("error: \(error)")
            throw Server.Error.new(
                code: 48,
                info: "\"\(value)\" could not be converted to \(T.self)",
                message: "Please enter valid value",
                type: "validator")
        }
        
        
        //
        //
        //        let input = try T.InputType.init(polymorphic: val)
        //        let value = try input.validated(by: validator).value
        //        return value
    }
    class DefaultValidationSuite: ValidationSuite {
        static func validate(input value: String) throws {
            print("ola.. la....")
            // Default ValidationSuite can be anything
            log("input: \(value)")
        }
    }

    
}

