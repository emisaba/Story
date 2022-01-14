import UIKit

protocol CustomActionSheetDelegate {
    func addStory(story: String)
    func completeStory(title: String, category: String)
    func cancel()
}

class CustomActionSheet: UIView {
    
    // MARK: - Properties
    
    public var delegate: CustomActionSheetDelegate?
    
    public lazy var cancelButton = UIButton.createImageButton(target: self, action: #selector(didTapCancelButton), image: #imageLiteral(resourceName: "close"))
    public lazy var registerButton = UIButton.createTextButton(text: "register", target: self, action: #selector(didTapRegisterButton))
    
    public lazy var textView = UITextView.createRegisterStoryTextView()
    private let placeholderLabel = UILabel.createLabel(text: "Lets's add story", size: 16, alignment: .left)
    private let countLabel = UILabel.createLabel(text: "0 / 140", size: 16, alignment: .right)
    
    private let categoryTextField = UITextField.createTextField(placeholder: "category")
    private let titleTextField = UITextField.createTextField(placeholder: "title")
    
    public var isAdd = false {
        didSet {
            if isAdd {
                removeViews(views: [categoryTextField, titleTextField])
                setupAddView()
            } else {
                removeViews(views: [textView, placeholderLabel, countLabel])
                setupCompleteView()
            }
        }
    }
    
    // MARK: - LifeCycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(cancelButton)
        cancelButton.anchor(top: safeAreaLayoutGuide.topAnchor,
                            left: leftAnchor,
                            paddingTop: 20,
                            paddingLeft: 10)
        cancelButton.setDimensions(height: 50, width: 50)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Action
    
    @objc func didTapRegisterButton() {
        
        if isAdd {
            guard let story = textView.text else { return }
            delegate?.addStory(story: story)
            
        } else {
            guard let category = categoryTextField.text else { return }
            guard let title = titleTextField.text else { return }
            delegate?.completeStory(title: title, category: category)
        }
    }
    
    @objc func didTapCancelButton() {
        endEditing(true)
        delegate?.cancel()
    }
    
    // MARK: - Helper
    
    func setupAddView() {
        
        textView.delegate = self
        
        addSubview(textView)
        textView.anchor(top: cancelButton.bottomAnchor,
                        left: leftAnchor,
                        right: rightAnchor,
                        paddingTop: 20,
                        paddingLeft: 20,
                        paddingRight: 20,
                        height: 200)
        
        textView.addSubview(placeholderLabel)
        placeholderLabel.anchor(top: textView.topAnchor,
                                left: textView.leftAnchor,
                                right: textView.rightAnchor,
                                paddingTop: 10,
                                paddingLeft: 13)
        
        addSubview(countLabel)
        countLabel.anchor(bottom: textView.bottomAnchor,
                          right: rightAnchor,
                          paddingBottom: 10,
                          paddingRight: 30,
                          height: 20)
        
        addSubview(registerButton)
        registerButton.layer.borderWidth = 2
        registerButton.layer.borderColor = UIColor.white.cgColor
        registerButton.anchor(top: textView.bottomAnchor,
                              paddingTop: 30)
        registerButton.centerX(inView: self)
        registerButton.setDimensions(height: 60, width: 160)
    }
    
    func setupCompleteView() {
        
        categoryTextField.delegate = self
        titleTextField.delegate = self
        
        addSubview(categoryTextField)
        categoryTextField.anchor(top: cancelButton.bottomAnchor,
                                 left: leftAnchor,
                                 right: rightAnchor,
                                 paddingTop: 50,
                                 paddingLeft: 30,
                                 paddingRight: 30,
                                 height: 60)
        
        let categoryBottomView = UIView()
        categoryBottomView.backgroundColor = .white
        addSubview(categoryBottomView)
        categoryBottomView.anchor(left: categoryTextField.leftAnchor,
                                  bottom: categoryTextField.bottomAnchor,
                                  right: categoryTextField.rightAnchor,
                                  height: 0.5)
        
        addSubview(titleTextField)
        titleTextField.anchor(top: categoryTextField.bottomAnchor,
                              left: leftAnchor,
                              right: rightAnchor,
                              paddingTop: 20,
                              paddingLeft: 30,
                              paddingRight: 30,
                              height: 60)
        
        let titleBottomView = UIView()
        titleBottomView.backgroundColor = .white
        addSubview(titleBottomView)
        titleBottomView.anchor(left: titleTextField.leftAnchor,
                               bottom: titleTextField.bottomAnchor,
                               right: titleTextField.rightAnchor,
                               height: 0.5)
        
        addSubview(registerButton)
        registerButton.layer.borderWidth = 2
        registerButton.layer.borderColor = UIColor.white.cgColor
        registerButton.anchor(top: titleTextField.bottomAnchor,
                              paddingTop: 70)
        registerButton.centerX(inView: self)
        registerButton.setDimensions(height: 60, width: 160)
    }
    
    func removeViews(views: [UIView]) {
        views.forEach { $0.removeFromSuperview() }
    }
}

// MARK: - UITextViewDelegate

extension CustomActionSheet: UITextViewDelegate {
    
    func textViewDidChangeSelection(_ textView: UITextView) {
        placeholderLabel.isHidden = !textView.text.isEmpty
        
        let attributes: [NSAttributedString.Key: Any] = [.foregroundColor: UIColor.customGreen(),
                                                         .font: UIFont.KaiseiOpti(size: 18),
                                                         .kern: 1]
        
        textView.attributedText = NSAttributedString(string: textView.text, attributes: attributes)
        
        let countAttributedText = NSMutableAttributedString(string: "\(textView.text.count)", attributes: attributes)
        countAttributedText.append(NSAttributedString(string: "/140", attributes: attributes))
        countLabel.attributedText = countAttributedText
        
        if textView.text.count > 140 { textView.deleteBackward() }
    }
}

// MARK: - UITextViewDelegate

extension CustomActionSheet: UITextFieldDelegate {
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        let attributes: [NSAttributedString.Key: Any] = [.foregroundColor: UIColor.white,
                                                         .font: UIFont.KaiseiOpti(size: 18),
                                                         .kern: 1]
        switch textField {
        case categoryTextField:
            textField.attributedText = NSAttributedString(string: textField.text ?? "", attributes: attributes)
        case titleTextField:
            titleTextField.attributedText = NSAttributedString(string: textField.text ?? "", attributes: attributes)
        default: break
        }
    }
}
