import UIKit

extension UIFont {
    
    static func gaeguRegular(size: CGFloat) -> UIFont {
        return UIFont(name: "Gaegu-Regular", size: size) ?? .systemFont(ofSize: size)
    }
    
    static func pierSansRegular(size: CGFloat) -> UIFont {
        return UIFont(name: "PierSans-Regular", size: size) ?? .systemFont(ofSize: size)
    }
    
    static func pierSansBold(size: CGFloat) -> UIFont {
        return UIFont(name: "PierSans-Bold", size: size) ?? .systemFont(ofSize: size)
    }
    
    static func pierSansLight(size: CGFloat) -> UIFont {
        return UIFont(name: "PierSans-Light", size: size) ?? .systemFont(ofSize: size)
    }
    
    static func yawarakadragonmini(size: CGFloat) -> UIFont {
        return UIFont(name: "yawarakadragonmini", size: size) ?? .systemFont(ofSize: size)
    }
    
    static func banana(size: CGFloat) -> UIFont {
        return UIFont(name: "bananaslipplus", size: size) ?? .systemFont(ofSize: size)
    }
    
    static func senobi(size: CGFloat) -> UIFont {
        return UIFont(name: "Senobi-Gothic-Bold", size: size) ?? .systemFont(ofSize: size)
    }
    
    static func kaisei(size: CGFloat) -> UIFont {
        return UIFont(name: "KaiseiOpti-Bold", size: size) ?? .systemFont(ofSize: size)
    }
}
