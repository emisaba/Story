import UIKit
import Hero
import Firebase

class SpinStoryViewController: UIViewController {
    
    // MARK: - Properties
    
    public let categoryTitleLabel = UILabel.createLabel(text: "ダミー", size: 14, alignment: .left)
    public let categoryTitleIcon = UIImageView.createIconImageView()
    
    private let horizontalLayout: UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        return layout
    }()
    
    public lazy var topStoryCollectionView = StoryCollectionView(frame: .zero, collectionViewLayout: horizontalLayout, isVertical: false)
    
    private let verticalLayout: UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        return layout
    }()
    
    public lazy var choicesStoryCollectionView: StoryCollectionView = {
        let view = StoryCollectionView(frame: .zero, collectionViewLayout: verticalLayout, isVertical: true)
        view.delegateForSpinViewController = self
        return view
    }()
    
    private let saveButton = UIButton.createTextButton(text: "complete", target: self, action: #selector(didTapCompleteButton))
    private let addButton = UIButton.createTextButton(text: "add", target: self, action: #selector(didTapAddButton))
    private let closeButton = UIButton.createImageButton(target: self, action: #selector(didTapCloseButton))

    private lazy var actionSheet: CustomActionSheet = {
        let sheet = CustomActionSheet()
        sheet.layer.cornerRadius = 20
        sheet.backgroundColor = .white
        sheet.layer.cornerRadius = 15
        sheet.delegate = self
        return sheet
     }()
    
    private var user: User?
    
    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchUser()
        configureUI()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        
        UIView.animate(withDuration: 0.25) {
            self.actionSheet.frame.origin.y = self.view.frame.height
        }
    }
    
    // MARK: - API
    
    func fetchUser() {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        UserService.fetchUser(uid: uid) { user in
            self.user = user
        }
    }
    
    func spinStory() {
        
        let stories = topStoryCollectionView.miniStories
        
        StoryService.spinStory(miniStories: stories) { error in
            if let error = error {
                print("failed to upload stories: \(error.localizedDescription)")
                return
            }
            
            self.choicesStoryCollectionView.miniStories.removeAll()
            
            UIView.animate(withDuration: 0.25) {
                self.actionSheet.frame.origin.y = self.view.frame.height
                self.view.endEditing(true)
            }
        }
    }
    
    func fetchChoicesStories(story: MiniStory) {
        
        StoryService.fetchChoicesStories(miniStory: story) { stories in
            self.choicesStoryCollectionView.miniStories = stories
        }
    }
    
    func uploadCompleteStory(category: String, title: String) {
        
        let miniStories = topStoryCollectionView.miniStories
        let contributers = miniStories.map { $0.userImageUrl }
        let miniStoriesText = miniStories.map { $0.story }
        
        let storyInfo = StoryInfo(category: category,
                                  title: title,
                                  miniStories: miniStoriesText,
                                  contributers: contributers)
        
        StoryService.uploadCompleteStory(story: storyInfo) { error in
            if let error = error {
                print("failed to upload completeStory: \(error.localizedDescription)")
                return
            }
            
            UIView.animate(withDuration: 0.25) {
                self.actionSheet.frame.origin.y = self.view.frame.height
                self.view.endEditing(true)
            }
        }
    }
    
    // MARK: - Action
    
    @objc func didTapCloseButton() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc func didTapCompleteButton() {
        UIView.animate(withDuration: 0.25) {
            self.actionSheet.isAdd = false
            self.actionSheet.frame.origin.y -= self.actionSheet.frame.height
        }
    }
    
    @objc func didTapAddButton() {
        UIView.animate(withDuration: 0.25) {
            self.actionSheet.isAdd = true
            self.actionSheet.frame.origin.y -= self.actionSheet.frame.height
        }
    }
    
    // MARK: - Helpers
    
    func configureUI() {
        view.backgroundColor = .systemPink
        
        view.addSubview(categoryTitleLabel)
        categoryTitleLabel.anchor(top: view.safeAreaLayoutGuide.topAnchor)
        categoryTitleLabel.centerX(inView: view)
        
        view.addSubview(categoryTitleIcon)
        categoryTitleIcon.anchor(top: view.safeAreaLayoutGuide.topAnchor,
                         right: categoryTitleLabel.leftAnchor,
                         paddingRight: 10)
        categoryTitleIcon.setDimensions(height: 50, width: 50)
        categoryTitleIcon.centerY(inView: categoryTitleLabel)
        
        view.addSubview(topStoryCollectionView)
        topStoryCollectionView.anchor(top: categoryTitleIcon.bottomAnchor,
                                      left: view.leftAnchor,
                                      right: view.rightAnchor,
                                      paddingTop: 20,
                                      height: 150)
        
        view.addSubview(closeButton)
        closeButton.anchor(top: view.safeAreaLayoutGuide.topAnchor,
                           right: view.rightAnchor,
                           paddingRight: 20)
        closeButton.setDimensions(height: 50, width: 50)
        closeButton.centerY(inView: categoryTitleIcon)
    }
}

// MARK: - HeroViewControllerDelegate

extension SpinStoryViewController: HeroViewControllerDelegate {
    
    func heroDidEndTransition() {
        
        let bottomStackView = UIStackView(arrangedSubviews: [saveButton, addButton])
        bottomStackView.axis = .horizontal
        bottomStackView.distribution = .fillEqually
        
        view.addSubview(bottomStackView)
        bottomStackView.anchor(left: view.leftAnchor,
                               bottom: view.safeAreaLayoutGuide.bottomAnchor,
                               right: view.rightAnchor,
                               height: 50)
        
        view.addSubview(choicesStoryCollectionView)
        choicesStoryCollectionView.anchor(top: topStoryCollectionView.bottomAnchor,
                                          left: view.leftAnchor,
                                          bottom: bottomStackView.topAnchor,
                                          right: view.rightAnchor,
                                          paddingTop: 30)
        choicesStoryCollectionView.backgroundColor = .systemGreen
        
        view.addSubview(actionSheet)
        actionSheet.frame = CGRect(x: 0, y: view.frame.height, width: view.frame.width, height: view.frame.height)
    }
}

// MARK: - storyViewDelegateForSpinViewController

extension SpinStoryViewController: storyViewDelegateForSpinViewController {
    func didSelectNextStory(selectedCell: StoryViewCell) {
        
        let story = selectedCell.returnStory()
        topStoryCollectionView.miniStories.append(story)
        
        fetchChoicesStories(story: story)
    }
}

// MARK: - CustomActionSheetDelegate

extension SpinStoryViewController: CustomActionSheetDelegate {
    
    func completeStory(title: String, category: String) {
        uploadCompleteStory(category: category, title: title)
    }
    
    func addStory(story: String) {
        
        guard let lastStoryID = topStoryCollectionView.miniStories.last?.storyID else { return }
        guard let userName = user?.userName else { return }
        guard let userImage = user?.userImage else { return }
        
        let data:[String: Any] = ["userName": userName,
                                  "userImageUrl": userImage,
                                  "story": story,
                                  "storyID": "",
                                  "lastStoryID": lastStoryID]
        
        let story = MiniStory(data: data)
        topStoryCollectionView.miniStories.append(story)
        
        spinStory()
    }
    
    func cancel() {
        UIView.animate(withDuration: 0.25) {
            self.actionSheet.frame.origin.y = self.view.frame.height
        }
    }
}
