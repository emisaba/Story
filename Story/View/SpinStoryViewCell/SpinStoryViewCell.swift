import UIKit

class SpinStoryViewCell: UICollectionViewCell {
    
    // MARK: - Properties
    
    private let layout: UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        return layout
    }()
    
    public lazy var storyCollectionView: StoryCollectionView = {
        let view = StoryCollectionView(frame: .zero, collectionViewLayout: layout, isVertical: false, isTop: true)
        return view
    }()
    
    // MARK: - LifeCycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        
        addSubview(storyCollectionView)
        storyCollectionView.fillSuperview()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


