//
//  CreateAccount.swift
//  test1
//
//  Created by Dias Karassayev on 3/3/25.
//

//
//  SignUpViewController.swift
//  UniRate
//
//  Created by Dias Karassayev on 2/28/25.
//

import UIKit
import SnapKit

class CreateAccountVC: UIViewController {
    
    // MARK: - UI Components
    
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.alwaysBounceVertical = true
        return scrollView
    }()
    
    private lazy var containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 10
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 0.1
        view.layer.shadowOffset = CGSize(width: 0, height: 4)
        view.layer.shadowRadius = 10
        return view
    }()
    
    private lazy var headerView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(patternImage: UIImage(named: "back1")!)
        return view
    }()
    
    private lazy var logoView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 20
        return view
    }()
    
    private lazy var logoImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(systemName: "star.fill"))
        imageView.tintColor = .black
        return imageView
    }()
    
    private lazy var logoLabel = UILabel.createLabel(size: 18, color: .white, font: "Poppins-Bold", text: "LOGO")
    
    private lazy var welcomeLabel = UILabel.createLabel(size: 24, color: .white, font: "Poppins-Bold", text: "Welcome to UniRate!")
    
    private lazy var descriptionLabel = UILabel.createLabel(size: 14, color: .white, font: "Poppins-Regular", text: "Join us to explore more!")
    
    private lazy var formView: UIView = {
        let view = UIView()
        return view
    }()
    
    private lazy var createAccountLabel = UILabel.createLabel(size: 24, color: .black, font: "Poppins-Bold", text: "Create your account")
    private lazy var subTitleLabel = UILabel.createLabel(size: 16, color: .gray, font: "Poppins-Regular", text: "It's free and easy")
    
    
    private lazy var fullNameTextField = UITextField.createTextField(placeholder: "Enter your name")
    
    private lazy var emailTextField = UITextField.createTextField(placeholder: "Type your e-mail")
    
    private lazy var passwordTextField = UITextField.createTextField(placeholder: "Type your password")
    
    private lazy var passwordHintLabel = UILabel.createLabel(size: 12, color: .gray, font: "Poppins-Regular", text: "Must be 8 characters at least")
    
    private lazy var signInLabel: UILabel = {
        let label = UILabel()
        let text = "Already have an account? Sign In"

        let attributedText = NSMutableAttributedString(string: text)

        let fullRange = NSRange(location: 0, length: text.count)
        let signInRange = (text as NSString).range(of: "Sign In")

        let regularFont = UIFont(name: "Poppins-Regular", size: 12) ?? UIFont.systemFont(ofSize: 12)
        let boldFont = UIFont(name: "Poppins-Bold", size: 12) ?? UIFont.boldSystemFont(ofSize: 12)

        // Apply base style
        attributedText.addAttribute(.font, value: regularFont, range: fullRange)
        attributedText.addAttribute(.foregroundColor, value: UIColor.gray, range: fullRange)

        // Apply bold to "Sign In"
        attributedText.addAttribute(.font, value: boldFont, range: signInRange)

        label.attributedText = attributedText
        label.isUserInteractionEnabled = true
        label.numberOfLines = 0

        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(signInTapped))
        label.addGestureRecognizer(tapGesture)

        return label
    }()
    @objc private func signInTapped(_ gesture: UITapGestureRecognizer) {
        guard let label = gesture.view as? UILabel else { return }
        let text = label.text ?? ""
        let signInRange = (text as NSString).range(of: "Sign In")

        let layoutManager = NSLayoutManager()
        let textContainer = NSTextContainer(size: label.bounds.size)
        let textStorage = NSTextStorage(attributedString: label.attributedText ?? NSAttributedString())

        layoutManager.addTextContainer(textContainer)
        textStorage.addLayoutManager(layoutManager)

        textContainer.lineFragmentPadding = 0
        textContainer.lineBreakMode = label.lineBreakMode
        textContainer.maximumNumberOfLines = label.numberOfLines

        let location = gesture.location(in: label)
        let index = layoutManager.characterIndex(for: location, in: textContainer, fractionOfDistanceBetweenInsertionPoints: nil)

        if NSLocationInRange(index, signInRange) {
            // 👉 Present your new ViewController here
            let vc = ViewController()
            vc.modalPresentationStyle = .fullScreen
            self.present(vc, animated: true, completion: nil)
        }
    }

    private lazy var termsCheckBox: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "square"), for: .normal)
        button.tintColor = .black
        button.addTarget(self, action: #selector(toggleCheckbox), for: .touchUpInside)
        return button
    }()

    private lazy var termsLabel: UILabel = {
        let label = UILabel()
        let text = "By creating an account means you agree to the Terms and Conditions, and our Privacy Policy."

        let attributedString = NSMutableAttributedString(string: text)

        let termsRange = (text as NSString).range(of: "Terms and Conditions")
        let privacyRange = (text as NSString).range(of: "Privacy Policy")

        // Apply regular font to entire string first
        let regularFont = UIFont(name: "Poppins-Regular", size: 12) ?? UIFont.systemFont(ofSize: 12)
        let boldFont = UIFont(name: "Poppins-Bold", size: 12) ?? UIFont.boldSystemFont(ofSize: 12)

        attributedString.addAttribute(.font, value: regularFont, range: NSRange(location: 0, length: text.count))

        // Then apply bold only to keywords
        attributedString.addAttribute(.font, value: boldFont, range: termsRange)
        attributedString.addAttribute(.font, value: boldFont, range: privacyRange)

        // Optional: keep the text color consistent
        attributedString.addAttribute(.foregroundColor, value: UIColor.black, range: NSRange(location: 0, length: text.count))

        label.attributedText = attributedString
        label.numberOfLines = 0
        label.isUserInteractionEnabled = true

        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTermsTap))
        label.addGestureRecognizer(tapGesture)

        return label
    }()

    @objc private func toggleCheckbox() {
        let isChecked = termsCheckBox.currentImage == UIImage(systemName: "checkmark.square")
        let newImage = isChecked ? UIImage(systemName: "square") : UIImage(systemName: "checkmark.square")
        termsCheckBox.setImage(newImage, for: .normal)
        
        // Enable sign-up button only if checkbox is selected
        signUpButton.isEnabled = !isChecked
        signUpButton.backgroundColor = !isChecked ? UIColor.customGreen : UIColor.lightGray
    }

    @objc private func handleTermsTap() {
        let signUpViewController = TermsAndConditions()
        self.present(signUpViewController, animated: true, completion: nil)

    }


    // Modify Sign Up Button to be initially disabled
    private lazy var signUpButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Sign Up", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = UIColor.lightGray
        button.layer.cornerRadius = 25
        button.isEnabled = false
        button.addTarget(self, action: #selector(handleSignUp), for: .touchUpInside)
        return button
    }()

    
    @objc private func handleSignUp() {
        guard let username = fullNameTextField.text, !username.isEmpty,
              let email = emailTextField.text, !email.isEmpty,
              let password = passwordTextField.text, !password.isEmpty else {
            showAlert(title: "Error", message: "All fields are required.")
            return
        }

        AuthService.shared.register(username: username, password: password, email: email) { result in
            DispatchQueue.main.async {
                switch result {
                case .success:
                    self.showAlert(title: "Success", message: "✅ Registration Success: Registration successful.") {
                        let signUpViewController = ConfirmEmailVC()
                        signUpViewController.modalPresentationStyle = .fullScreen
                        self.present(signUpViewController, animated: true, completion: nil)
                    }
                case .failure(let error):
                    self.showAlert(title: "Error", message: error.localizedDescription)
                }
            }
        }
    }
    private func showAlert(title: String, message: String, completion: (() -> Void)? = nil) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default) { _ in
            completion?()
        })
        present(alert, animated: true)
    }
    

    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()

    }
    
    // MARK: - UI Setup
    
    private func setupUI() {
        view.backgroundColor = .systemGray6
        setupViews()
        setupConstraints()
    }
}
private extension CreateAccountVC{

    private func setupViews() {
        view.addSubview(scrollView)
        scrollView.addSubview(containerView)
        
        containerView.addSubview(headerView)
        headerView.addSubview(logoView)
        logoView.addSubview(logoImageView)
        headerView.addSubview(logoLabel)
        headerView.addSubview(welcomeLabel)
        headerView.addSubview(descriptionLabel)
        
        containerView.addSubview(formView)
        formView.addSubview(createAccountLabel)
        formView.addSubview(subTitleLabel)
        formView.addSubview(fullNameTextField)
        formView.addSubview(emailTextField)
        formView.addSubview(passwordTextField)
        formView.addSubview(passwordHintLabel)
        formView.addSubview(signUpButton)
        formView.addSubview(signInLabel)
        formView.addSubview(termsCheckBox)
        formView.addSubview(termsLabel)
    }
    
    private func setupConstraints() {
        scrollView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        containerView.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.left.right.equalTo(view)
            make.width.equalTo(view)
        }
        
        headerView.snp.makeConstraints { make in
            make.top.left.right.equalToSuperview()
            make.height.equalTo(view.snp.height).multipliedBy(0.3) // set height as 30% of the safe area height
        }
        
        logoView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(20)
            make.width.height.equalTo(40)
        }
        
        logoImageView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.height.equalTo(20)
        }
        
        logoLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(logoView.snp.bottom).offset(10)
        }
        
        welcomeLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(logoLabel.snp.bottom).offset(10)
        }
        
        descriptionLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(welcomeLabel.snp.bottom).offset(10)
            make.left.right.equalToSuperview().inset(20)
        }
        
        formView.snp.makeConstraints { make in
            make.top.equalTo(headerView.snp.bottom).offset(20)
            make.left.right.equalToSuperview().inset(20)
            make.bottom.equalToSuperview().offset(-20)
        }
        
        createAccountLabel.snp.makeConstraints { make in
            make.top.left.equalToSuperview()
        }
        
        subTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(createAccountLabel.snp.bottom).offset(5)
            make.left.equalToSuperview()
        }
        
        fullNameTextField.snp.makeConstraints { make in
            make.top.equalTo(subTitleLabel.snp.bottom).offset(20)
            make.left.right.equalToSuperview()
            make.height.equalTo(50)
        }
        
        emailTextField.snp.makeConstraints { make in
            make.top.equalTo(fullNameTextField.snp.bottom).offset(20)
            make.left.right.equalToSuperview()
            make.height.equalTo(50)
        }
        
        passwordTextField.snp.makeConstraints { make in
            make.top.equalTo(emailTextField.snp.bottom).offset(20)
            make.left.right.equalToSuperview()
            make.height.equalTo(50)
        }
        
        passwordHintLabel.snp.makeConstraints { make in
            make.top.equalTo(passwordTextField.snp.bottom).offset(5)
            make.left.equalToSuperview()
        }
        
        signUpButton.snp.makeConstraints { make in
            make.top.equalTo(passwordHintLabel.snp.bottom).offset(20)
            make.left.right.equalToSuperview()
            make.height.equalTo(50)
        }
        
        signInLabel.snp.makeConstraints { make in
            make.top.equalTo(signUpButton.snp.bottom).offset(20)
            make.bottom.equalToSuperview()
            make.centerX.equalToSuperview()
        }
        termsCheckBox.snp.makeConstraints { make in
            make.top.equalTo(passwordHintLabel.snp.bottom).offset(15)
            make.left.equalToSuperview()
            make.width.height.equalTo(20)
        }

        termsLabel.snp.makeConstraints { make in
            make.centerY.equalTo(termsCheckBox)
            make.left.equalTo(termsCheckBox.snp.right).offset(10)
            make.right.equalToSuperview()
        }
        signUpButton.snp.remakeConstraints { make in
            make.top.equalTo(termsCheckBox.snp.bottom).offset(20)
            make.left.right.equalToSuperview()
            make.height.equalTo(50)
        }
    }
}
