import UIKit
import SDWebImage

class ContributersCell: UICollectionViewCell {
    
    // MARK: - Properties
    
    public var iconImageUrl: URL? {
        didSet { imageView.sd_setImage(with: iconImageUrl, completed: nil) }
    }
    
    private let imageView: UIImageView = {
        let iv = UIImageView()
        iv.clipsToBounds = true
        return iv
    }()
    
    // MARK: - LifeCycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(imageView)
        imageView.fillSuperview()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
