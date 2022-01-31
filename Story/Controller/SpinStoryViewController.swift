import UIKit
import Hero
import Firebase

class SpinStoryViewController: UIViewController {
    
    // MARK: - Properties
    
    private let horizontalLayout: UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        return layout
    }()
    
    public lazy var topStoryCollectionView: StoryCollectionView = {
        let view = StoryCollectionView(frame: .zero, collectionViewLayout: horizontalLayout, isVertical: false)
        view.delegateForSpinViewController = self
        return view
    }()
    
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
    
    private lazy var saveButton: UIButton = {
        let button = UIButton()
        button.layer.cornerRadius = 2
        button.layer.borderColor = UIColor.white.cgColor
        button.layer.borderWidth = 1
        button.backgroundColor = .customGreen()
        button.addTarget(self, action: #selector(didTapCompleteButton), for: .touchUpInside)
        button.titleEdgeInsets = UIEdgeInsets(top: -3, left: 0, bottom: 0, right: 0)
        
        let attributes: [NSAttributedString.Key: Any] = [.foregroundColor: UIColor.white, .font: UIFont.kaisei(size: 22)]
        button.setAttributedTitle(NSAttributedString(string: "完", attributes: attributes), for: .normal)
        return button
    }()
    
    private lazy var addButton: UIButton = {
        let button = UIButton()
        button.layer.cornerRadius = 30
        button.layer.borderColor = UIColor.customGreen().cgColor
        button.layer.borderWidth = 3
        button.setImage(#imageLiteral(resourceName: "edit"), for: .normal)
        button.contentEdgeInsets = UIEdgeInsets(top: 15, left: 15, bottom: 15, right: 15)
        button.backgroundColor = .customGreen()
        button.addTarget(self, action: #selector(didTapAddButton), for: .touchUpInside)
        button.layer.shadowColor = UIColor.lightGray.cgColor
        button.layer.shadowOffset = CGSize(width: 5, height: 5)
        button.layer.shadowRadius = 10
        button.layer.shadowOpacity = 0.7
        return button
    }()
    
    private let closeButton = UIButton.createImageButton(target: self, action: #selector(didTapCloseButton), image: #imageLiteral(resourceName: "arrow"))

    private lazy var actionSheet: CustomActionSheet = {
        let sheet = CustomActionSheet()
        sheet.layer.cornerRadius = 20
        sheet.backgroundColor = .customGreen()
        sheet.layer.cornerRadius = 15
        sheet.delegate = self
        return sheet
     }()
    
    private lazy var pagesCount: UIPageControl = {
        let control = UIPageControl()
        control.numberOfPages = 1
        control.currentPage = 0
        control.pageIndicatorTintColor = .init(white: 1, alpha: 0.95)
        control.currentPageIndicatorTintColor = .customYellow()
        return control
    }()
    
    private var user: User?
    public var completeRegister: ((Bool)->Void)?
    
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
    
    func spinStory(story: String) {
        
        guard let lastStoryID = topStoryCollectionView.miniStories.last?.storyID else { return }
        guard let userName = user?.userName else { return }
        guard let userImage = user?.userImage else { return }
        
        let data:[String: Any] = ["userName": userName,
                                  "userImageUrl": userImage,
                                  "story": story,
                                  "storyID": "",
                                  "lastStoryID": lastStoryID]
        
        let newStory = MiniStory(data: data)
        var stories = topStoryCollectionView.miniStories
        stories.append(newStory)
        
        StoryService.spinStory(miniStories: stories) { error in
            if let error = error {
                print("failed to upload stories: \(error.localizedDescription)")
                return
            }
            
            self.choicesStoryCollectionView.miniStories.removeAll()
            
            UIView.animate(withDuration: 0.25) {
                self.actionSheet.frame.origin.y = self.view.frame.height
                self.view.endEditing(true)
                
                self.pagesCount.numberOfPages = stories.count
                self.pagesCount.currentPage = stories.count
                
            } completion: { _ in
                
                UIView.animate(withDuration: 0.25, delay: 0.5) {
                    self.topStoryCollectionView.miniStories.append(newStory)
                }
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
            
            self.completeRegister?(true)
            
            UIView.animate(withDuration: 0.25) {
                self.actionSheet.frame.origin.y = self.view.frame.height
                self.view.endEditing(true)
            } completion: { _ in
                self.navigationController?.popViewController(animated: false)
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
        view.backgroundColor = .customGreen()
        
        view.addSubview(topStoryCollectionView)
        topStoryCollectionView.anchor(top: view.safeAreaLayoutGuide.topAnchor,
                                      left: view.leftAnchor,
                                      right: view.rightAnchor,
                                      paddingTop: 20, height: 200)
        
        view.addSubview(closeButton)
        closeButton.anchor(top: view.safeAreaLayoutGuide.topAnchor,
                           left: view.leftAnchor,
                           paddingTop: -38,
                           paddingLeft: 20)
        closeButton.setDimensions(height: 50, width: 50)
    }
    
    func createImageButton(image: UIImage, selector: Selector) -> UIButton {
        let button = UIButton()
        button.layer.cornerRadius = 30
        button.layer.borderColor = UIColor.customGreen().cgColor
        button.layer.borderWidth = 3
        button.setImage(image, for: .normal)
        button.contentEdgeInsets = UIEdgeInsets(top: 15, left: 15, bottom: 15, right: 15)
        button.backgroundColor = .customGreen()
        button.addTarget(self, action: selector, for: .touchUpInside)
        return button
    }
}

// MARK: - HeroViewControllerDelegate

extension SpinStoryViewController: HeroViewControllerDelegate {
    
    func heroDidEndTransition() {
        
        view.addSubview(choicesStoryCollectionView)
        choicesStoryCollectionView.anchor(top: topStoryCollectionView.bottomAnchor,
                                          left: view.leftAnchor,
                                          bottom: view.bottomAnchor,
                                          right: view.rightAnchor)
        
        view.addSubview(topStoryCollectionView)
        topStoryCollectionView.anchor(top: view.safeAreaLayoutGuide.topAnchor,
                                      left: view.leftAnchor,
                                      bottom: choicesStoryCollectionView.topAnchor,
                                      right: view.rightAnchor,
                                      paddingTop: 30,
                                      paddingBottom: 40)
        
        view.addSubview(addButton)
        addButton.anchor(bottom: view.safeAreaLayoutGuide.bottomAnchor)
        addButton.setDimensions(height: 60, width: 60)
        addButton.centerX(inView: view)
        
        view.addSubview(pagesCount)
        pagesCount.anchor(left: view.leftAnchor,
                          bottom: choicesStoryCollectionView.topAnchor,
                          right: view.rightAnchor,
                          height: 35)
        
        view.addSubview(saveButton)
        saveButton.anchor(bottom: choicesStoryCollectionView.topAnchor,
                          right: view.rightAnchor,
                          paddingBottom: -20,
                          paddingRight: 20)
        saveButton.setDimensions(height: 40, width: 40)
        
        view.addSubview(actionSheet)
        actionSheet.frame = CGRect(x: 0, y: view.frame.height, width: view.frame.width, height: view.frame.height)
    }
}

// MARK: - storyViewDelegateForSpinViewController

extension SpinStoryViewController: storyViewDelegateForSpinViewController {
    func didDragPage(onPage: Int) {
        pagesCount.currentPage = onPage
    }
    
    func didSelectNextStory(selectedCell: StoryViewCell) {
        
        let story = selectedCell.returnStory()
        topStoryCollectionView.miniStories.append(story)
        
        fetchChoicesStories(story: story)
        
        pagesCount.numberOfPages += 1
        pagesCount.currentPage = topStoryCollectionView.miniStories.count - 1
    }
}

// MARK: - CustomActionSheetDelegate

extension SpinStoryViewController: CustomActionSheetDelegate {
    
    func completeStory(title: String, category: String) {
        uploadCompleteStory(category: category, title: title)
    }
    
    func addStory(story: String) {
        spinStory(story: story)
    }
    
    func cancel() {
        UIView.animate(withDuration: 0.25) {
            self.actionSheet.frame.origin.y = self.view.frame.height
        }
    }
}
