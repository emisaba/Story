import UIKit

protocol BeginStoryViewCellDelegate {
    func registerStory(cell: BeginStoryViewCell)
}

class BeginStoryViewCell: UICollectionViewCell {
    
    // MARK: - Properties
    
    public var delegate: BeginStoryViewCellDelegate?
    
    public lazy var textView = UITextView.createRegisterStoryTextView()
    private let placeholderLabel = UILabel.createLabel(text: "ストーリーを入力してください...", size: 18, alignment: .left)
    private let countLabel = UILabel.createLabel(text: "0/140", size: 16, alignment: .right)
    
    public lazy var registerButton: UIButton = {
        let button = UIButton()
        let attributes: [NSAttributedString.Key: Any] = [.foregroundColor: UIColor.white, .kern: 1, .font: UIFont.senobi(size: 20)]
        let attributedText = NSAttributedString(string: "登録", attributes: attributes)
        button.setAttributedTitle(attributedText, for: .normal)
        button.backgroundColor = .clear
        button.setTitleColor(.white, for: .normal)
        button.layer.borderWidth = 2
        button.layer.borderColor = UIColor.white.cgColor
        button.layer.cornerRadius = 30
        button.addTarget(self, action: #selector(didTapRegisterButton), for: .touchUpInside)
        return button
    }()
    
    private lazy var toolBar: UIToolbar = {
        let toolBar = UIToolbar()
        toolBar.sizeToFit()
        let spacer = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: self, action: nil)
        let doneButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.done, target: self, action: #selector(doneEditing))
        toolBar.items = [spacer, doneButton]
        return toolBar
    }()
    
    // MARK: - LifeCycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .clear
        
        addSubview(registerButton)
        registerButton.anchor(bottom: bottomAnchor)
        registerButton.setDimensions(height: 60, width: 120)
        registerButton.centerX(inView: self)
        
        textView.becomeFirstResponder()
        textView.delegate = self
        textView.inputAccessoryView = toolBar
        
        addSubview(textView)
        textView.anchor(top: topAnchor,
                        left: leftAnchor,
                        bottom: registerButton.topAnchor,
                        right: rightAnchor,
                        paddingLeft: 10,
                        paddingBottom: 30,
                        paddingRight: 10)
        textView.layer.cornerRadius = 20
        
        textView.addSubview(placeholderLabel)
        placeholderLabel.anchor(top: textView.topAnchor,
                                left: textView.leftAnchor,
                                paddingTop: 15,
                                paddingLeft: 15)
        
        textView.addSubview(countLabel)
        countLabel.anchor(bottom: registerButton.topAnchor,
                          right: rightAnchor,
                          paddingBottom: 45,
                          paddingRight: 25)
        countLabel.setDimensions(height: 20, width: frame.width)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Action
    
    @objc func didTapRegisterButton() {
        delegate?.registerStory(cell: self)
    }
    
    @objc func doneEditing() {
        endEditing(true)
    }
}

// MARK: - UITextViewDelegate

extension BeginStoryViewCell: UITextViewDelegate {
    
    func textViewDidChangeSelection(_ textView: UITextView) {
        placeholderLabel.isHidden = !textView.text.isEmpty
        
        let attributes: [NSAttributedString.Key: Any] = [.foregroundColor: UIColor.customGreen(),
                                                                 .font: UIFont.banana(size: 18),
                                                                 .kern: 1]
        
        textView.attributedText = NSAttributedString(string: textView.text, attributes: attributes)
        
        let countAttributedText = NSMutableAttributedString(string: "\(textView.text.count)", attributes: attributes)
        countAttributedText.append(NSAttributedString(string: "/140", attributes: attributes))
        countLabel.attributedText = countAttributedText
        
        if textView.text.count > 140 { textView.deleteBackward() }
    }
}
