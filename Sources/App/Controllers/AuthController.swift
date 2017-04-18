import Vapor
import HTTP

final class AuthController {
    
    struct Incoming {
        var email: Valid<Email>
        var password: Valid<Password>
        var deviceToken: Valid<Default>?
        var deviceId: Valid<Default>
        var provider: Valid<OnlyAlphanumeric>
        var facebookToken: Valid<Default>?
        
        init(request: Request, provider: ProviderType) throws {
            
            try self.provider = provider.rawValue.validated()
            
            self.email = try request.data["email"].validated()
            self.password = try request.data["password"].validated()
            self.deviceToken = try request.data["deviceToken"].validated()
            self.deviceId = try request.data["deviceId"].validated()
            self.facebookToken = try request.data["facebookToken"].validated()
            
        }
        
    }

    func signIn(request: Request) throws -> ResponseRepresentable {
        print(#function)
        let client = request.client
        
        do {
            
            let inc = try request.parseSignIn()
            
            let users = try User.query().filter("email", inc.email.value).limit(1).run().array
            guard let user = users.first, let userId = user.id else {
                return JSON(["errrrr":"usernot found"])
            }
            
            request.currentUser = user
            
            let sessions = try Session.query().filter("userId", userId).limit(1).run().array
            guard let session = sessions.first else {
                let session = try createNewSession(request: request)
            }

            //try user.save()
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

    private func createNewSession(request: Request) throws -> Session {
        var session = try Session(request: request)
        session.userId = request.currentUser?.id
        session.token = "token"
        try session.save()
        return session
    }
    
    
}

private extension Request {
    func parseSignIn() throws -> AuthController.Incoming {
        guard let _ = json else { throw Abort.badRequest }
        return try AuthController.Incoming(request: self, provider: .email)
    }
}


//extension Request {
//    func post() throws -> Post {
//        guard let json = json else { throw Abort.badRequest }
//        return try Post(node: json)
//    }
//}
