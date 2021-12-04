import UIKit

protocol CustomActionSheetDelegate {
    func addStory(story: String)
    func completeStory(title: String, category: String)
    func cancel()
}

class CustomActionSheet: UIView {
    
    // MARK: - Properties
    
    public var delegate: CustomActionSheetDelegate?
    
    public lazy var cancelButton = UIButton.createTextButton(text: "cancel", target: self, action: #selector(didTapCancelButton))
    public lazy var registerButton = UIButton.createTextButton(text: "register", target: self, action: #selector(didTapRegisterButton))
    
    public lazy var textView = UITextView.createRegisterStoryTextView()
    private let placeholderLabel = UILabel.createLabel(text: "Lets's start story", size: 16, alignment: .left)
    private let countLabel = UILabel.createLabel(text: "0 / 140", size: 16, alignment: .right)
    
    private let categoryTextField = UITextField.createTextField(placeholder: "カテゴリ")
    private let titleTextField = UITextField.createTextField(placeholder: "タイトル")
    
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
                            paddingLeft: 20)
        cancelButton.setDimensions(height: 20, width: 100)
        
        addSubview(registerButton)
        registerButton.anchor(top: safeAreaLayoutGuide.topAnchor,
                              right: rightAnchor,
                              paddingTop: 20,
                              paddingRight: 20)
        registerButton.setDimensions(height: 20, width: 100)
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
        delegate?.cancel()
    }
    
    // MARK: - Helper
    
    func setupAddView() {
        
        textView.delegate = self
        
        addSubview(textView)
        textView.anchor(top: registerButton.bottomAnchor,
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
                                paddingLeft: 10, height: 40)
        
        addSubview(countLabel)
        countLabel.anchor(bottom: textView.bottomAnchor,
                          right: rightAnchor,
                          paddingBottom: 10,
                          paddingRight: 30,
                          height: 20)
    }
    
    func setupCompleteView() {
        
        addSubview(categoryTextField)
        categoryTextField.anchor(top: registerButton.bottomAnchor,
                                 left: leftAnchor,
                                 right: rightAnchor,
                                 paddingTop: 50,
                                 paddingLeft: 20,
                                 paddingRight: 20,
                                 height: 50)
        
        addSubview(titleTextField)
        titleTextField.anchor(top: categoryTextField.bottomAnchor,
                                 left: leftAnchor,
                                 right: rightAnchor,
                                 paddingTop: 20,
                                 paddingLeft: 20,
                                 paddingRight: 20,
                                 height: 50)
    }
    
    func removeViews(views: [UIView]) {
        views.forEach { $0.removeFromSuperview() }
    }
}

// MARK: - UITextViewDelegate

extension CustomActionSheet: UITextViewDelegate {
    
    func textViewDidChangeSelection(_ textView: UITextView) {
        placeholderLabel.isHidden = !textView.text.isEmpty
        
        countLabel.text = "\(textView.text.count) / 140"
        if textView.text.count > 140 { textView.deleteBackward() }
    }
}
