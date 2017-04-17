import Vapor
import HTTP

private struct Incoming {
    var email: Valid<Email>
    var password: Valid<Password>
    var deviceToken: Valid<NotNull>
    var deviceId: Valid<NotNull>
    var provider: Valid<OnlyAlphanumeric>
    var facebookToken: Valid<NotNull>

    init(
        email: String,
        password: String,
        deviceToken: String,
        deviceId: String,
        provider: String,
        facebookToken: String) throws {
        
        try self.email = email.validated()
        try self.password = password.validated()
        try self.deviceToken = deviceToken.validated()
        try self.deviceId = deviceId.validated()
        try self.provider = provider.validated()
        try self.facebookToken = facebookToken.validated()
        
    }
    
}


final class AuthController: ResourceRepresentable {
    
    func index(request: Request) throws -> ResponseRepresentable {
        return try Post.all().makeNode().converted(to: JSON.self)
    }
    
    
    func signIn(request: Request) throws -> ResponseRepresentable {
        print(#function)
        let client = request.client
        let email = request.
        
        
        
        do {
            let result = try User.query().filter("email", user.email.value).limit(1).run()
            if let _ = result.first {
                return JSON(["test":"exist"])
            }
            
            
            try user.save()
            //let node = try user.makeNode()
            print("User has been created")
            return user//JSON(["test":node])
            
        } catch {
            print("Create user error: \(error)")
            return JSON(["test":"error"])
        }

        
        
        
        
         return JSON([:])
        
        
        
    }
    
    func signUp(request: Request) throws -> ResponseRepresentable {
        
        
        
        return JSON([:])
        
    }

    func fb(request: Request) throws -> ResponseRepresentable {
        
        
        
         return JSON([:])
        
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
}

extension Request {
    func post() throws -> Post {
        guard let json = json else { throw Abort.badRequest }
        return try Post(node: json)
    }
}


//extension Request {
//    func post() throws -> Post {
//        guard let json = json else { throw Abort.badRequest }
//        return try Post(node: json)
//    }
//}
