import UIKit

struct User {
    let userName: String
    let userImage: String
    
    init(data: [String: Any]) {
        self.userName = data["userName"] as? String ?? ""
        self.userImage = data["userImage"] as? String ?? ""
    }
}
