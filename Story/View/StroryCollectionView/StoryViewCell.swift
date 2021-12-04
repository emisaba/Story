import UIKit
import SDWebImage

protocol StoryViewCellDelegateForTopViewController {
    func didSelectTopSpinCell(cell: StoryViewCell, story: [MiniStory])
}

protocol StoryViewCellDelegateForSpinViewController {
    func didSelectNextStory(cell: StoryViewCell)
}

class StoryViewCell: UICollectionViewCell {
    
    // MARK: - Properties
    
    public var delegateForTopViewController: StoryViewCellDelegateForTopViewController?
    public var delegateForSpinViewController: StoryViewCellDelegateForSpinViewController?
    
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
    
    private let containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemBlue
        return view
    }()
    
    private let textView: UITextView = {
        let tv = UITextView()
        tv.isScrollEnabled = false
        tv.isEditable = false
        tv.font = .systemFont(ofSize: 16)
        tv.contentInset = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
        tv.isUserInteractionEnabled = false
        return tv
    }()
    
    private lazy var userNameLabel = UILabel.createLabel(isTextLabel: true, text: "")
    private let userIcon: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        iv.layer.cornerRadius = 15
        iv.clipsToBounds = true
        return iv
    }()
    
    private let cardView: UIView = {
        let view = UIView()
        view.backgroundColor = .gray
        view.layer.cornerRadius = 10
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
        
        configureHorizontalUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        
        if viewModel?.isVartical == true {
            delegateForSpinViewController?.didSelectNextStory(cell: self)
        } else {
            delegateForTopViewController?.didSelectTopSpinCell(cell: self, story: story)
        }
    }
    
    // MARK: - Helper
    
    func configureHorizontalUI() {
        
        addSubview(cardView)
        cardView.anchor(top: topAnchor,
                        left: leftAnchor,
                        bottom: bottomAnchor,
                        right: rightAnchor,
                        paddingTop: 10,
                        paddingLeft: 10,
                        paddingBottom: 10,
                        paddingRight: 10)
        
        cardView.addSubview(textView)
        textView.anchor(top: cardView.topAnchor,
                        left: cardView.leftAnchor,
                        bottom: cardView.bottomAnchor,
                        right: cardView.rightAnchor,
                        paddingTop: 10,
                        paddingLeft: 10,
                        paddingBottom: 50,
                        paddingRight: 10)

        cardView.addSubview(userNameLabel)
        userNameLabel.anchor(bottom: cardView.bottomAnchor,
                             right: cardView.rightAnchor,
                             paddingBottom: 10,
                             paddingRight: 10,
                             height: 30)
        userNameLabel.backgroundColor = .systemPink

        addSubview(userIcon)
        userIcon.anchor(bottom: cardView.bottomAnchor,
                        right: userNameLabel.leftAnchor,
                        paddingBottom: 10,
                        paddingRight: 10)
        userIcon.setDimensions(height: 30, width: 30)
        userIcon.centerY(inView: userNameLabel)
    }
    
    func configureVerticalUI() {
        
        subviews.forEach { $0.removeFromSuperview() }
        
        addSubview(trianglePointer)
        trianglePointer.anchor(left: leftAnchor,
                               paddingLeft: 20)
        trianglePointer.setDimensions(height: 15, width: 15)
        trianglePointer.centerY(inView: self)
        
        addSubview(cardView)
        cardView.anchor(top: topAnchor,
                        left: trianglePointer.rightAnchor,
                        bottom: bottomAnchor,
                        right: rightAnchor,
                        paddingTop: 10, paddingLeft: 20, paddingBottom: 10, paddingRight: 10)
        
        cardView.addSubview(textView)
        textView.anchor(top: cardView.topAnchor,
                        left: cardView.leftAnchor,
                        bottom: cardView.bottomAnchor,
                        right: cardView.rightAnchor,
                        paddingTop: 10,
                        paddingLeft: 10,
                        paddingBottom: 50,
                        paddingRight: 10)

        cardView.addSubview(userNameLabel)
        userNameLabel.anchor(bottom: cardView.bottomAnchor,
                             right: cardView.rightAnchor,
                             paddingBottom: 10,
                             paddingRight: 10,
                             height: 30)
        userNameLabel.backgroundColor = .systemPink

        addSubview(userIcon)
        userIcon.anchor(bottom: cardView.bottomAnchor,
                        right: userNameLabel.leftAnchor,
                        paddingBottom: 10,
                        paddingRight: 10)
        userIcon.setDimensions(height: 30, width: 30)
        userIcon.centerY(inView: userNameLabel)

    }
    
    func configureViewModel() {
        guard let viewModel = viewModel else { return }
        textView.text = viewModel.text
        userIcon.sd_setImage(with: viewModel.icon, completed: nil)
        userNameLabel.text = viewModel.name
        cellNumber = viewModel.cellNumber
        
        trianglePointer.isHidden = viewModel.cellNumber == 0 ? false : true
    }
    
    func returnStory() -> MiniStory {
        
        let story = story[cellNumber]
        let data: [String: Any] = ["userName": story.userName,
                                   "userImage": userIcon.image ?? UIImage(),
                                   "story": story.story,
                                   "storyID": story.storyID,
                                   "lastStoryID": ""]
        
        return MiniStory(data: data)
    }
}
