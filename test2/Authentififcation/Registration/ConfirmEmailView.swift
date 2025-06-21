import UIKit
import SnapKit

protocol EmailConfirmationViewDelegate: AnyObject {
    func didTapConfirmButton(withCode code: Int)
}

class ConfirmEmailView: UIView, UITextFieldDelegate {
    
    // MARK: - Properties
    weak var delegate: EmailConfirmationViewDelegate?
    
    // MARK: - UI Components
    
    private lazy var logoView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 20
        return view
    }()
    
    private lazy var logoIcon: UIImageView = {
        let imageView = UIImageView(image: UIImage(systemName: "star.fill"))
        imageView.tintColor = .black
        return imageView
    }()
    
    private lazy var titleLabel: UILabel = createLabel(fontSize: 24, textColor: .black, alignment: .center)
    private lazy var descriptionLabel: UILabel = createLabel(fontSize: 14, textColor: .gray, alignment: .center, numberOfLines: 0)
    private lazy var confirmEmailLabel: UILabel = createLabel(fontSize: 20, textColor: .black)
    private lazy var instructionLabel: UILabel = createLabel(fontSize: 14, textColor: .gray, alignment: .center, numberOfLines: 0)
    
    private lazy var codeTextFields: [UITextField] = (0..<4).map { _ in
        let textField = UITextField()
        textField.borderStyle = .roundedRect
        textField.textAlignment = .center
        textField.font = UIFont.systemFont(ofSize: 24)
        textField.keyboardType = .numberPad
        textField.delegate = self  // Set delegate
        return textField
    }

    
    lazy var codeStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: codeTextFields)
        stackView.axis = .horizontal
        stackView.spacing = 10
        stackView.distribution = .fillEqually
        return stackView
    }()
    
    private lazy var confirmButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Confirm", for: .normal)
        button.backgroundColor = UIColor.customGreen
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 10
        button.titleLabel?.font = UIFont(name: "Poppins-Bold", size: 18)
        button.addTarget(self, action: #selector(handleSignUp), for: .touchUpInside) // Add target for button tap
        return button
    }()
    
    private lazy var resendLabel: UILabel = {
        let label = createLabel(fontSize: 14, textColor: .gray, alignment: .center)
        return label
    }()
    private lazy var emailTextField: UITextField = {
        let textField = UITextField()
        textField.backgroundColor = .white
        textField.placeholder = "Enter your email here"
        textField.layer.cornerRadius = 20
        textField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 0)) // Padding
        textField.font = UIFont(name: "Poppins-Regular", size: 16)
        textField.textColor = .black
        textField.leftViewMode = .always
        textField.clearButtonMode = .whileEditing
        return textField
    }()
    // MARK: - Init
    
    init(title: String, description: String, instruction: String, resendText: String) {
        super.init(frame: .zero)
        self.titleLabel.text = title
        self.descriptionLabel.text = description
        self.instructionLabel.text = instruction
        self.resendLabel.text = resendText
        
        setupViews()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - UI Setup
    
    private func setupViews() {
        addSubview(logoView)
        logoView.addSubview(logoIcon)
        
        addSubview(titleLabel)
        addSubview(descriptionLabel)
        addSubview(confirmEmailLabel)
        addSubview(instructionLabel)
        addSubview(codeStackView)
        addSubview(confirmButton)
        addSubview(resendLabel)
        addSubview(emailTextField)
    }
    
    private func setupConstraints() {
        logoView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(20)
            make.centerX.equalToSuperview()
            make.width.height.equalTo(40)
        }
        
        logoIcon.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.height.equalTo(20)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(logoView.snp.bottom).offset(20)
            make.left.right.equalToSuperview().inset(20)
        }
        
        descriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(10)
            make.left.right.equalToSuperview().inset(20)
        }
        
        confirmEmailLabel.snp.makeConstraints { make in
            make.top.equalTo(descriptionLabel.snp.bottom).offset(30)
            make.left.right.equalToSuperview().inset(20)
        }
        
        instructionLabel.snp.makeConstraints { make in
            make.top.equalTo(confirmEmailLabel.snp.bottom).offset(10)
            make.left.right.equalToSuperview().inset(20)
        }
        
        codeStackView.snp.makeConstraints { make in
            make.top.equalTo(instructionLabel.snp.bottom).offset(20)
            make.centerX.equalToSuperview()
            make.width.equalTo(260)
            make.height.equalTo(60)
        }
        
        confirmButton.snp.makeConstraints { make in
            make.top.equalTo(codeStackView.snp.bottom).offset(20)
            make.left.right.equalToSuperview().inset(20)
            make.height.equalTo(50)
        }
        
        resendLabel.snp.makeConstraints { make in
            make.top.equalTo(confirmButton.snp.bottom).offset(20)
            make.left.right.equalToSuperview().inset(20)
        }
        
        emailTextField.snp.makeConstraints { make in
            make.top.equalTo(resendLabel.snp.bottom).offset(20)
            make.left.right.equalToSuperview().inset(20)
            make.height.equalTo(30)
        }
    }
    
    // MARK: - Helper Methods
    
    private func createLabel(fontSize: CGFloat, textColor: UIColor, alignment: NSTextAlignment = .left, numberOfLines: Int = 1) -> UILabel {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: fontSize)
        label.textColor = textColor
        label.textAlignment = alignment
        label.numberOfLines = numberOfLines
        return label
    }
    
    // MARK: - Helper Method to Get the Code
    private func getCode() -> Int? {
        // Join all text field values into a single string and trim any whitespace
        let codeString = codeTextFields.compactMap { $0.text?.trimmingCharacters(in: .whitespaces) }.joined()
        return Int(codeString) // Try to convert the string to an integer
    }

    // MARK: - Actions

    @objc private func handleSignUp() {
        // Get the code as an Int
        if let code = getCode() {
        delegate?.didTapConfirmButton(withCode: code) // Pass the code as an Int to the delegate
        } else {
            print("Invalid code") // Handle invalid code (e.g., non-numeric values)
            // Optionally, provide UI feedback like an alert or a message to the user
        }
    }

}
