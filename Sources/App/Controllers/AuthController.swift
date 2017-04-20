import Vapor
import HTTP

final class AuthController {
    
    enum AuthType {
        case signIn, signUp, fb
    }
    
    struct Incoming {
        var deviceId: Valid<Default>
        var provider: Valid<OnlyAlphanumeric>
        
        // Optional
        var email: Valid<Email>?
        var password: Valid<Password>?
        var deviceToken: Valid<Default>?
        var facebookToken: Valid<Default>?
        var username: Valid<OnlyAlphanumeric>?
        
        init(request: Request, provider: ProviderType, authType: AuthType) throws {
            
            self.provider = try provider.rawValue.validated()
            self.deviceToken = try request.data["deviceToken"].validated()
            self.deviceId = try request.data["deviceId"].validated()

            switch authType {
            case .signIn:
                self.email = try request.data["email"].validated()
                self.password = try request.data["password"].validated()
                break
                
            case .signUp:
                self.email = try request.data["email"].validated()
                self.password = try request.data["password"].validated()
                self.username = try request.data["username"].validated()
                break
                
            case .fb:
                self.facebookToken = try request.data["facebookToken"].validated()
                break
            }
            
            
        }
        
    }

    func signIn(request: Request) throws -> ResponseRepresentable {
        print(#function)
        let client = request.client
        
        do {
            
            let inc = try request.parseSignInObject()
            
            let users = try User.query().filter("email", inc.email!.value).limit(1).run().array
            guard let user = users.first, let userId = user.id else {
                return JSON(["errrrr":"usernot found"])
            }
            
            request.currentUser = user
            
            let sessions = try Session.query().filter("userId", userId).limit(1).run().array
//            guard let session = sessions.first else {
//                let ses = try createNewSession(request: request)
//            }

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
    func parseSignInObject() throws -> AuthController.Incoming {
        guard let _ = json else { throw Abort.badRequest }
        return try AuthController.Incoming(request: self, provider: .email, authType: .signIn)
    }
    
    func parseSignUpObject() throws -> AuthController.Incoming {
        guard let _ = json else { throw Abort.badRequest }
        return try AuthController.Incoming(request: self, provider: .email, authType: .signUp)
    }
    
    func parseFbObject() throws -> AuthController.Incoming {
        guard let _ = json else { throw Abort.badRequest }
        return try AuthController.Incoming(request: self, provider: .email, authType: .fb)
    }
}


//extension Request {
//    func post() throws -> Post {
//        guard let json = json else { throw Abort.badRequest }
//        return try Post(node: json)
//    }
//}
