//
//  CustomValidators.swift
//  Server
//
//  Created by Eugene Vegner on 18.04.17.
//
//

import Vapor

class NotNull: ValidationSuite {
    static func validate(input value: String) throws {
        let passed = value.passes(Count.min(1))
        if !passed {
            throw error(with: "Value is null")
        }
    }
}

class Default: ValidationSuite {
    static func validate(input value: String) throws {
        let passed = value.passes(Count.min(1))
        if !passed {
            throw error(with: "Value is null")
        }
    }
}

