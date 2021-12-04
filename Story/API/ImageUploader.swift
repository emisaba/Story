import UIKit
import FirebaseStorage

struct         ImageUploader {
    
    static func uploadImage(image: UIImage, completion: @escaping((String) -> Void)) {
        
        guard let data = image.jpegData(compressionQuality: 0.75) else { return }
        let filename = UUID().uuidString
        
        let ref = Storage.storage().reference(withPath: "user_image/\(filename)")
        
        ref.putData(data, metadata: nil) { _, error in
            if let error = error {
                print("failed to upload image: \(error.localizedDescription)")
                return
            }
            
            ref.downloadURL { imageUrl, _ in
                guard let urlString = imageUrl?.absoluteString else { return }
                completion(urlString)
            }
        }
    }
}
