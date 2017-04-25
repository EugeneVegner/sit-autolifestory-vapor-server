import Vapor
import HTTP
import TurnstileWeb
import Fluent

final class AuthController {
    
    class BodyData {
        var deviceId: String
        var deviceToken: String?
        init(request: Request) throws {
            self.deviceId = try request.data["deviceId"].validated(by: Default.self).value
            if let val = request.data["deviceToken"] { self.deviceToken = try val.validated(by: Default.self).value }
        }

    }
    
    class SignInData: BodyData {
        var email: String
        var password: String
        
        override init(request: Request) throws {
            self.email = try request.data["email"].validated(by: Email.self).value
            self.password = try request.data["password"].validated(by: Password.self).value
            try super.init(request: request)
        }
    }
    
    class FBData: BodyData {
        var facebookToken: String
        override init(request: Request) throws {
            self.facebookToken = try request.data["facebookToken"].validated(by: Default.self).value
            try super.init(request: request)
        }
    }

    
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
            return JSON(["test":error.localizedDescription.node])
        }
        
    }
    
    func signUp(request: Request) throws -> ResponseRepresentable {
        
        
        
        return JSON([:])
        
    }

    func fb(request: Request) throws -> ResponseRepresentable {
        
        //let facebook = Facebook(clientID: "clientID", clientSecret: "clientSecret")
        //let google = Google(clientID: "clientID", clientSecret: "clientSecret")

        
        //let credentials = try facebook.authenticate(authorizationCodeCallbackURL: url, state: state) as! FacebookAccount
        //let credentials = try google.authenticate(authorizationCodeCallbackURL: url, state: state) as! GoogleAccount

        
         return JSON([:])
        
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
            session = try Session(userId: userId, deviceId: data.deviceId, udid: data.deviceId, platform: client.platform ?? "", provider: .email)
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
    
    func parseSignUpData() throws -> AuthController.SignInData {
        guard let _ = json else { throw Abort.badRequest }
        return try AuthController.SignInData(request: self)
    }
    
    func parseFbData() throws -> AuthController.FBData {
        guard let _ = json else { throw Abort.badRequest }
        return try AuthController.FBData(request: self)
    }
}


//extension Request {
//    func post() throws -> Post {
//        guard let json = json else { throw Abort.badRequest }
//        return try Post(node: json)
//    }
//}
