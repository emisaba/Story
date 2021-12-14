import UIKit

protocol TopCollectionViewDelegate {
    func didTapReadCell(selectedCell: UICollectionViewCell, story: Story)
    func didTapSpinCell(selectedCell: UICollectionViewCell, story: [MiniStory])
    func didRegisterStory(cell: BeginStoryViewCell)
}

class TopCollectionView: UIView {
    
    // MARK: - Properties
    
    public var delegate: TopCollectionViewDelegate?
    
    private let identifier = "identifier"
    
    public lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.dataSource = self
        cv.delegate = self
        cv.register(cellType.type.self, forCellWithReuseIdentifier: identifier)
        cv.backgroundColor = .systemPink
        cv.contentInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        return cv
    }()
    
    public var miniStories = [MiniStory]() {
        didSet { collectionView.reloadData() }
    }
    
    public var stories = [Story]() {
        didSet { collectionView.reloadData() }
    }
    
    private var cellType: CellType = .read {
        didSet {
            collectionView.register(cellType.type.self, forCellWithReuseIdentifier: identifier)
            collectionView.reloadData()
        }
    }
    
    private var keyboardHeight: CGFloat = 0 {
        didSet { collectionView.reloadData() }
    }
    
    // MARK: - Lifecycle
    
    init(frame: CGRect, cellType: CellType) {
        
        self.cellType = cellType
        
        super.init(frame: frame)
        if cellType == .spin { fetchMiniStories() }
        
        addSubview(collectionView)
        collectionView.fillSuperview()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - API
    
    func fetchMiniStories() {
        StoryService.fetchMiniStories { miniStories in
            self.miniStories = miniStories
        }
    }
    
    // MARK: - Action
    
    @objc func getKeyboardHeight(notification: NSNotification) {
        if keyboardHeight > 0 { return }
        
        if let userInfo = notification.userInfo {
            guard let keyboardFrame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }
            let keyboardHeight = keyboardFrame.cgRectValue.height
            self.keyboardHeight = keyboardHeight
        }
    }
    
    // MARK: - Helper
    
    func detectKeyboardHeight() {
        NotificationCenter.default.addObserver(self, selector: #selector(getKeyboardHeight),
                                               name: UIResponder.keyboardWillShowNotification,
                                               object: nil)
    }
}

// MARK: - UICollectionViewDataSource

extension TopCollectionView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        switch cellType {
        case .begin:
            return 1
        case .spin:
            return miniStories.count
        case .read:
            return stories.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath)
        cell.backgroundColor = .systemYellow
        
        switch cellType {
        
        case .begin:
            let cell = cell as! BeginStoryViewCell
            cell.delegate = self
            return cell
            
        case .spin:
            let cell = cell as! SpinStoryViewCell
            cell.storyCollectionView.delegateForTopViewController = self
            cell.storyCollectionView.miniStories = miniStories
            return cell
            
        case .read:
            let cell = cell as! ReadStoryViewCell
            cell.viewModel = StoryViewModel(story: stories[indexPath.row])
            return cell
        }
    }
}

// MARK: - UICollectionViewDelegate

extension TopCollectionView: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) as? ReadStoryViewCell else { return }
        delegate?.didTapReadCell(selectedCell: cell, story: stories[indexPath.row])
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        switch cellType {
        case .begin:
            detectKeyboardHeight()
            return CGSize(width: frame.width, height: frame.height - keyboardHeight)
            
        case .spin:
            
            let story = miniStories[indexPath.row].story
            let apporoximateWidth = frame.width - 40
            let size = CGSize(width: apporoximateWidth, height: 1000)
            let attributes: [NSAttributedString.Key: Any] = [.font: UIFont.systemFont(ofSize: 16)]
            let estimatedFrame = NSString(string: story)
                .boundingRect(with: size,
                              options: .usesLineFragmentOrigin,
                              attributes: attributes,
                              context: nil)
        
            return CGSize(width: frame.width, height: estimatedFrame.height + 100)
            
        case .read:
            let frame = CGRect(x: 0, y: 0, width: frame.width, height: 180)
            let estimatedSizeCell = StoryViewCell(frame: frame)
            estimatedSizeCell.layoutIfNeeded()

            let targetSize = CGSize(width: frame.width, height: 1000)
            let estimatedSize = estimatedSizeCell.systemLayoutSizeFitting(targetSize)

            return CGSize(width: frame.width - 40, height: estimatedSize.height)
            
        }
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension TopCollectionView: UICollectionViewDelegateFlowLayout {
    
}

// MARK: - StoryCollectionViewCell

extension TopCollectionView: storyViewDelegateForTopViewController {
    func didSelectTopSpinCell(selectedCell: StoryViewCell, story: [MiniStory]) {
        delegate?.didTapSpinCell(selectedCell: selectedCell, story: story)
    }
}

// MARK: - BeginStoryViewCellDelegate

extension TopCollectionView: BeginStoryViewCellDelegate {
    func registerStory(cell: BeginStoryViewCell) {
        delegate?.didRegisterStory(cell: cell)
    }
}
