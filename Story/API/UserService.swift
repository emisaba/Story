import UIKit

struct UserService {
    
    static func fetchUser(uid: String, completion: @escaping(User) -> Void) {
        COLLECTION_USERS.document(uid).getDocument { snapshot, error in
            guard let document = snapshot?.data() else { return }
            let user = User(data: document)
            completion(user)
        }
    }
}
