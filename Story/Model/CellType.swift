import UIKit

enum CellType {
    case begin
    case spin
    case read
    
    var type: UICollectionViewCell.Type {
        switch self {
        case .begin:
            return BeginStoryViewCell.self
        case .spin:
            return SpinStoryViewCell.self
        case .read:
            return ReadStoryViewCell.self
        }
    }
}
