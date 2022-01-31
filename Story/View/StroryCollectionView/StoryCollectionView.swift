import UIKit

protocol storyViewDelegateForTopViewController {
    func didSelectTopSpinCell(selectedCell: StoryViewCell, story: [MiniStory])
}

protocol storyViewDelegateForSpinViewController {
    func didSelectNextStory(selectedCell: StoryViewCell)
    func didDragPage(onPage: Int)
}

class StoryCollectionView: UICollectionView {
    
    // MARK: - Properties
    
    public var delegateForTopViewController: storyViewDelegateForTopViewController?
    public var delegateForSpinViewController: storyViewDelegateForSpinViewController?
    
    private let identifier = "identifier"
    private var isVertical = false {
        didSet { reloadData() }
    }
    
    public var miniStories = [MiniStory]() {
        didSet {
            reloadData()
            
            if  isVertical {
                contentInset = UIEdgeInsets(top: 20, left: 0, bottom: 0, right: 0)
                scrollToItem(at: IndexPath(item: 0, section: 0), at: .top, animated: false)
            } else {
                isPagingEnabled = false
                scrollToItem(at: IndexPath(item: miniStories.count - 1, section: 0), at: .centeredHorizontally, animated: true)
                isPagingEnabled = true
            }
        }
    }
    
    // MARK: - Lifecycle
    
    init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout, isVertical: Bool) {
        self.isVertical = isVertical
        super.init(frame: frame, collectionViewLayout: layout)
        
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Helper
    
    func configureUI() {
        dataSource = self
        delegate = self
        register(StoryViewCell.self, forCellWithReuseIdentifier: identifier)
        
        if isVertical {
            backgroundColor = .init(white: 1, alpha: 0.95)
            showsVerticalScrollIndicator = false
        } else {
            backgroundColor = .customGreen()
            isPagingEnabled = true
            showsHorizontalScrollIndicator = false
        }
    }
}

// MARK: - UICollectionViewDataSource

extension StoryCollectionView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return miniStories.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath) as! StoryViewCell
        cell.backgroundColor = .clear
        cell.viewModel = MiniStoryViewModel(story: miniStories[indexPath.row], cellNumber: indexPath.row, isVartical: isVertical)
        cell.story = miniStories
        return cell
    }
}

// MARK: - UICollectionViewDelegate

extension StoryCollectionView: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let defaultSelectedCell = collectionView.cellForItem(at: IndexPath(item: 0, section: 0)) else { return }
        guard let selectedCell = collectionView.cellForItem(at: indexPath) as? StoryViewCell else { return }
        selectedCell.isSelected = true
        defaultSelectedCell.isSelected = false
        
        if isVertical == true {
            Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false) { _ in
                self.delegateForSpinViewController?.didSelectNextStory(selectedCell: selectedCell)
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let story = miniStories[indexPath.row].story
        let apporoximateWidth = frame.width - 55
        let size = CGSize(width: apporoximateWidth, height: 1000)
        let attributes: [NSAttributedString.Key: Any] = [.font: UIFont.banana(size: 16)]
        let estimatedFrame = NSString(string: story)
            .boundingRect(with: size,
                          options: .usesLineFragmentOrigin,
                          attributes: attributes,
                          context: nil)
        
        let estimatedHeight = isVertical ? estimatedFrame.height + 160 : 230

        return .init(width: frame.width, height: estimatedHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
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
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: isVertical ? 20 : 0, left: 0, bottom:  isVertical ? 100 : 0, right: 0)
    }
}

// MARK: - UIScrollViewDelegate

extension StoryCollectionView: UIScrollViewDelegate {
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        if isVertical { return }
        
        let x = targetContentOffset.pointee.x
        let onPage = Int(x / frame.width)
        delegateForSpinViewController?.didDragPage(onPage: onPage)
    }
}
