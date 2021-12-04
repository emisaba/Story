import UIKit

class InCompleteViewController: UIViewController {
    
    // MARK: - Properties
    
    private let collectionView = TopCollectionView(frame: .zero, cellType: .spin)
    
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
