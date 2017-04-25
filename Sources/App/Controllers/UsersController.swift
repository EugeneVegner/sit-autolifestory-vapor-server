import Vapor
import HTTP
import Fluent


final class UsersController {
    
//    func index(request: Request) throws -> ResponseRepresentable {
//        return try User.all().makeNode().converted(to: JSON.self)
//    }
//    
    func create(request: Request) throws -> ResponseRepresentable {
        log(#function)

        var user: User
        do {
            user = try request.user()
            let filter = Filter(User.self, .group(.or, [
                Filter(User.self, .compare("email", .equals, user.email.makeNode())),
                Filter(User.self, .compare("username", .equals, user.username.makeNode()))
                ]))

            let query = try User.query()
            query.filters = [filter]
            let result = try query.limit(1).run()
            
            if let u = result.first {
                let err: Server.Error
                if u.username == user.username {
                    err = Server.Error.new(code: 20, info: "Username already exist", message: nil, type: "username")
                } else {
                    err = Server.Error.new(code: 21, info: "Email already exist", message: nil, type: "email")
                }
                return Server.failure(errors: [err])
            }
            
            try user.save()

        } catch let error {
            log("Create user error: \(error)")
            let err: Server.Error = Server.Error.new(code: 22, info: error.localizedDescription, message: nil, type: nil)
            return Server.failure(.internalServerError, errors: [err])
        }
        
        var session: Session
        do {
            session = try Session(userId: user.id, deviceId: "", udid: nil, platform: request.client?.platform ?? "I", provider: .email)
            try session.generateToken()
            
        } catch  let error {
            log("Create session error: \(error)")
            let err: Server.Error = Server.Error.new(code: 24, info: error.localizedDescription, message: nil, type: nil)
            return Server.failure(.internalServerError, errors: [err])
        }
        
        do {
            let r = try Node(node:
                [
                    "users": [
                        try user.json()
                    ],
                    "sessions": [
                        try session.json()
                    ]
                ])
            return Server.success(data: r)

        } catch let error {
            log("Create response error: \(error)")
            let err: Server.Error = Server.Error.new(code: 25, info: error.localizedDescription, message: nil, type: nil)
            return Server.failure(.internalServerError, errors: [err])
        }

    }
    
    func show(request: Request, user: User) throws -> ResponseRepresentable {
        return user as! ResponseRepresentable
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
        return user as! ResponseRepresentable
    }
    
    func replace(request: Request, user: User) throws -> ResponseRepresentable {
        try user.delete()
        return try create(request: request)
    }
    
//    func makeResource() -> Resource<User> {
//        return Resource(
//            index: index,
//            store: create,
//            show: show,
//            replace: replace,
//            modify: update,
//            destroy: delete,
//            clear: clear
//        )
//    }
}

extension Request {
    func user() throws -> User {
        return try User(request: self)
    }
}
