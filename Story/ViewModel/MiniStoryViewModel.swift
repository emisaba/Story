import UIKit

class MiniStoryViewModel {
    
    let story: MiniStory
    let cellNumber: Int
    let isVartical: Bool
    
    var text: String {
        return story.story
    }
    
    var icon: URL? {
        return URL(string: story.userImageUrl)
    }
    
    var name: String {
        return story.userName
    }
    
    init(story: MiniStory, cellNumber: Int, isVartical: Bool) {
        self.story = story
        self.cellNumber = cellNumber
        self.isVartical = isVartical
    }
}
