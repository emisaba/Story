import UIKit
import Firebase

class MypageViewController: UIViewController {
    
    // MARK: - Properties
    
    public let userIcon = UIImageView.createIconImageView()
    private let closeButton = UIButton.createImageButton(target: self, action: #selector(didTapCloseButton), image: #imageLiteral(resourceName: "arrow"))
    
    private lazy var readStoryButton = createButton(text: "read", action: #selector(didTapReadButton))
    private lazy var spinStoryButton = createButton(text: "spin", action: #selector(didTapSpinButton))
    private lazy var startStoryButton = createButton(text: "start", action: #selector(didTapStartButton))
    private let logoutButton = UIButton.createTextButton(text: "logout", target: self, action: #selector(didTapLogoutButton))
    
    private let topPageButton = UIButton.createImageButton(target: self, action: #selector(didTapTopPageButton), image: #imageLiteral(resourceName: "arrow"))
    private let topPageButtonBaseView = UIView.createButtonBaseView(isTop: true)
    
    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
    }
    
    // MARK: - API
    
    func logout() {
        do {
            try Auth.auth().signOut()
            
            let vc = LoginViewController()
            let nv = UINavigationController(rootViewController: vc)
            nv.modalPresentationStyle = .fullScreen
            present(nv, animated: true, completion: nil)
            
        } catch {
            print("failed to signout")
        }
    }
    
    // MARK: - Actions
    
    @objc func didTapReadButton() {
        
    }
    
    @objc func didTapSpinButton() {
        
    }
    
    @objc func didTapStartButton() {
        
    }
    
    @objc func didTapCloseButton() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc func didTapLogoutButton() {
        logout()
    }
    
    @objc func didTapTopPageButton() {
        dismiss(animated: true, completion: nil)
    }
    
    // MARK: - Helpers
    
    func configureUI() {
        view.backgroundColor = .systemBlue
        
        userIcon.backgroundColor = .systemGreen
        view.addSubview(userIcon)
        userIcon.anchor(top: view.safeAreaLayoutGuide.topAnchor,
                        paddingTop: 50)
        userIcon.setDimensions(height: 60, width: 60)
        userIcon.centerX(inView: view)
        
        view.addSubview(closeButton)
        closeButton.anchor(right: view.rightAnchor,
                           paddingRight: 20)
        closeButton.setDimensions(height: 60, width: 60)
        closeButton.centerY(inView: userIcon)
        
        let buttonStackView = UIStackView(arrangedSubviews: [readStoryButton,
                                                             spinStoryButton,
                                                             startStoryButton])
        buttonStackView.distribution = .fillEqually
        buttonStackView.spacing = 20
        buttonStackView.axis = .vertical
        
        view.addSubview(buttonStackView)
        buttonStackView.anchor(top: userIcon.bottomAnchor,
                               paddingTop: 50)
        buttonStackView.setDimensions(height: 280, width: view.frame.width - 40)
        buttonStackView.centerX(inView: view)
        
        view.addSubview(logoutButton)
        logoutButton.backgroundColor = .systemRed
        logoutButton.anchor(left: view.leftAnchor,
                            bottom: view.safeAreaLayoutGuide.bottomAnchor,
                            paddingLeft: 20,
                            paddingBottom: 10)
        logoutButton.setDimensions(height: 60, width: 120)
        
        view.addSubview(topPageButtonBaseView)
        topPageButtonBaseView.anchor(bottom: view.safeAreaLayoutGuide.bottomAnchor,
                                     right: view.rightAnchor,
                                     paddingBottom: -110, paddingRight: -80)
        topPageButtonBaseView.setDimensions(height: 200, width: 200)
        
        topPageButtonBaseView.addSubview(topPageButton)
        topPageButton.anchor(bottom: view.safeAreaLayoutGuide.bottomAnchor,
                             right: view.rightAnchor,
                             paddingRight: 20)
        topPageButton.setDimensions(height: 60, width: 60)
    }
    
    func createButton(text: String, action: Selector) -> UIButton {
        let iconImage = UIImageView.createIconImageView()
        let title = UILabel.createLabel(text: text, size: 18, alignment: .left)
        
        let button = UIButton()
        button.backgroundColor = .systemPink
        button.setDimensions(height: 80, width: view.frame.width - 40)
        button.addSubview(iconImage)
        button.addTarget(self, action: action, for: .touchUpInside)
        
        iconImage.anchor(left: button.leftAnchor,
                         paddingLeft: 10)
        iconImage.setDimensions(height: 60, width: 60)
        iconImage.centerY(inView: button)
        
        button.addSubview(title)
        title.anchor(left: iconImage.rightAnchor,
                     paddingLeft: 10, height: 60)
        title.centerY(inView: button)
        
        return button
    }
}
