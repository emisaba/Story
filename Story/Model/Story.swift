import UIKit
import Firebase

struct Story {
    let category: String
    let title: String
    let stories: [String]
    let contributers: [String]
    let uid: String
    let timeStamp: Timestamp
    
    init(data: [String: Any]) {
        self.category = data["category"] as? String ?? ""
        self.title = data["title"] as? String ?? ""
        self.stories = data["stories"] as? [String] ?? [""]
        self.contributers = data["contributers"] as? [String] ?? [""]
        self.uid = data["uid"] as? String ?? ""
        self.timeStamp = data["timeStamp"] as? Timestamp ?? Timestamp()
    }
}
