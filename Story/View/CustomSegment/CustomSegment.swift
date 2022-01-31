import UIKit

protocol CustomSegmentControlDelegate {
    func didTapCell(cellType: CellType)
}

class CustomSegmentControl: UIView {
    
    // MARK: - Properties
    
    public var delegate: CustomSegmentControlDelegate?
    
    private let identifier = "identifier"
    public lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.dataSource = self
        cv.delegate = self
        cv.register(CustomSegmentCell.self, forCellWithReuseIdentifier: identifier)
        cv.backgroundColor = .clear
        return cv
    }()
    
    public let pointer: TriangleView = {
        let view = TriangleView()
        view.layer.cornerRadius = 6
        view.backgroundColor = .customLightOrange()
        return view
    }()
    
    // MARK: - Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .customLightOrange()
        
        addSubview(collectionView)
        collectionView.anchor(top: topAnchor,
                              left: leftAnchor,
                              right: rightAnchor,
                              paddingTop: 0,
                              height: 123)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        addSubview(pointer)
        pointer.frame = CGRect(x: 0, y: 123, width: 12, height: 12)
        pointer.center.x = frame.width / 6
    }
    
    // MARK: - Helper
    
    func movePointer(selectedCell: Int) {
        
        UIView.animate(withDuration: 0.25) {
            switch selectedCell {
            case 0:
                self.pointer.center.x = self.frame.width / 6
            case 1:
                self.pointer.center.x = self.frame.width / 2
            case 2:
                self.pointer.center.x = self.frame.width / 6 * 5
            default:
                break
            }
        }
    }
    
    func returnCellType(cellNumber: Int) -> CellType {

        switch cellNumber {
        case 0:
            return .read
        case 1:
            return .spin
        case 2:
            return .begin
        default:
            break
        }
        
        return .read
    }
    
    func afterRegisterStory() {
        pointer.center.x = self.frame.width / 6
        collectionView.reloadData()
    }
}

// MARK: - UICollectionViewDataSource

extension CustomSegmentControl: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath) as! CustomSegmentCell
        cell.cellType = returnCellType(cellNumber: indexPath.row)
        return cell
    }
}

// MARK: - UICollectionViewDelegate

extension CustomSegmentControl: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let indexPath = IndexPath(item: indexPath.row, section: 0)
        guard let cell = collectionView.cellForItem(at: indexPath) as? CustomSegmentCell else { return }
        cell.lottieAnimation.play()
        
        movePointer(selectedCell: indexPath.row)
        delegate?.didTapCell(cellType: returnCellType(cellNumber: indexPath.row))
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension CustomSegmentControl: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: frame.width / 3, height: collectionView.frame.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}
