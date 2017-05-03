//
//  UploadController.swift
//  Server
//
//  Created by Eugene Vegner on 04.05.17.
//
//

import Vapor
import HTTP
import Fluent

final class UploadController {

    func uploadImage(request: Request) throws -> ResponseRepresentable {
        let name = req.data["name"]
        //let image = req.data["image"] // or req.multipart["image"]
        let image = req.multipart["image"]

        
        let r = try Node(node:
            [
                "files": [
                    //{"name":name}
                ],
            ])
        return Server.success(data: r)

    }

    
}
