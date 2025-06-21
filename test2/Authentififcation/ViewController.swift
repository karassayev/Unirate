//
//  ViewController.swift
//  test1
//
//  Created by Dias Karassayev on 3/3/25.
//

import UIKit
import SnapKit

class ViewController: UIViewController {
        private lazy var headerView: UIView = {
            let headerView = UIView()
            headerView.backgroundColor = UIColor(patternImage: UIImage(named: "back1")!)
            return headerView
        }()
    
    private lazy var logoContainer: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 20
        return view
    }()
    
    private lazy var logoLabel: UILabel = {
        let label = UILabel()
        label.text = "Unirate"
        label.textColor = .darkGray
        label.font = UIFont.boldSystemFont(ofSize: 16)
        return label
    }()
    
    private lazy var starIcon: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "logo")
        imageView.tintColor = .darkGray
        return imageView
    }()
    
    private lazy var welcomeLabel: UILabel = {
        let label = UILabel()
        label.text = "Welcome to UniRate!"
        label.textColor = .white
        label.font = UIFont(name: "Poppins-Bold", size: 28)
        label.textAlignment = .center
        return label
    }()
    
    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.text = "Find and compare universities in Kazakhstan—quick, easy, and all in one place"
        label.textColor = .white
        label.font = UIFont(name: "Poppins-Regular", size: 18)
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var welcomeBackLabel: UILabel = {
        let label = UILabel()
        label.text = "Welcome back!"
        label.textColor = .black
        label.font = UIFont(name: "Poppins-Bold", size: 30)
        return label
    }()
    
    private lazy var emailTextField = UITextField.createTextField(placeholder: "Enter your email")
    
    private lazy var passwordTextField = UITextField.createTextField(placeholder: "Enter your password", isSecure: true)
    
    private lazy var forgotPasswordButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Forgot Password?", for: .normal)
        button.setTitleColor(.gray, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 12)
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(forgotPasswordButtonTap))
        button.addGestureRecognizer(tapGesture)
        return button
    }()
    
    private lazy var signInButton = UIButton.createButton(title: "Sign In", color: UIColor.customGreen, textColor: .white) {
        self.signInButtonTapped()
    }
    
    private lazy var signUpLabel: UILabel = {
        let label = UILabel()
        label.text = "Don't have an account? Sign Up"
        label.textColor = .gray
        label.font =  UIFont(name: "Poppins-Bold", size: 14)
        let attributedString = NSMutableAttributedString(string: label.text!)
        attributedString.addAttribute(.foregroundColor, value: UIColor.black, range: NSRange(location: 23, length: 7))
        label.attributedText = attributedString
        label.textAlignment = .center
        label.isUserInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleSignUpLabelTap))
        label.addGestureRecognizer(tapGesture)
        return label
    }()
    @objc private func handleSignUpLabelTap() {
        let signUpViewController = CreateAccountVC()
//        let signUpViewController = TabBarController()
        signUpViewController.modalPresentationStyle = .fullScreen // Optional, for full-screen transition
        present(signUpViewController, animated: true, completion: nil)
    }
    @objc private func forgotPasswordButtonTap() {
//        let signUpViewController = ForgotPasswordViewController()
//        
//        navigationController?.pushViewController(signUpViewController, animated: true)
    }
    func signInButtonTapped() {
        
        TokenManager.shared.clearToken()

        guard let email = emailTextField.text, !email.isEmpty,
              let password = passwordTextField.text, !password.isEmpty else {
            showAlert(title: "Error", message: "Please enter email and password.")
            return
        }
        AuthService.shared.login(email: email, password: password) { result in
            switch result {
            case .success(let token):
                DispatchQueue.main.async {
                    self.showAlert(title: "Success", message: "✅ Logged in ✅", completion: {
                        let profileVC = TabBarController()
                        profileVC.modalPresentationStyle = .fullScreen
                        self.present(profileVC, animated: true)
                    })
                }
                AuthService.shared.getCurrentUser { result in
                                    switch result {
                                    case .success(let user):
//                                        print("✅ Got user:", user)
                                        UserManager.shared.currentUser = user
                                    case .failure(let error):
                                        print("❌ Error:", error)
                                    }
                                }
                
            case .failure(let error):
                self.showAlert(title: "Error", message: error.localizedDescription)
            }
        }

    }

    // Helper function to show alert messages
    func showAlert(title: String, message: String, completion: (() -> Void)? = nil) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default) { _ in
            completion?()
        }
        alert.addAction(okAction)
        alert.view.tintColor = UIColor.customGreen
        present(alert, animated: true)
    }
    
    // Helper function to show alert messages
    private func showAlert(message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }


    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        emailTextField.text = "diaskarassayev20@gmail.com"
        passwordTextField.text = "12345"
        setupUI()
    }
}
//MARK: - Setup UI
private extension ViewController {
    func setupUI() {
        setupViews()
        setupConstraints()
    }

    func setupViews() {
        view.addSubview(headerView)
        headerView.addSubview(logoContainer)
        logoContainer.addSubview(starIcon)
        logoContainer.addSubview(starIcon)
        logoContainer.addSubview(logoLabel)
        headerView.addSubview(welcomeLabel)
        headerView.addSubview(descriptionLabel)
        view.addSubview(welcomeBackLabel)
        view.addSubview(emailTextField)
        view.addSubview(passwordTextField)
        view.addSubview(forgotPasswordButton)
        view.addSubview(signInButton)
        view.addSubview(signUpLabel)
    }
            
    func setupConstraints() {
        headerView.snp.makeConstraints { make in
            make.top.equalToSuperview() // position below the Dynamic Island
            make.leading.trailing.equalTo(view.safeAreaLayoutGuide) // safe area layout for leading and trailing edges
            make.height.equalTo(view.snp.height).multipliedBy(0.3) // set height as 30% of the safe area height
        }
                
                logoContainer.snp.makeConstraints { make in
                    make.centerX.equalToSuperview()
                    make.top.equalToSuperview().offset(60)
                    make.width.equalTo(100)
                    make.height.equalTo(40)
                }
                
                starIcon.snp.makeConstraints { make in
                    make.leading.equalToSuperview().offset(10)
                    make.centerY.equalToSuperview()
                    make.width.height.equalTo(20)
                }
                
                logoLabel.snp.makeConstraints { make in
                    make.leading.equalTo(starIcon.snp.trailing).offset(10)
                    make.centerY.equalToSuperview()
                }
                
                welcomeLabel.snp.makeConstraints { make in
                    make.top.equalTo(logoContainer.snp.bottom).offset(20)
                    make.leading.trailing.equalToSuperview().inset(20)
                }
                
                descriptionLabel.snp.makeConstraints { make in
                    make.top.equalTo(welcomeLabel.snp.bottom).offset(10)
                    make.leading.trailing.equalToSuperview().inset(20)
                }
                
                welcomeBackLabel.snp.makeConstraints { make in
                    make.top.equalTo(headerView.snp.bottom).offset(30)
                    make.leading.trailing.equalToSuperview().inset(20)
                }
                
                emailTextField.snp.makeConstraints { make in
                    make.top.equalTo(welcomeBackLabel.snp.bottom).offset(50)
                    make.leading.trailing.equalToSuperview().inset(20)
                    make.height.equalTo(50)
                }
                
                passwordTextField.snp.makeConstraints { make in
                    make.top.equalTo(emailTextField.snp.bottom).offset(20)
                    make.leading.trailing.equalToSuperview().inset(20)
                    make.height.equalTo(50)
                }
                
                forgotPasswordButton.snp.makeConstraints { make in
                    make.top.equalTo(passwordTextField.snp.bottom).offset(10)
                    make.trailing.equalToSuperview().inset(20)
                }
                
                signInButton.snp.makeConstraints { make in
                    make.top.equalTo(forgotPasswordButton.snp.bottom).offset(20)
                    make.leading.trailing.equalToSuperview().inset(20)
                    make.height.equalTo(50)
                }
                
                signUpLabel.snp.makeConstraints { make in
                    make.bottom.equalToSuperview().inset(60)
                    make.leading.trailing.equalToSuperview().inset(20)
                }
            }
        }
