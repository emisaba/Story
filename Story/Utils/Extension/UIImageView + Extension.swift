import UIKit

extension UIImageView {
    
    static func createIconImageView() -> UIImageView {
        let imageView = UIImageView()
        imageView.contentMode = .scaleToFill
        imageView.backgroundColor = .systemYellow
        imageView.layer.cornerRadius = 30
        return imageView
    }
}
