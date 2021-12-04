import UIKit

extension UIButton {
    
    static func createImageButton(target: Any, action: Selector) -> UIButton {
        let button = UIButton()
        button.layer.cornerRadius = 25
        button.backgroundColor = .systemGreen
        button.addTarget(target, action: action, for: .touchUpInside)
        return button
    }
    
    static func createTextButton(text: String, target: Any, action: Selector) -> UIButton {
        let button = UIButton()
        button.setTitle(text, for: .normal)
        button.setTitleColor(.systemBlue, for: .normal)
        button.layer.cornerRadius = 30
        button.addTarget(target, action: action, for: .touchUpInside)
        return button
    }
}
