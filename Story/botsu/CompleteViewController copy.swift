import UIKit

class CompleteViewController: UIViewController {
    
    // MARK: - Properties
    
    private let collectionView = TopCollectionView(frame: .zero, cellType: .read)
    
    // MARK: - LifeCycle

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(collectionView)
        collectionView.fillSuperview()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = true
    }
}
