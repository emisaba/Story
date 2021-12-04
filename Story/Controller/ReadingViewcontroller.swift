import UIKit

class ReadStoryViewController: UIViewController {
    
    // MARK: - Properties
    
    public let categoryTitleLabel = UILabel.createLabel(text: "ダミー", size: 14, alignment: .left)
    public let categoryTitleIcon = UIImageView.createIconImageView()
    
    public var titleContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemBlue
        return view
    }()
    
    private lazy var categoryLabel = UILabel.createLabel(isTitle: false, text: "カテゴリ")
    private lazy var titleLabel = UILabel.createLabel(isTitle: true, text: "タイトル")
    private let contributedUsers = Countributers()
    
    public lazy var storyTextView: UITextView = {
        let tv = UITextView()
        tv.isEditable = false
        tv.font = .systemFont(ofSize: 20)
        tv.backgroundColor = .systemPurple
        return tv
    }()
    
    private let closeButton = UIButton.createImageButton(target: self, action: #selector(didTapCloseButton))
    
    public var viewModel: StoryViewModel? {
        didSet { configureStory() }
    }
    
    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
    }
    
    // MARK: - Action
    
    @objc func didTapCloseButton() {
        navigationController?.popViewController(animated: true)
    }
    
    // MARK: - Helpers
    
    func configureUI() {
        view.backgroundColor = .systemGray
        
        view.addSubview(categoryTitleLabel)
        categoryTitleLabel.anchor(top: view.safeAreaLayoutGuide.topAnchor)
        categoryTitleLabel.centerX(inView: view)
        
        view.addSubview(categoryTitleIcon)
        categoryTitleIcon.anchor(top: view.safeAreaLayoutGuide.topAnchor,
                         right: categoryTitleLabel.leftAnchor,
                         paddingRight: 10)
        categoryTitleIcon.setDimensions(height: 50, width: 50)
        categoryTitleIcon.centerY(inView: categoryTitleLabel)
        
        view.addSubview(titleContainerView)
        titleContainerView.anchor(top: categoryTitleIcon.bottomAnchor,
                                  left: view.leftAnchor,
                                  right: view.rightAnchor,
                                  paddingTop: 20,
                                  height: 140)
        
        titleContainerView.addSubview(categoryLabel)
        categoryLabel.anchor(top: titleContainerView.topAnchor,
                             left: titleContainerView.leftAnchor,
                             right: titleContainerView.rightAnchor,
                             height: 20)
        
        titleContainerView.addSubview(titleLabel)
        titleLabel.anchor(left: titleContainerView.leftAnchor,
                          right: titleContainerView.rightAnchor,
                          height: 70)
        
        titleContainerView.addSubview(contributedUsers)
        contributedUsers.anchor(top: titleLabel.bottomAnchor,
                                bottom: titleContainerView.bottomAnchor,
                                right: titleContainerView.rightAnchor,
                                paddingRight: 10)
        contributedUsers.setDimensions(height: 50, width: view.frame.width / 2)
        contributedUsers.backgroundColor = .white
        
        view.addSubview(storyTextView)
        storyTextView.anchor(top: titleContainerView.bottomAnchor,
                             left: view.leftAnchor,
                             bottom: view.bottomAnchor,
                             right: view.rightAnchor,
                             paddingTop: 30)
        
        view.addSubview(closeButton)
        closeButton.anchor(top: view.safeAreaLayoutGuide.topAnchor,
                           right: view.rightAnchor,
                           paddingRight: 20)
        closeButton.setDimensions(height: 50, width: 50)
        closeButton.centerY(inView: categoryTitleIcon)
    }
    
    func configureStory() {
        
        guard let category = viewModel?.category else { return }
        guard let title = viewModel?.title else { return }
        guard let story = viewModel?.stories.joined(separator: " ") else { return }
        guard let contributers = viewModel?.contributers as? [URL] else { return }
        
        categoryLabel.text = category
        titleLabel.text = title
        storyTextView.text = story
        contributedUsers.iconImageUrls = contributers
    }
}
