import UIKit
import SDWebImage

class StoryViewCell: UICollectionViewCell {
    
    // MARK: - Properties
    
    public var viewModel: MiniStoryViewModel? {
        didSet {
            
            if viewModel?.isVartical == true {
                configureVerticalUI()
            } else {
                configureHorizontalUI()
            }
            configureViewModel()
        }
    }
    
    private let textView: UITextView = {
        let tv = UITextView()
        tv.isScrollEnabled = false
        tv.isEditable = false
        tv.font = .systemFont(ofSize: 16)
        tv.contentInset = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 0)
        tv.isUserInteractionEnabled = false
        return tv
    }()
    
    private lazy var userNameLabel = UILabel.createLabel(isTextLabel: true, text: "")
    private let userIcon: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        iv.clipsToBounds = true
        return iv
    }()
    
    private let cardView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 20
        return view
    }()
    
    private let trianglePointer: TrianglePointer = {
        let pointer = TrianglePointer()
        pointer.backgroundColor = .clear
        pointer.isHidden = true
        return pointer
    }()
    
    override var isSelected: Bool {
        didSet { trianglePointer.isHidden = isSelected ? false : true }
    }
    
    public var story: [MiniStory] = []
    private var cellNumber: Int = 0
    
    // MARK: - LifeCycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .clear
        configureHorizontalUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let height = textView.sizeThatFits(CGSize(width: textView.frame.size.width,
                                                  height: CGFloat.greatestFiniteMagnitude)).height
        textView.heightAnchor.constraint(equalToConstant: height).isActive = true
    }
    
    // MARK: - Helper
    
    func configureHorizontalUI() {
        
        addSubview(cardView)
        cardView.anchor(top: topAnchor,
                        left: leftAnchor,
                        bottom: bottomAnchor,
                        right: rightAnchor,
                        paddingTop: 15,
                        paddingLeft: 20,
                        paddingBottom: 15,
                        paddingRight: 20)
        
        cardView.addSubview(textView)
        textView.anchor(top: cardView.topAnchor,
                        left: cardView.leftAnchor,
                        bottom: cardView.bottomAnchor,
                        right: cardView.rightAnchor,
                        paddingTop: 15,
                        paddingLeft: 15,
                        paddingBottom: 55,
                        paddingRight: 15)
        textView.contentInset = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 0)

        cardView.addSubview(userNameLabel)
        userNameLabel.anchor(bottom: cardView.bottomAnchor,
                             right: cardView.rightAnchor,
                             paddingBottom: 15,
                             paddingRight: 20,
                             height: 30)

        addSubview(userIcon)
        userIcon.anchor(bottom: cardView.bottomAnchor,
                        right: userNameLabel.leftAnchor,
                        paddingBottom: 15,
                        paddingRight: 15)
        userIcon.setDimensions(height: 36, width: 36)
        userIcon.centerY(inView: userNameLabel)
    }
    
    func configureVerticalUI() {
        subviews.forEach { $0.removeFromSuperview() }
        
        addSubview(trianglePointer)
        trianglePointer.anchor(left: leftAnchor,
                               paddingLeft: 20)
        trianglePointer.setDimensions(height: 15, width: 15)
        trianglePointer.centerY(inView: self)
        
        let shadowView = UIView()
        shadowView.layer.shadowColor = UIColor.lightGray.cgColor
        shadowView.layer.shadowOffset = CGSize(width: 5, height: 5)
        shadowView.layer.shadowRadius = 10
        shadowView.layer.shadowOpacity = 0.7
        shadowView.backgroundColor = .customGreen()
        
        addSubview(shadowView)
        shadowView.anchor(top: topAnchor,
                          left: trianglePointer.rightAnchor,
                          bottom: bottomAnchor,
                          right: rightAnchor,
                          paddingTop: 16,
                          paddingLeft: 16,
                          paddingBottom: 25,
                          paddingRight: 21)
        
        addSubview(cardView)
        cardView.anchor(top: topAnchor,
                        left: trianglePointer.rightAnchor,
                        bottom: bottomAnchor,
                        right: rightAnchor,
                        paddingTop: 10,
                        paddingLeft: 10,
                        paddingBottom: 20,
                        paddingRight: 15)
        
        cardView.addSubview(textView)
        textView.anchor(top: cardView.topAnchor,
                        left: cardView.leftAnchor,
                        bottom: cardView.bottomAnchor,
                        right: cardView.rightAnchor,
                        paddingTop: 10,
                        paddingLeft: 10,
                        paddingBottom: 50,
                        paddingRight: 10)
        textView.contentInset = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 0)

        cardView.addSubview(userNameLabel)
        userNameLabel.anchor(bottom: cardView.bottomAnchor,
                             right: cardView.rightAnchor,
                             paddingBottom: 10,
                             paddingRight: 15,
                             height: 30)

        addSubview(userIcon)
        userIcon.anchor(bottom: cardView.bottomAnchor,
                        right: userNameLabel.leftAnchor,
                        paddingBottom: 10,
                        paddingRight: 10)
        userIcon.setDimensions(height: 36, width: 36)
        userIcon.centerY(inView: userNameLabel)

    }
    
    func configureViewModel() {
        guard let viewModel = viewModel else { return }
        
        userIcon.sd_setImage(with: viewModel.icon, completed: nil)
        cellNumber = viewModel.cellNumber
        
        let textviewAttributes: [NSAttributedString.Key: Any] = [.foregroundColor: UIColor.customGreen(),
                                                                 .font: UIFont.banana(size: 18),
                                                                 .kern: 1]
        textView.attributedText = NSAttributedString(string: viewModel.text, attributes: textviewAttributes)
        
        let usernameAttributes: [NSAttributedString.Key: Any] = [.foregroundColor: UIColor.customGreen(),
                                                                 .font: UIFont.banana(size: 16),
                                                                 .kern: 1]
        userNameLabel.attributedText = NSAttributedString(string: viewModel.name, attributes: usernameAttributes)
        
        trianglePointer.isHidden = viewModel.cellNumber == 0 ? false : true
    }
    
    func returnStory() -> MiniStory {
        
        let story = story[cellNumber]
        let data: [String: Any] = ["userName": story.userName,
                                   "userImageUrl": story.userImageUrl,
                                   "story": story.story,
                                   "storyID": story.storyID,
                                   "lastStoryID": ""]
        
        return MiniStory(data: data)
    }
}
