import UIKit

extension UITextField {
    
    static func createTextField(placeholder: String) -> UITextField {
        
        let textField = UITextField()
        textField.placeholder = placeholder
        textField.backgroundColor = .systemGray
        
        let leftView = UIView()
        leftView.frame = CGRect(x: 0, y: 0, width: 10, height: 50)
        
        textField.leftView = leftView
        textField.leftViewMode = .always
        
        return textField
    }
}
