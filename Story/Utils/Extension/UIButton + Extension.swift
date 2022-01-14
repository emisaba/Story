import UIKit

extension UIButton {
    
    static func createImageButton(target: Any, action: Selector, image: UIImage) -> UIButton {
        let button = UIButton()
        button.layer.cornerRadius = 25
        button.addTarget(target, action: action, for: .touchUpInside)
        button.setImage(image, for: .normal)
        button.contentEdgeInsets = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
        return button
    }
    
    static func createTextButton(text: String, target: Any, action: Selector) -> UIButton {
        let button = UIButton()
        button.setTitle(text, for: .normal)
        button.layer.cornerRadius = 30
        button.addTarget(target, action: action, for: .touchUpInside)
        button.contentEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 5, right: 0)
        
        let attributes: [NSAttributedString.Key: Any] = [.foregroundColor: UIColor.customGreen(), .kern: 1, .font: UIFont.yawarakadragonmini(size: 18)]
        let attributedText = NSAttributedString(string: text, attributes: attributes)
        button.setAttributedTitle(attributedText, for: .normal)
        
        return button
    }
}
