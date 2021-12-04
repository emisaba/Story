import UIKit
import Lottie

class CustomSegmentCell: UICollectionViewCell {
    
    // MARK: - Properties
    
    public var cellType: CellType = .read {
        didSet { setupAnimation(cellType: cellType) }
    }
    
    public let titleLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 14)
        label.text = "ダミー"
        return label
    }()
    
    public let imageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleToFill
        iv.backgroundColor = .systemYellow
        iv.layer.cornerRadius = 40
        return iv
    }()
    
    public let lottieAnimation = AnimationView()
    
    // MARK: - LifeCycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(titleLabel)
        titleLabel.anchor(top: topAnchor)
        titleLabel.setDimensions(height: 20, width: frame.width)
        titleLabel.centerX(inView: self)
        
        addSubview(imageView)
        imageView.anchor(top: titleLabel.bottomAnchor,
                         paddingTop: 10)
        imageView.setDimensions(height: 80, width: 80)
        imageView.centerX(inView: self)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Helper
    
    func setupAnimation(cellType: CellType) {
        switch cellType {
        case .begin:
            lottieAnimation.animation = Animation.named("begin")
        case .spin:
            lottieAnimation.animation = Animation.named("spin")
        case .read:
            lottieAnimation.animation = Animation.named("read")
        }
        
        lottieAnimation.frame = CGRect(x: -20, y: -20, width: 120, height: 120)
        lottieAnimation.contentMode = .scaleAspectFill
        lottieAnimation.loopMode = .playOnce
        lottieAnimation.play()
        imageView.addSubview(lottieAnimation)
    }
}
