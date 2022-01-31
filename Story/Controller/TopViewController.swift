import UIKit
import Hero
import Firebase

class TopViewController: UIViewController {
    
    // MARK: - Properties
    
    private lazy var segmentControl: CustomSegmentControl = {
        let view = CustomSegmentControl()
        view.delegate = self
        return view
    }()
    
    public lazy var topCollectionView: TopCollectionView = {
        let view = TopCollectionView(frame: .zero, cellType: .read)
        view.delegate = self
        return view
    }()
    
    private var stories: [Story] = [] {
        didSet {
            self.topCollectionView.stories = stories
            self.topCollectionView.collectionView.reloadData()
        }
    }
    
    private let myPageButton = UIButton.createImageButton(target: self, action: #selector(didTapMyPageButton), image: #imageLiteral(resourceName: "arrow"))
    private let mypageButtonBaseView = UIView.createButtonBaseView(isTop: false)
    
    public var didStoryRegister = false {
        didSet { fetchStories() }
    }
    
    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        checkIfUserIsLoggedIn()
        fetchStories()
        configureUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = true
    }
    
    // MARK: - API
    
    func uploadStory(cell: BeginStoryViewCell) {
        guard let miniStory = cell.textView.text else { return }
        
        StoryService.uploadMiniStory(miniStory: miniStory) { error in
            if let error = error {
                print("failed to upload: \(error.localizedDescription)")
                return
            }
            self.updateUIafterRegist(cell: cell)
        }
    }
    
    func fetchStories() {
        StoryService.fetchCompleteStory { stories in
            self.stories = stories
            
            if self.didStoryRegister {
                self.segmentControl.afterRegisterStory()
                self.createTopCollectionView(cellType: .read)
                self.didStoryRegister = false
            }
        }
    }
    
    // MARK: - Actions
    
    @objc func didTapMyPageButton() {
        mypageButtonBaseView.hero.id = "fromButtonToView"
        myPageButton.hero.id = "fromButtonToButton"
        
        let vc = MypageViewController()
        vc.modalPresentationStyle = .fullScreen
        vc.view.hero.id = "fromButtonToView"
        vc.userIcon.hero.id = "fromButtonToButton"
        vc.isHeroEnabled = true
        
        present(vc, animated: true, completion: nil)
    }
    
    // MARK: - Helpers
    
    func checkIfUserIsLoggedIn() {
        let currentUser = Auth.auth().currentUser
        
        if currentUser == nil {
            DispatchQueue.main.async {
                let vc = LoginViewController()
                let nv = UINavigationController(rootViewController: vc)
                nv.modalPresentationStyle = .fullScreen
                self.present(nv, animated: false, completion: nil)
            }
        }
    }
    
    func createTopCollectionView(cellType: CellType) {
        
        let selectedView = TopCollectionView(frame: .zero, cellType: cellType)
        selectedView.delegate = self
        
        view.addSubview(selectedView)
        selectedView.anchor(top: segmentControl.bottomAnchor,
                            left: view.leftAnchor,
                            bottom: view.bottomAnchor,
                            right: view.rightAnchor)
        
        if cellType == .read { selectedView.stories = stories }
    }
    
    func updateUIafterRegist(cell: BeginStoryViewCell) {
        let avatarCell = cell
        
        avatarCell.frame = CGRect(x: 0,
                                  y: topCollectionView.frame.origin.y,
                                  width: view.frame.width,
                                  height: cell.frame.height)
        view.addSubview(avatarCell)
        
        UIView.animate(withDuration: 0.25) {
            avatarCell.registerButton.isHidden = true
            avatarCell.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
            avatarCell.frame.origin.y -= 230
            
        } completion: { _ in
            avatarCell.removeFromSuperview()
            
            let indexPath = IndexPath(item: 1, section: 0)
            self.segmentControl.collectionView.selectItem(at: indexPath, animated: true, scrollPosition: .centeredHorizontally)
            self.segmentControl.movePointer(selectedCell: 1)
            self.createTopCollectionView(cellType: .spin)
        }
    }
    
    func configureUI() {
        view.backgroundColor = .customLightOrange()
        
        view.addSubview(segmentControl)
        segmentControl.anchor(top: view.safeAreaLayoutGuide.topAnchor,
                              left: view.leftAnchor,
                              right: view.rightAnchor,
                              height: 135)
        
        view.addSubview(topCollectionView)
        topCollectionView.anchor(top: segmentControl.bottomAnchor,
                                 left: view.leftAnchor,
                                 bottom: view.bottomAnchor,
                                 right: view.rightAnchor,
                                 paddingTop: 0)
        
        view.addSubview(mypageButtonBaseView)
        mypageButtonBaseView.anchor(bottom: view.safeAreaLayoutGuide.bottomAnchor,
                                    right: view.rightAnchor,
                                    paddingBottom: -110, paddingRight: -80)
        mypageButtonBaseView.setDimensions(height: 200, width: 200)
        
        mypageButtonBaseView.addSubview(myPageButton)
        myPageButton.anchor(bottom: view.safeAreaLayoutGuide.bottomAnchor,
                            right: view.rightAnchor,
                            paddingRight: 20)
        myPageButton.setDimensions(height: 60, width: 60)
    }
}

// MARK: - CustomSegmentControlDelegate

extension TopViewController: CustomSegmentControlDelegate {
    
    func didTapCell(cellType: CellType) {
        topCollectionView.removeFromSuperview()
        createTopCollectionView(cellType: cellType)
    }
}

// MARK: - TopCollectionViewDelegate

extension TopViewController: TopCollectionViewDelegate {
    
    func didTapReadCell(selectedCell: UICollectionViewCell, story: Story) {
        selectedCell.hero.id = "selectCell"
        
        let vc = ReadStoryViewController()
        vc.view.hero.id = "selectCell"
        vc.viewModel = StoryViewModel(story: story)
        
        navigationController?.isHeroEnabled = true
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func didTapSpinCell(selectedCell: UICollectionViewCell, story: MiniStory) {
        
        let indexPath = IndexPath(row: 1, section: 0)
        guard let selectedCategory = segmentControl.collectionView.cellForItem(at: indexPath) as? CustomSegmentCell else { return }
        selectedCategory.titleLabel.hero.id = "segmentCellTitle"
        selectedCategory.imageView.hero.id = "segmentCellImage"
        
        selectedCell.hero.id = "selectCell"
        
        let vc = SpinStoryViewController()
        vc.completeRegister = { didComplete in
            self.didStoryRegister = true
        }
        vc.topStoryCollectionView.hero.id = "selectCell"
        vc.topStoryCollectionView.miniStories = [story]
        
        vc.fetchChoicesStories(story: story)
        
        navigationController?.isHeroEnabled = true
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func didRegisterStory(cell: BeginStoryViewCell) {
        uploadStory(cell: cell)
    }
}
