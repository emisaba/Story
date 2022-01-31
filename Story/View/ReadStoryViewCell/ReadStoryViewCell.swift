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
    private lazy var storyLabel = UILabel.createLabel(isTitle: false, text: "")
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
                             paddingRight: 20,
                             height: 25)
        
        addSubview(titleLabel)
        titleLabel.anchor(top: categoryLabel.bottomAnchor
                          ,left: categoryLabel.leftAnchor,
                          paddingTop: 10,
                          paddingLeft: -10,
                          height: 30)
        
        addSubview(storyLabel)
        storyLabel.anchor(top: titleLabel.bottomAnchor,
                          left: leftAnchor,
                          right: rightAnchor,
                          paddingTop: 20,
                          paddingLeft: 20,
                          paddingRight: 20)
        
        addSubview(contributedUsers)
        contributedUsers.anchor(left: leftAnchor,
                                bottom: bottomAnchor,
                                right: rightAnchor,
                                paddingLeft: 20,
                                paddingBottom: 0,
                                paddingRight: 20,
                                height: 50)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
     
    // MARK: - Helpers
    
    func configureViewModel() {
        guard let viewModel = viewModel else { return }
        
        let sharpAttributes: [NSAttributedString.Key: Any] = [.foregroundColor: UIColor.customGreen(),
                                                              .kern: 1]
        let categoryAttributes: [NSAttributedString.Key: Any] = [.foregroundColor: UIColor.customGreen(),
                                                                 .font: UIFont.yawarakadragonmini(size: 14),
                                                                 .kern: 0]
        let categoryText = NSMutableAttributedString(string: "# ", attributes: sharpAttributes)
        categoryText.append(NSAttributedString(string: viewModel.category, attributes: categoryAttributes))
        categoryLabel.attributedText = categoryText
        
        let titleAttributes: [NSAttributedString.Key: Any] = [.foregroundColor: UIColor.customGreen(),
                                                              .font: UIFont.yawarakadragonmini(size: 30),
                                                              .kern: 2]
        titleLabel.attributedText = NSAttributedString(string: viewModel.title, attributes: titleAttributes)
        
        let storyAttributes: [NSAttributedString.Key: Any] = [.foregroundColor: UIColor.customGreen().withAlphaComponent(0.6),
                                                              .font: UIFont.banana(size: 18),
                                                              .kern: 1]
        storyLabel.attributedText = NSAttributedString(string: viewModel.fullStory, attributes: storyAttributes)
        storyLabel.numberOfLines = 2
    }
}
