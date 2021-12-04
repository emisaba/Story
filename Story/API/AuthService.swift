import Firebase

struct AuthCredentials {
    let email: String
    let password: String
    let userName: String
    let userImage: UIImage
}

struct AuthService {
    
    static func logUserIn(withEmail email: String, password: String, completion: @escaping AuthDataResultCallback) {
        Auth.auth().signIn(withEmail: email, password: password, completion: completion)
    }
    
    static func registerUser(withCredential credentials: AuthCredentials, completioin: @escaping(Error?) -> Void) {
        
        ImageUploader.uploadImage(image: credentials.userImage) { imageUrl in
            
            Auth.auth().createUser(withEmail: credentials.email, password: credentials.password) { result, error in
                if let error = error {
                    print("failed to register user: \(error.localizedDescription)")
                    return
                }
                guard let uid = result?.user.uid else { return }
                
                let data: [String: Any] = ["email": credentials.email,
                                           "password": credentials.password,
                                           "userName": credentials.userName,
                                           "userImage": imageUrl,
                                           "uid": uid]
                
                COLLECTION_USERS.document(uid).setData(data, completion: completioin)
            }
        }
    }
}


