import Vapor
import HTTP
import TurnstileWeb
import Fluent
import MongoKitten

final class AuthController {
    
    class BodyData {
        var deviceId: String
        var deviceToken: String?
        init(request: Request) throws {
            self.deviceId = try request.get("deviceId", nulled: false, by: NotNull()) ?? "unknown"
            self.deviceToken = try request.get("deviceToken", nulled: true)
            //self.testId = try request.get("deviceToken", nulled: true)! as! Int
            //print("self.deviceToken: \(self.deviceToken)")
        }

    }
    
    class SignInData: BodyData {
        var email: String
        var password: String
        override init(request: Request) throws {
            self.email = try request.get("email", nulled: false, by: NotNull()) ?? ""
            self.password = try request.get("password", nulled: false, by: NotNull()) ?? ""
            try super.init(request: request)
        }
    }
    
    class SignUpData: SignInData {
        var username: String
        override init(request: Request) throws {
            self.username = try request.get("username", nulled: false, by: NotNull()) ?? "noname"
            try super.init(request: request)
        }
    }
    

    class FacebookData: BodyData {
        var facebookToken: String
        override init(request: Request) throws {
            self.facebookToken = try request.data["facebookToken"].validated(by: Default.self).value
            try super.init(request: request)
        }
    }

    // MARK: - Routs
    
    
    func signIn(request: Request) throws -> ResponseRepresentable {
        log(#function)
        do {
            let data = try request.parseSignInData()
            print("data: \(data)")
            
            let users = try User.query().filter("email", data.email).limit(1).run().array
            guard let user = users.first else {
                return JSON(["errrrr":"usernot found"])
            }
            if data.password != user.password {
                return JSON(["errrrr":"invalid passwor"])
            }
            
            
            let session = try configureSessionIfNeeded(user: user, request: request, data: data)
            print("user: \(user)")
            request.currentUser = user
            
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
            print("Create user error: \(error)")
            return Server.failure(errors: [error])
        }
        
    }
    
    func signUp(request: Request) throws -> ResponseRepresentable {
        log(#function)
        do {
            let data = try request.parseSignUpData()
            print("data: \(data)")
            let user = try createNewUser(request: request, data: data)
            let session = try configureSessionIfNeeded(user: user, request: request, data: data)
            //print("user: \(user)")
            request.currentUser = user
            
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
            print("Create user error: \(error)")
            return Server.failure(errors: [error])
        }
        
    }

    func fb(request: Request) throws -> ResponseRepresentable {
        
        //let facebook = Facebook(clientID: "clientID", clientSecret: "clientSecret")
        //let google = Google(clientID: "clientID", clientSecret: "clientSecret")

        
        //let credentials = try facebook.authenticate(authorizationCodeCallbackURL: url, state: state) as! FacebookAccount
        //let credentials = try google.authenticate(authorizationCodeCallbackURL: url, state: state) as! GoogleAccount

        
         return JSON([:])
        
    }
    
    // MARK: - Private
    
    private func createNewUser(request: Request, data: SignUpData) throws -> User {
        let filter = Filter(User.self, .group(.or, [
            Filter(User.self, .compare("email", .equals, data.email.makeNode())),
            Filter(User.self, .compare("username", .equals, data.username.makeNode()))
            ]))
        
        
        let users = try User.all()
        users.fin
        
        
        let query = try User.query()
        query.filters = [filter]
        let result = try query.limit(1).run()
        
        if let u = result.first {
            let err: Server.Error
            if u.username == data.username {
                err = Server.Error.new(code: 20, info: "Username already exist", message: nil, type: "username")
            } else {
                err = Server.Error.new(code: 21, info: "Email already exist", message: nil, type: "email")
            }
            throw err
        }
        
        var user = User(username: data.username, email: data.email, password: data.password)
        try user.save()
        return user
    }

    private func configureSessionIfNeeded(user: User, request: Request, data: BodyData) throws -> Session {
        guard let userId = user.id, let client = request.client else {
            throw Server.Error.new(code: 26, info: "Invalid userId or client of request", message: nil, type: "session")
        }
        
        let filter = Filter(Session.self, .group(.or, [
            Filter(Session.self, .compare("userId", .equals, userId)),
            Filter(Session.self, .compare("deviceId", .equals, data.deviceId.node))
            ]))
        
        let query = try Session.query()
        query.filters = [filter]
        let sessions = try query.limit(1).run()
        
        var session = sessions.first
        if session == nil {
//            session = try Session(userId: userId, deviceId: data.deviceId, udid: data.deviceId, platform: client.platform ?? "", provider: .email)
            
            session = try Session(user: user, deviceId: data.deviceId, udid: data.deviceId, platform: client.platform ?? "", provider: .email)

        }
        
        try session?.generateToken()
        try session?.save()
        
        if session == nil {
            throw Server.Error.new(code: 27, info: "", message: nil, type: "session")
        }
        return session!
    }
    
    
}

private extension Request {
    func parseSignInData() throws -> AuthController.SignInData {
        //guard let _ = json else { throw Abort.badRequest }
        return try AuthController.SignInData(request: self)
    }
    
    func parseSignUpData() throws -> AuthController.SignUpData {
        //guard let _ = json else { throw Abort.badRequest }
        return try AuthController.SignUpData(request: self)
    }
    
    func parseFacebookData() throws -> AuthController.FacebookData {
        guard let _ = json else { throw Abort.badRequest }
        return try AuthController.FacebookData(request: self)
    }
}


//extension Request {
//    func post() throws -> Post {
//        guard let json = json else { throw Abort.badRequest }
//        return try Post(node: json)
//    }
//}
