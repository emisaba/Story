import UIKit
import SDWebImage

class ContributersCell: UICollectionViewCell {
    
    // MARK: - Properties
    
    public var iconImageUrl: URL? {
        didSet { imageView.sd_setImage(with: iconImageUrl, completed: nil) }
    }
    
    private let imageView: UIImageView = {
        let iv = UIImageView()
        iv.backgroundColor = .systemBlue
        iv.layer.cornerRadius = 25
        iv.layer.borderWidth = 1
        iv.layer.borderColor = UIColor.white.cgColor
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
