import UIKit
import FirebaseFirestore
import Firebase

struct StoryService {
    
    static func uploadMiniStory(miniStory: String, completion: @escaping (Error?) -> Void) {
        guard let currentUser = Auth.auth().currentUser else { return }
        
        UserService.fetchUser(uid: currentUser.uid) { user in
            let docRef = COLLECTION_MINISTORY.document()
            
            let data: [String: Any] = ["userName": user.userName,
                                       "userImageUrl": user.userImage,
                                       "story": miniStory,
                                       "storyID": docRef.documentID,
                                       "lastStoryID": "",
                                       "timestamp": Timestamp()]
            
            docRef.setData(data, completion: completion)
        }
    }
    
    static func fetchUserStartStories(completion: @escaping ([MiniStory]) -> Void) {
        
    }
    
    static func fetchMiniStories(completion: @escaping([MiniStory]) -> Void) {
        
        COLLECTION_MINISTORY.order(by: "timestamp", descending: true)
            .getDocuments { snapshot, error in
                
                if let error = error {
                    print("fetch story error: \(error.localizedDescription)")
                    return
                }
                
                guard let document = snapshot?.documents else { return }
                let miniStories = document.map { MiniStory(data: $0.data()) }
                
                var firstStories: [MiniStory] = []
                
                miniStories.forEach { story in
                    if story.lastStoryID == "" {
                        firstStories.append(story)
                    }
                }
                
                completion(firstStories)
            }
    }
    
    static func fetchChoicesStories(miniStory: MiniStory, completion: @escaping([MiniStory]) -> Void) {
        
        COLLECTION_MINISTORY
            .whereField("lastStoryID", isEqualTo: miniStory.storyID)
            .getDocuments { snapshot, error in
                
                if let error = error {
                    print("failed to fetchChoicesStories: \(error.localizedDescription)")
                    return
                }
                
                guard let document = snapshot?.documents else { return }
                let stories = document.map { MiniStory(data: $0.data()) }
                
                completion(stories)
            }
    }
    
    static func spinStory(miniStories: [MiniStory], completion: @escaping(Error?) -> Void) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        let storyIDs = miniStories.map { $0.storyID }
        let docRef = COLLECTION_INCOMPLETED_STORY.document()
        let data: [String: Any] = ["storyIDs": storyIDs,
                                   "storyID": docRef.documentID,
                                   "timestamp": Timestamp()]
        
        docRef.setData(data) { error in
            if let error = error {
                print("failed to upload stories: \(error.localizedDescription)")
                return
            }
            
            guard let story = miniStories.last else { return }
            let docRef = COLLECTION_MINISTORY.document()
            
            
            UserService.fetchUser(uid: uid) { user in
                let data: [String: Any] = ["userName": user.userName,
                                           "userImageUrl": user.userImage,
                                           "story": story.story,
                                           "storyID": docRef.documentID,
                                           "lastStoryID": story.lastStoryID ?? "",
                                           "timestamp": Timestamp()]
                
                docRef.setData(data, completion: completion)
            }
        }
    }
    
    static func uploadCompleteStory(story: StoryInfo, completion: @escaping (Error?) -> Void) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        let data: [String: Any] = ["category": story.category,
                                   "title": story.title,
                                   "stories": story.miniStories,
                                   "contributers": story.contributers,
                                   "uid": uid,
                                   "timestamp": Timestamp()]
        
        COLLECTION_COMPLETED_STORY.addDocument(data: data, completion: completion)
    }
    
    static func fetchCompleteStory(completion: @escaping (([Story]) -> Void)) {
        
        COLLECTION_COMPLETED_STORY.order(by: "timestamp", descending: true)
            .getDocuments { snapshot, error in
                
            if let error = error {
                print("failed to fetch completeStory: \(error.localizedDescription)")
            }
            
            guard let documents = snapshot?.documents else { return }
            let stories = documents.map { Story(data: $0.data()) }
            
            completion(stories)
        }
    }
    
    static func fetchUserInvolvedCompleteStory(completion: @escaping([Story]) -> Void) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        COLLECTION_COMPLETED_STORY.whereField("uid", isEqualTo: uid).getDocuments { snapshot, error in
            if let error = error {
                print("failed to fetch completeStory: \(error.localizedDescription)")
                return
            }
            guard let documents = snapshot?.documents else { return }
            let stories = documents.map { Story(data: $0.data()) }
            
            completion(stories)
        }
    }
}
