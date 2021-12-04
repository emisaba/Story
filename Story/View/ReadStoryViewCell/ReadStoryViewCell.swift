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
    
    private lazy var categoryLabel = UILabel.createLabel(isTitle: false, text: "カテゴリ")
    private lazy var titleLabel = UILabel.createLabel(isTitle: true, text: "タイトル")
    private let contributedUsers = Countributers()
    
    // MARK: - LifeCycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(categoryLabel)
        categoryLabel.anchor(top: topAnchor,
                             left: leftAnchor,
                             right: rightAnchor,
                             height: 20)
        
        addSubview(titleLabel)
        titleLabel.anchor(left: leftAnchor,
                          right: rightAnchor,
                          height: 70)
        
        addSubview(contributedUsers)
        contributedUsers.anchor(top: titleLabel.bottomAnchor,
                                bottom: bottomAnchor,
                                right: rightAnchor,
                                paddingRight: 10)
        contributedUsers.setDimensions(height: 50, width: frame.width / 2)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
     
    // MARK: - Helpers
    
    func configureViewModel() {
        guard let viewModel = viewModel else { return }
        
        categoryLabel.text = viewModel.category
        titleLabel.text = viewModel.title
    }
}
