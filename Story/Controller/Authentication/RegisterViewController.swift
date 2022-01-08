import UIKit

class RegisterViewController: UIViewController {
    
    // MARK: - Properties
    
    private let iconImageButton = UIButton.createImageButton(target: self, action: #selector(didTapIconImageButton), image: #imageLiteral(resourceName: "arrow"))
    private let emailTextField = UITextField.createTextField(placeholder: "email")
    private let passwordTextField = UITextField.createTextField(placeholder: "password")
    private let userNameTextField = UITextField.createTextField(placeholder: "username")
    private let registerButton = UIButton.createTextButton(text: "register", target: self, action: #selector(didTapRegisterButton))
    
    private var selectedImage: UIImage?
    
    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
    
    // MARK: - API
    
    func registerUser() {
        
        guard let email = emailTextField.text else { return }
        guard let password = passwordTextField.text else { return }
        guard let userName = userNameTextField.text else { return }
        guard let userImage = selectedImage else { return }
        let credentials = AuthCredentials(email: email, password: password, userName: userName, userImage: userImage)
        
        AuthService.registerUser(withCredential: credentials) { error in
            if let error = error {
                print("failed to register user: \(error.localizedDescription)")
                return
            }
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    // MARK: - Action
    
    @objc func didTapRegisterButton() {
        registerUser()
    }
    
    @objc func didTapIconImageButton() {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.allowsEditing = true
        
        present(picker, animated: true, completion: nil)
    }
    
    // MARK: - Helper
    
    func configureUI() {
        view.backgroundColor = .white
        
        view.addSubview(iconImageButton)
        iconImageButton.anchor(top: view.safeAreaLayoutGuide.topAnchor,
                             paddingTop: 50)
        iconImageButton.centerX(inView: view)
        iconImageButton.setDimensions(height: 100, width: 100)
        
        let stackView = UIStackView(arrangedSubviews: [emailTextField,
                                                       passwordTextField,
                                                       userNameTextField,
                                                       registerButton])
        stackView.spacing = 20
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        
        view.addSubview(stackView)
        stackView.anchor(top: iconImageButton.bottomAnchor,
                         paddingTop: 50)
        stackView.setDimensions(height: 260, width: view.frame.width - 40)
        stackView.centerX(inView: view)
    }
}

// MARK: - UIImagePickerControllerDelegate

extension RegisterViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[.editedImage] as? UIImage else { return }
        selectedImage = image
        iconImageButton.setImage(image, for: .normal)
        
        dismiss(animated: true, completion: nil)
    }
}
