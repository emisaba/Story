import UIKit

extension UITextView {
    
    static func createRegisterStoryTextView() -> UITextView {
        let tv = UITextView()
        tv.backgroundColor = .systemBlue
        tv.font = .systemFont(ofSize: 16)
        tv.contentInset = UIEdgeInsets(top: 10, left: 0, bottom: 10, right: 0)
        return tv
    }
}
