import UIKit

extension UITextField {
    
    static func createTextField(placeholder: String) -> UITextField {
        
        let textField = UITextField()
        
        let leftView = UIView()
        leftView.frame = CGRect(x: 0, y: 0, width: 10, height: 50)
        
        textField.leftView = leftView
        textField.leftViewMode = .always
        textField.backgroundColor = .customGreen()
        
        let textviewAttributes: [NSAttributedString.Key: Any] = [.foregroundColor: UIColor.white.withAlphaComponent(0.3),
                                                                 .font: UIFont.KaiseiOpti(size: 18),
                                                                 .kern: 1]
        textField.attributedPlaceholder = NSAttributedString(string: placeholder, attributes: textviewAttributes)
        
        return textField
    }
}
