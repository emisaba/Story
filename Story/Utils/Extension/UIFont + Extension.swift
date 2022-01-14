import UIKit

extension UIFont {
    static func gaeguBold(size: CGFloat) -> UIFont {
        return UIFont(name: "Gaegu-Bold", size: size) ?? .systemFont(ofSize: size)
    }
    
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
    
    static func mamelon(size: CGFloat) -> UIFont {
        return UIFont(name: "Mamelon-5-Hi-Regular", size: size) ?? .systemFont(ofSize: size)
    }
    
    static func yawarakadragonmini(size: CGFloat) -> UIFont {
        return UIFont(name: "yawarakadragonmini", size: size) ?? .systemFont(ofSize: size)
    }
    
    static func KaiseiOpti(size: CGFloat) -> UIFont {
        return UIFont(name: "KaiseiOpti-Bold", size: size) ?? .systemFont(ofSize: size)
    }
    
//    static func komadori(size: CGFloat) -> UIFont {
//        return UIFont(name: "KaiseiOpti-Bold", size: size) ?? .systemFont(ofSize: size)
//    }
}
