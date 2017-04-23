//
//  Tags.swift
//  Server
//
//  Created by Eugene Vegner on 23.04.17.
//
//

import Foundation

struct Tags {
    
    enum JSONTag {
        case def, hiden
    }
    
    let name: String
    let json: Bool
    let validator: String?
    let db: Bool

    var value: Any? {
        didSet (val) {
            self.value = val
        }
    }
    
//    let node: Node {
//    
//    
//    
//    }
    
    init(name: String, json: Bool = true, validator: String? = nil, db: Bool = false, defaultValue: Any? = nil) {
        self.name = name
        self.json = json
        self.validator = validator
        self.db = db
        self.value = defaultValue
    }
    
    func node() -> Node {
        return Node.null
    }
    
    
    

}
