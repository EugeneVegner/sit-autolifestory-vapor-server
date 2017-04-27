//
//  JSONExtension.swift
//  Server
//
//  Created by Eugene on 27.04.17.
//
//

import JSON
import Vapor
import HTTP

import TurnstileWeb
import Fluent


extension JSON {
    
    func validatedField<T: Validator>(field: String, by validator: T) throws -> T.InputType where T.InputType: PolymorphicInitializable {
        guard let val = self[field] else {
            throw Server.Error.new(code: 45, info: "\(field): is nil", message: nil, type: field)
        }
        let input = try T.InputType.init(polymorphic: val)
        let value = try input.validated(by: validator).value
        return value
    }
    
//    func validated<
//        T: Validator>(by validator: T
//        ) throws -> Valid<T>
//    where T.InputType: PolymorphicInitializable {
//    let value = try T.InputType.init(polymorphic: self)
//    return try value.validated(by: validator)
//    }

    
}



