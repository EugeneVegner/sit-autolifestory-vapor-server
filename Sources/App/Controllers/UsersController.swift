import Vapor
import HTTP

final class UsersController: ResourceRepresentable {
    func index(request: Request) throws -> ResponseRepresentable {
        return try User.all().makeNode().converted(to: JSON.self)
    }
    
    func create(request: Request) throws -> ResponseRepresentable {
        print(#function)
        var user = try request.user()
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
        //return user
    }
    
    func show(request: Request, user: User) throws -> ResponseRepresentable {
        return user
    }
    
    func delete(request: Request, user: User) throws -> ResponseRepresentable {
        try user.delete()
        return JSON([:])
    }
    
    func clear(request: Request) throws -> ResponseRepresentable {
        try User.query().delete()
        return JSON([])
    }
    
    func update(request: Request, user: User) throws -> ResponseRepresentable {
        let new = try request.user()
        var user = user
        user.email = new.email
        user.password = new.password
        user.username = new.username        
        try user.save()
        return user
    }
    
    func replace(request: Request, user: User) throws -> ResponseRepresentable {
        try user.delete()
        return try create(request: request)
    }
    
    func makeResource() -> Resource<User> {
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
    func user() throws -> User {
        guard let json = json else {
            print("incorrect json: \(String(describing: self.json))")
            throw Abort.badRequest }
        print("request json: \(json)")
        return try User(node: json)
    }
}
