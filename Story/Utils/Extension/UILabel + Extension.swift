import UIKit

extension UILabel {
    
    static func createLabel(isTitle: Bool, text: String) -> UILabel {
        let label = UILabel()
        label.text = text
        label.textAlignment = isTitle ? .center : .left
        label.font = isTitle ? .boldSystemFont(ofSize: 20) : .systemFont(ofSize: 16)
        return label
    }
    
    static func createLabel(isTextLabel: Bool, text: String) -> UILabel {
        let label = UILabel()
        label.text = text
        label.textAlignment = .center
        label.numberOfLines = 0
        label.font = isTextLabel ? .systemFont(ofSize: 16) : .systemFont(ofSize: 12)
        return label
    }
    
    static func createLabel(text: String, size: CGFloat, alignment: NSTextAlignment) -> UILabel {
        let label = UILabel()
        label.text = text
        label.textColor = .lightGray
        label.font = .systemFont(ofSize: size)
        label.textAlignment = alignment
        
        let attributes: [NSAttributedString.Key: Any] = [.foregroundColor: UIColor.customGreen().withAlphaComponent(0.5),
                                                         .font: UIFont.banana(size: 18),
                                                         .kern: 1]
        label.attributedText = NSAttributedString(string: text, attributes: attributes)
        
        return label
    }
}
