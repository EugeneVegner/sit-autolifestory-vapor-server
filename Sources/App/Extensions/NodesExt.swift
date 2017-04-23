//
//  NodesExt.swift
//  Server
//
//  Created by Eugene Vegner on 22.04.17.
//
//

import Vapor
import HTTP
import Foundation
import Core

extension Int {
    var node: Node { get { return Node.number(Node.Number(self)) } }
}
extension Int32 {
    var node: Node { get { return Node.number(Node.Number(self)) } }
}
extension Double {
    var node: Node { get { return Node.number(Node.Number(self)) } }
}
extension Bool {
    var node: Node { get { return Node.bool(self) } }
}
extension String {
    var node: Node { get { return Node.string(self) } }
}
//extension null {
//    var node: Node { get { return Node.null } }
//}
//extension nil {
//    let node: Node = { return Node.null }
//}

extension Node {
    
    mutating func append(node: Node?)  {
        //var dictOfNodes: [String : Node] = [:]
        guard let dic = node?.nodeObject else {
            return
        }
        for (key, val) in dic {
            self[key] = val
        }
    }
    
    
}





