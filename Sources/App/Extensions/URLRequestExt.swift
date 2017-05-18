//
//  URLRequestExt.swift
//  Server
//
//  Created by Eugene on 18.05.17.
//
//

import Foundation

extension URLRequest {
    mutating func setBodyURLEncoded(dict: [String: String]) {
        httpBody = dict.map { (key, value) in
            return key + "=" + value
            }
            .joined(separator: "&")
            .data(using: .utf8)
        
        setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
    }
}
