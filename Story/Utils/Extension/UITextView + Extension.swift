import UIKit

extension UITextView {
    
    static func createRegisterStoryTextView() -> UITextView {
        let tv = UITextView()
        tv.textContainerInset = UIEdgeInsets(top: 15, left: 10, bottom: 10, right: 10)
        tv.layer.cornerRadius = 20
        return tv
    }
}
