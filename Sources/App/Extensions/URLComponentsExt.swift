//
//  URLComponentsExt.swift
//  Server
//
//  Created by Eugene on 18.05.17.
//
//

import Foundation

extension URLComponents {
    mutating func setQueryItems(dict: [String: String]) {
        // URLQueryItems are messed up on Linux, so we'll do this instead:
        query = dict.map { (key, value) in
            return key + "=" + value
            }.joined(separator: "&")
    }
}
