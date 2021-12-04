import UIKit

protocol BeginStoryViewCellDelegate {
    func registerStory(cell: BeginStoryViewCell)
}

class BeginStoryViewCell: UICollectionViewCell {
    
    // MARK: - Properties
    
    public var delegate: BeginStoryViewCellDelegate?
    
    public lazy var textView = UITextView.createRegisterStoryTextView()
    public lazy var registerButton = UIButton.createTextButton(text: "register", target: self, action: #selector(didTapRegisterButton))
    private let placeholderLabel = UILabel.createLabel(text: "Lets's start story", size: 16, alignment: .left)
    private let countLabel = UILabel.createLabel(text: "0 / 140", size: 16, alignment: .right)
    
    // MARK: - LifeCycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(registerButton)
        registerButton.anchor(bottom: bottomAnchor,
                              paddingBottom: 20)
        registerButton.setDimensions(height: 60, width: 180)
        registerButton.centerX(inView: self)
        
        textView.becomeFirstResponder()
        textView.delegate = self
        
        addSubview(textView)
        textView.anchor(top: topAnchor,
                        left: leftAnchor,
                        bottom: registerButton.topAnchor,
                        right: rightAnchor,
                        paddingLeft: 10,
                        paddingBottom: 20,
                        paddingRight: 10)
        
        textView.addSubview(placeholderLabel)
        placeholderLabel.anchor(top: textView.topAnchor,
                                left: textView.leftAnchor,
                                paddingLeft: 10)
        placeholderLabel.setDimensions(height: 40, width: frame.width)
        
        textView.addSubview(countLabel)
        countLabel.anchor(bottom: registerButton.topAnchor,
                          right: rightAnchor,
                          paddingBottom: 30, 
                          paddingRight: 20)
        countLabel.setDimensions(height: 20, width: frame.width)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Action
    
    @objc func didTapRegisterButton() {
        delegate?.registerStory(cell: self)
    }
}

// MARK: - UITextViewDelegate

extension BeginStoryViewCell: UITextViewDelegate {
    
    func textViewDidChangeSelection(_ textView: UITextView) {
        placeholderLabel.isHidden = !textView.text.isEmpty
        
        countLabel.text = "\(textView.text.count) / 140"
        if textView.text.count > 140 { textView.deleteBackward() }
    }
}
