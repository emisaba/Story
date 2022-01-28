import UIKit

struct StoryViewModel {
    let story: Story
    
    var category: String {
        return story.category
    }
    
    var title: String {
        return story.title
    }
    
    var stories: [String] {
        return story.stories
    }
    
    var fullStory: String {
        return stories.joined()
    }
    
    var contributers: [URL?] {
        let urls = story.contributers.map { URL(string: $0) }
        return urls
    }
    
    init(story: Story) {
        self.story = story
    }
}
