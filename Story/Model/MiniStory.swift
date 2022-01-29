import UIKit
import Firebase

struct MiniStory {
    let userName: String
    let userImage: UIImage
    let userImageUrl: String
    let story: String
    let storyID: String
    let lastStoryID: String?
    let timestamp: Timestamp
    
    init(data: [String: Any]) {
        self.userName = data["userName"] as? String ?? ""
        self.userImage = data["userImage"] as? UIImage ?? UIImage()
        self.userImageUrl = data["userImageUrl"] as? String ?? ""
        self.story = data["story"] as? String ?? ""
        self.storyID = data["storyID"] as? String ?? ""
        self.lastStoryID = data["lastStoryID"] as? String ?? ""
        self.timestamp = data["timestamp"] as? Timestamp ?? Timestamp()
    }
}
