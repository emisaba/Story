import UIKit

class ReadStoryViewCell: UICollectionViewCell {
    
    // MARK: - Properties
    
    public var viewModel: StoryViewModel? {
        didSet {
            configureViewModel()
            
            guard let urls = viewModel?.contributers as? [URL] else { return }
            contributedUsers.iconImageUrls = urls
        }
    }
    
    private lazy var categoryLabel = UILabel.createLabel(isTitle: false, text: "")
    private lazy var titleLabel = UILabel.createLabel(isTitle: true, text: "")
    private let contributedUsers = Countributers()
    
    // MARK: - LifeCycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        
        addSubview(categoryLabel)
        categoryLabel.anchor(top: topAnchor,
                             left: leftAnchor,
                             right: rightAnchor,
                             paddingTop: 20,
                             paddingLeft: 20,
                             height: 25)
        
        addSubview(titleLabel)
        titleLabel.centerY(inView: self)
        titleLabel.centerX(inView: self)
        
        addSubview(contributedUsers)
        contributedUsers.anchor(top: titleLabel.bottomAnchor,
                                bottom: bottomAnchor,
                                right: rightAnchor,
                                paddingBottom: 10,
                                paddingRight: 10)
        contributedUsers.setDimensions(height: 50, width: frame.width / 2)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
     
    // MARK: - Helpers
    
    func configureViewModel() {
        guard let viewModel = viewModel else { return }
        
        let categoryAttributes: [NSAttributedString.Key: Any] = [.foregroundColor: UIColor.customGreen(),
                                                                 .font: UIFont.pierSansRegular(size: 18),
                                                                 .kern: 1]
        categoryLabel.attributedText = NSAttributedString(string: viewModel.category, attributes: categoryAttributes)
        
        let titleAttributes: [NSAttributedString.Key: Any] = [.foregroundColor: UIColor.customGreen(),
                                                              .font: UIFont.pierSansBold(size: 28),
                                                              .kern: 2]
        titleLabel.attributedText = NSAttributedString(string: viewModel.title, attributes: titleAttributes)
    }
}
