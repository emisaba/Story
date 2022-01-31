import UIKit

class ReadStoryViewController: UIViewController {
    
    // MARK: - Properties
    
    public var titleContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemBlue
        return view
    }()
    
    private lazy var categoryLabel = UILabel.createLabel(isTitle: false, text: "カテゴリ")
    private lazy var titleLabel = UILabel.createLabel(isTitle: true, text: "タイトル")
    private let contributedUsers = Countributers()
    
    public lazy var storyTextView = UITextView.createRegisterStoryTextView()
    
    private let closeButton = UIButton.createImageButton(target: self, action: #selector(didTapCloseButton), image: #imageLiteral(resourceName: "arrow-down-green"))
    
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
        view.backgroundColor = .white
        
        view.addSubview(titleLabel)
        titleLabel.anchor(top: view.safeAreaLayoutGuide.topAnchor, paddingTop: 20)
        titleLabel.centerX(inView: view)
        
        view.addSubview(contributedUsers)
        contributedUsers.anchor(left: view.leftAnchor,
                                bottom: view.safeAreaLayoutGuide.bottomAnchor,
                                right: view.rightAnchor,
                                paddingLeft: 20,
                                paddingRight: 20,
                                height: 50)
        contributedUsers.backgroundColor = .white
        
        view.addSubview(storyTextView)
        storyTextView.anchor(top: titleLabel.bottomAnchor,
                             left: view.leftAnchor,
                             bottom: contributedUsers.topAnchor,
                             right: view.rightAnchor,
                             paddingTop: 20,
                             paddingBottom: 30)
        
        view.addSubview(closeButton)
        closeButton.anchor(top: view.safeAreaLayoutGuide.topAnchor,
                           right: view.rightAnchor,
                           paddingTop: -30,
                           paddingRight: 20)
        closeButton.setDimensions(height: 50, width: 50)
    }
    
    func configureStory() {
        
        guard let category = viewModel?.category else { return }
        guard let title = viewModel?.title else { return }
        guard let story = viewModel?.stories.joined(separator: "\n\n") else { return }
        guard let contributers = viewModel?.contributers as? [URL] else { return }
        
        categoryLabel.text = category
        contributedUsers.iconImageUrls = contributers
        
        let titleAttributes: [NSAttributedString.Key: Any] = [.foregroundColor: UIColor.customGreen(),
                                                              .font: UIFont.yawarakadragonmini(size: 30),
                                                              .kern: 2.5]
        
        titleLabel.attributedText = NSAttributedString(string: title, attributes: titleAttributes)
        
        let stoeyAttributes: [NSAttributedString.Key: Any] = [.foregroundColor: UIColor.customGreen(),
                                                              .font: UIFont.banana(size: 22),
                                                              .kern: 2.5]
        
        storyTextView.attributedText = NSAttributedString(string: story, attributes: stoeyAttributes)
    }
}
