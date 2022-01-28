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
        button.addTarget(target, action: action, for: .touchUpInside)
        button.layer.cornerRadius = 20
        button.backgroundColor = .customLightOrange()
        
        let attributes: [NSAttributedString.Key: Any] = [.foregroundColor: UIColor.customGreen(), .kern: 1, .font: UIFont.senobi(size: 20)]
        let attributedText = NSAttributedString(string: text, attributes: attributes)
        button.setAttributedTitle(attributedText, for: .normal)
        
        return button
    }
}
