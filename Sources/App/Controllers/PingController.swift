import Vapor
import HTTP
import Foundation

final class PingController: ResourceRepresentable {
    
    func index(request: Request) throws -> ResponseRepresentable {
        return try Post.all().makeNode().converted(to: JSON.self)
    }
    
    func test(request: Request) throws -> ResponseRepresentable {
        print(#function)
//        var post = try request.post()
//        try post.save()
//        return post
        //throw Callback.unknowError
        //Byte
        
        let date = Date()
        let dateHex = date.hashValue.hex
//        let hash: String = try CryptoHasher(method: .sha1, defaultKey: nil).make(dateHex)
//        let expired: Int32 = Int32(date.addingTimeInterval(60*60*1).timeIntervalSince1970)
//        let expiredD: Double = date.addingTimeInterval(60*60*1).timeIntervalSince1970.doubleValue
        
//        print("IntMax: \(IntMax())")
//        print("Int8.max: \(Int8.max)")
//        print("Int16.max: \(Int16.max)")
//        print("Int32.max: \(Int32.max)") // year 2038 (2147483647)
//        print("Int64.max: \(Int64.max)") // year 2262 (9223372036854775807)

        
        
        
//        print("dateHex: \(dateHex)")
//        print("token hash: \(hash)")
//        print("expired: \(expired)")
//        print("expiredD: \(Node.number(Node.Number(expiredD)).string)")
//        print("Request client: \(request.client)")
//        print("Request session: \(try request.session().data)")
        
        //let ses = try Session()
        //try ses.generateToken()
        //let nd = try ses.makeNode()
        //let json = ses.json()
        
        var nodes: [Node] = []
        do {
            let users = try User.query().run().array
//            return Server.success(data: [
//                "users": try users.makeNode()
//                ])

            for user in users {
                let urs = try user.json()
                nodes.append(urs)
            }
            

        } catch let error {
            print(error)
            let err = Server.Error.new(code: 15, info: error.localizedDescription, message: nil, type: nil)
            return Server.failure(errors: [err])
        }
                
        return Server.success(data: [
                "users": Node.array(nodes)
            ])
    }
    
    


    
    
    
    func create(request: Request) throws -> ResponseRepresentable {
        var post = try request.post()
        try post.save()
        return post
    }

    
    
    
    func show(request: Request, post: Post) throws -> ResponseRepresentable {
        return post
    }
    
    func delete(request: Request, post: Post) throws -> ResponseRepresentable {
        try post.delete()
        return JSON([:])
    }
    
    func clear(request: Request) throws -> ResponseRepresentable {
        try Post.query().delete()
        return JSON([])
    }
    
    func update(request: Request, post: Post) throws -> ResponseRepresentable {
        let new = try request.post()
        var post = post
        post.content = new.content
        try post.save()
        return post
    }
    
    func replace(request: Request, post: Post) throws -> ResponseRepresentable {
        try post.delete()
        return try create(request: request)
    }
    
    func makeResource() -> Resource<Post> {
        return Resource(
            index: index,
            store: create,
            show: show,
            replace: replace,
            modify: update,
            destroy: delete,
            clear: clear
        )
    }

    func send() throws -> ResponseRepresentable {
        return JSON([])
    }
    
}
