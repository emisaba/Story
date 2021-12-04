import UIKit

class LoginViewController: UIViewController {
    
    // MARK: - Properties
    
    private let emailTextField = UITextField.createTextField(placeholder: "email")
    private let passwordTextField = UITextField.createTextField(placeholder: "password")
    private let loginButton = UIButton.createTextButton(text: "login", target: self, action: #selector(didTapLoginButton))
    private let registerButton = UIButton.createTextButton(text: "register", target: self, action: #selector(didTapRegisterButton))
    
    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = true
    }
    
    // MARK: - API
    
    func logUserIn() {
        guard let email = emailTextField.text else { return }
        guard let password = passwordTextField.text else { return }
        
        AuthService.logUserIn(withEmail: email, password: password) { _ , error in
            if let error = error {
                print("failed to log user in: \(error.localizedDescription)")
                return
            }
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    // MARK: - Action
    
    @objc func didTapLoginButton() {
        logUserIn()
    }
    
    @objc func didTapRegisterButton() {
        let vc = RegisterViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
    
    // MARK: - Helpers
    
    func configureUI() {
        view.backgroundColor = .white
        
        view.addSubview(registerButton)
        registerButton.anchor(top: view.safeAreaLayoutGuide.topAnchor,
                           right: view.rightAnchor,
                           paddingTop: 10,
                           paddingRight: 10)
        registerButton.setDimensions(height: 30, width: 120)
        
        let stackView = UIStackView(arrangedSubviews: [emailTextField, passwordTextField, loginButton])
        stackView.spacing = 20
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        
        view.addSubview(stackView)
        stackView.setDimensions(height: 170, width: view.frame.width - 40)
        stackView.centerX(inView: view)
        stackView.centerY(inView: view)
    }
}
