//
//  FacebookUser.swift
//  Server
//
//  Created by Eugene on 18.05.17.
//
//

import Vapor
import Foundation

class FacebookUser {

    var email: String = ""
    var name: String = ""
    var firstName: String = ""
    var lastName: String = ""
    var id: Int64 = 0
    
    
    init(data: Data) throws {

        guard let json: [String: Any] = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] else {
            throw Server.Error.new(code: 80, info: "Invalid facebook data", message: "Invalid facebook data", type: "facebook")
        }
        print("JSON: \(json)")
        
        guard let id = json["id"] as? Int64, let name = json["name"] as? String else {
            throw Server.Error.new(code: 81, info: "Invalid facebook user data", message: "Invalid facebook user data", type: "facebook")
        }
        
        self.id = id
        self.name = name
        self.firstName = json["first_name"] as? String ?? ""
        self.lastName = json["last_name"] as? String ?? ""
        self.email = json["email"] as? String ?? ""

    }

}
