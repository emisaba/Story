import UIKit

protocol storyViewDelegateForTopViewController {
    func didSelectTopSpinCell(selectedCell: StoryViewCell, story: [MiniStory])
}

protocol storyViewDelegateForSpinViewController {
    func didSelectNextStory(selectedCell: StoryViewCell)
}

class StoryCollectionView: UICollectionView {
    
    // MARK: - Properties
    
    public var delegateForTopViewController: storyViewDelegateForTopViewController?
    public var delegateForSpinViewController: storyViewDelegateForSpinViewController?
    
    private let identifier = "identifier"
    private var isVertical = false {
        didSet { reloadData() }
    }
    private var isTop = false {
        didSet { reloadData() }
    }
    
    public var miniStories = [MiniStory]() {
        didSet {
            reloadData()
            scrollToItem(at: IndexPath(item: miniStories.count - 1, section: 0), at: .centeredHorizontally, animated: true)
        }
    }
    
    // MARK: - Lifecycle
    
    init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout, isVertical: Bool, isTop: Bool) {
        self.isVertical = isVertical
        self.isTop = isTop
        super.init(frame: frame, collectionViewLayout: layout)
        
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Helper
    
    func configureUI() {
        backgroundColor = .customGreen().withAlphaComponent(0.1)
        dataSource = self
        delegate = self
        register(StoryViewCell.self, forCellWithReuseIdentifier: identifier)
        isPagingEnabled = isVertical ? false : true
    }
}

// MARK: - UICollectionViewDataSource

extension StoryCollectionView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return miniStories.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath) as! StoryViewCell
        cell.backgroundColor = .customGreen()
        cell.delegateForTopViewController = self
        cell.delegateForSpinViewController = self
        cell.viewModel = MiniStoryViewModel(story: miniStories[indexPath.row], cellNumber: indexPath.row, isVartical: isVertical)
        cell.story = miniStories
        return cell
    }
}

// MARK: - UICollectionViewDelegate

extension StoryCollectionView: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let story = miniStories[indexPath.row].story
        let apporoximateWidth = frame.width - 55
        let size = CGSize(width: apporoximateWidth, height: 1000)
        let attributes: [NSAttributedString.Key: Any] = [.font: UIFont.systemFont(ofSize: 16)]
        let estimatedFrame = NSString(string: story)
            .boundingRect(with: size,
                          options: .usesLineFragmentOrigin,
                          attributes: attributes,
                          context: nil)
        
        let estimatedHeight = isTop ? frame.height : estimatedFrame.height + 100

        return .init(width: frame.width, height: estimatedHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return isVertical ? 20 : 0
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if !isVertical { return }
        cell.alpha = 0

        UIView.animate(withDuration: 0, delay: 0.05 * Double(indexPath.row)) {
            cell.alpha = 1
        }
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension StoryCollectionView: UICollectionViewDelegateFlowLayout {
    
}

// MARK: - StoryViewCellDelegate

extension StoryCollectionView: StoryViewCellDelegateForTopViewController {
    func didSelectTopSpinCell(cell: StoryViewCell, story: [MiniStory]) {
        delegateForTopViewController?.didSelectTopSpinCell(selectedCell: cell, story: story)
    }
}

// MARK: - StoryViewCellDelegate

extension StoryCollectionView: StoryViewCellDelegateForSpinViewController {
    func didSelectNextStory(cell: StoryViewCell) {
        delegateForSpinViewController?.didSelectNextStory(selectedCell: cell)
    }
}
