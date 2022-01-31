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
    public lazy var registerButton = UIButton.createTextButton(text: "登録", target: self, action: #selector(didTapRegisterButton))
    
    public lazy var storyTextView = UITextView.createRegisterStoryTextView()
    private let placeholderLabel = UILabel.createLabel(text: "ストーリーを入力してください...", size: 18, alignment: .left)
    private let countLabel = UILabel.createLabel(text: "0/140", size: 16, alignment: .right)
    
//    private let categoryTextField = UITextField.createTextField(placeholder: "カテゴリを入力")
//    private let titleTextField = UITextField.createTextField(placeholder: "タイトルを入力")
    
    private lazy var categoryTextField = createTextView()
    private lazy var categoryTextFieldPlaceholder = createLabel(text: "カテゴリを入力")
    
    private lazy var titleTextField = createTextView()
    private lazy var titleTextFieldPlaceholder = createLabel(text: "タイトルを入力")
    
    public var isAdd = false {
        didSet {
            if isAdd {
                removeViews(views: [categoryTextField, titleTextField])
                setupAddView()
            } else {
                removeViews(views: [storyTextView, placeholderLabel, countLabel])
                setupCompleteView()
            }
        }
    }
    
    // MARK: - LifeCycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(cancelButton)
        cancelButton.anchor(top: safeAreaLayoutGuide.topAnchor,
                            right: rightAnchor,
                            paddingTop: -20,
                            paddingRight: 20)
        cancelButton.setDimensions(height: 50, width: 50)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Action
    
    @objc func didTapRegisterButton() {
        
        if isAdd {
            guard let story = storyTextView.text else { return }
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
        
        storyTextView.delegate = self
        
        addSubview(storyTextView)
        storyTextView.anchor(top: cancelButton.bottomAnchor,
                        left: leftAnchor,
                        right: rightAnchor,
                        paddingTop: 20,
                        paddingLeft: 20,
                        paddingRight: 20,
                        height: 290)
        
        storyTextView.addSubview(placeholderLabel)
        placeholderLabel.anchor(top: storyTextView.topAnchor,
                                left: storyTextView.leftAnchor,
                                right: storyTextView.rightAnchor,
                                paddingTop: 15,
                                paddingLeft: 13)
        
        addSubview(countLabel)
        countLabel.anchor(bottom: storyTextView.bottomAnchor,
                          right: rightAnchor,
                          paddingBottom: 15,
                          paddingRight: 35,
                          height: 20)
        
        addSubview(registerButton)
        registerButton.setTitleColor(.white, for: .normal)
        registerButton.anchor(top: storyTextView.bottomAnchor,
                              left: leftAnchor,
                              right: rightAnchor,
                              paddingTop: 30,
                              paddingLeft: 20,
                              paddingRight: 20,
                              height: 60)
    }
    
    func setupCompleteView() {
        
        categoryTextField.delegate = self
        titleTextField.delegate = self
        
        addSubview(categoryTextField)
        categoryTextField.anchor(top: cancelButton.bottomAnchor,
                                 left: leftAnchor,
                                 right: rightAnchor,
                                 paddingTop: 55,
                                 paddingLeft: 30,
                                 paddingRight: 30,
                                 height: 50)
        
        categoryTextField.addSubview(categoryTextFieldPlaceholder)
        categoryTextFieldPlaceholder.anchor(top:categoryTextField.topAnchor,
                                            left: categoryTextField.leftAnchor,
                                            paddingTop: 5,
                                            paddingLeft: 5)
        
        let categoryBottomView = UIView()
        categoryBottomView.backgroundColor = .white
        addSubview(categoryBottomView)
        categoryBottomView.anchor(left: categoryTextField.leftAnchor,
                                  bottom: categoryTextField.bottomAnchor,
                                  right: categoryTextField.rightAnchor,
                                  height: 1)
        
        addSubview(titleTextField)
        titleTextField.anchor(top: categoryTextField.bottomAnchor,
                              left: leftAnchor,
                              right: rightAnchor,
                              paddingTop: 42,
                              paddingLeft: 30,
                              paddingRight: 30,
                              height: 50)
        
        titleTextField.addSubview(titleTextFieldPlaceholder)
        titleTextFieldPlaceholder.anchor(top: titleTextField.topAnchor,
                                         left: titleTextField.leftAnchor,
                                         paddingTop: 5,
                                         paddingLeft: 5)
        
        let titleBottomView = UIView()
        titleBottomView.backgroundColor = .white
        addSubview(titleBottomView)
        titleBottomView.anchor(left: titleTextField.leftAnchor,
                               bottom: titleTextField.bottomAnchor,
                               right: titleTextField.rightAnchor,
                               height: 1)
        
        addSubview(registerButton)
        registerButton.setTitleColor(.white, for: .normal)
        registerButton.anchor(top: titleTextField.bottomAnchor,
                              left: leftAnchor,
                              right: rightAnchor,
                              paddingTop: 80,
                              paddingLeft: 20,
                              paddingRight: 20,
                              height: 60)
    }
    
    func createTextView() -> UITextView {
        let tv = UITextView()
//        tv.textContainerInset = UIEdgeInsets(top: 15, left: 10, bottom: 10, right: 10)
//        tv.layer.cornerRadius = 20
        tv.tintColor = .lightGray
        tv.font = UIFont.systemFont(ofSize: 18)
        tv.backgroundColor = .customGreen()
        tv.delegate = self
        return tv
    }
    
    func createLabel(text: String) -> UILabel {
        let label = UILabel()
        let attributes: [NSAttributedString.Key: Any] = [.foregroundColor: UIColor.lightGray,
                                                         .font: UIFont.banana(size: 18),
                                                         .kern: 1]
        label.attributedText = NSAttributedString(string: text, attributes: attributes)
        return label
    }
    
    func removeViews(views: [UIView]) {
        views.forEach { $0.removeFromSuperview() }
    }
}

// MARK: - UITextViewDelegate

extension CustomActionSheet: UITextViewDelegate {
    
    func textViewDidChange(_ textView: UITextView) {
        switch textView {
        case storyTextView:
            placeholderLabel.isHidden = !textView.text.isEmpty
            
            let attributes: [NSAttributedString.Key: Any] = [.foregroundColor: UIColor.customGreen(),
                                                             .font: UIFont.banana(size: 18),
                                                             .kern: 1]
            
            textView.attributedText = NSAttributedString(string: textView.text, attributes: attributes)
            
            let countAttributedText = NSMutableAttributedString(string: "\(textView.text.count)", attributes: attributes)
            countAttributedText.append(NSAttributedString(string: "/140", attributes: attributes))
            countLabel.attributedText = countAttributedText
            
            if textView.text.count > 140 { textView.deleteBackward() }
            
        case categoryTextField:
            categoryTextFieldPlaceholder.isHidden = !textView.text.isEmpty
            
            let attributes: [NSAttributedString.Key: Any] = [.foregroundColor: UIColor.white,
                                                             .font: UIFont.banana(size: 18),
                                                             .kern: 1]
            
            textView.attributedText = NSAttributedString(string: textView.text, attributes: attributes)
            
        case titleTextField:
            titleTextFieldPlaceholder.isHidden = !textView.text.isEmpty
            
            let attributes: [NSAttributedString.Key: Any] = [.foregroundColor: UIColor.white,
                                                             .font: UIFont.banana(size: 18),
                                                             .kern: 1]
            
            textView.attributedText = NSAttributedString(string: textView.text, attributes: attributes)
            
        default:
            break
        }
    }
}

// MARK: - UITextViewDelegate

extension CustomActionSheet: UITextFieldDelegate {
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        let attributes: [NSAttributedString.Key: Any] = [.foregroundColor: UIColor.white,
                                                         .font: UIFont.banana(size: 18),
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
