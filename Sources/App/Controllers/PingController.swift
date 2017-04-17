import Vapor
import HTTP

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
        
        print("Request client: \(request.client)")
        print("Request session: \(try request.session().data)")
        
        
        return JSON(["afdad":"ddddddd"])
        //return Server.successCallback(data: Node(["test":"sd"]))
        //return SuccessJSON(JSON([:])).send()// try send()
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
