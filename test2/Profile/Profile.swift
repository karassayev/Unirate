//
//  Profile.swift
//  test1
//
//  Created by Dias Karassayev on 3/3/25.
//

//


import UIKit
import SnapKit
import Kingfisher

class Profile: UIViewController{
        private let headerView = HeaderView()

        private let dropdownOptions = ["Student", "Teacher"]
    
        private lazy var scrollView: UIScrollView = {
            let scrollView = UIScrollView()
            scrollView.showsVerticalScrollIndicator = false
            return scrollView
        }()
    
        private lazy var contentView: UIView = {
            let view = UIView()
            return view
        }()
        private lazy var profileView: UIView = {
            let view = UIView()
            return view
        }()
        private lazy var profileImage: UIImageView = {
             let imageView = UIImageView()
             imageView.image = UIImage(named: "profile")
             imageView.contentMode = .scaleAspectFill
            imageView.layer.cornerRadius = 62
            imageView.clipsToBounds = true
             return imageView
         }()
        private lazy var penImage: UIImageView = {
             let imageView = UIImageView()
             imageView.image = UIImage(named: "pen")
             imageView.contentMode = .scaleAspectFill
             imageView.clipsToBounds = true
             return imageView
         }()
        
    func changeAvatar(urlAvatar: String?){
        DispatchQueue.main.async {
            if let url = urlAvatar{
                self.profileImage.kf.setImage(with: URL(string: url))
                UserManager.shared.currentUser?.userProfileImageUrl = url
            }
        }
    }

    
        private lazy var titleLabel = UILabel.createLabel(size: 24, color: .black, font: "Poppins-Bold", text: "Personal Info")
        private lazy var changeLabel = UILabel.createLabel(size: 16, color: UIColor.customGreen, font: "Poppins-Bold", text: "Change", target: self, action: #selector(labelTapped))

        private lazy var accountLabel = UILabel.createLabel(size: 16, color: .black, font: "Poppins-Regular", text: "Account Info")
        private lazy var firstNameLabel = UILabel.createLabel(size: 14, color: .black, font: "Poppins-Regular", text: "First Name")
        private lazy var lastNameLabel = UILabel.createLabel(size: 14, color: .black, font: "Poppins-Regular", text: "Last Name")
        private lazy var emailLabel = UILabel.createLabel(size: 14, color: .black, font: "Poppins-Regular", text: "Email")
        private lazy var phoneLabel = UILabel.createLabel(size: 14, color: .black, font: "Poppins-Regular", text: "Phone")
        private lazy var categoryLabel = UILabel.createLabel(size: 14, color: .black, font: "Poppins-Regular", text: "Category")
        private lazy var loginAndSecurityLabel = UILabel.createLabel(size: 24, color: .black, font: "Poppins-Regular", text: "Login and security")
        private lazy var loginLabel = UILabel.createLabel(size: 24, color: .black, font: "Poppins-Bold", text: "Login")
        private lazy var passwordLabel = UILabel.createLabel(size: 14, color: .black, font: "Poppins-Regular", text: "Password")
        private lazy var lastUpdatedLabel = UILabel.createLabel(size: 12, color: .lightGray, font: "Poppins-Regular", text: "Last updated 1 month ago")
        private lazy var cancelLabel = UILabel.createLabel(size: 16, color: UIColor.customGreen, font: "Poppins-Bold", text: "Cancel")
        
    private lazy var firstNameTextField = UITextField.createTextField(placeholder: UserManager.shared.currentUser?.firstName ?? "First Name")
    private lazy var lastNameTextField = UITextField.createTextField(placeholder: UserManager.shared.currentUser?.lastName ?? "Last Name")
    private lazy var emailTextField = UITextField.createTextField(placeholder: UserManager.shared.currentUser?.email ?? "Email", imageName: "mail")
    private lazy var phoneTextField = UITextField.createTextField(placeholder: UserManager.shared.currentUser?.telephone ?? "Phone", imageName: "phone")
    
    private lazy var categoryDropDown = UIButton.createDropDown(data: dropdownOptions)
    
    private lazy var updateProfileButton = UIButton.createButton(title: "Update Profile", color: UIColor.customGreen, textColor: .white) { [weak self] in
        guard let self = self else { return }

        guard let currentUser = UserManager.shared.currentUser else {
            print("❌ No current user available")
            return
        }

        // Составляем обновленного пользователя с данными из текстовых полей
        let updatedUser = User(
            id: currentUser.id,
            username: currentUser.username,  // Оставляем текущий username
            password: currentUser.password,  // Сохраняем текущий пароль
            email: self.emailTextField.text ?? currentUser.email,  // Обновляем email, если он введён
            firstName: self.firstNameTextField.text ?? currentUser.firstName,  // Обновляем имя
            lastName: self.lastNameTextField.text ?? currentUser.lastName,  // Обновляем фамилию
            role: currentUser.role,  // Оставляем текущую роль
            telephone: self.phoneTextField.text ?? currentUser.telephone,  // Обновляем телефон
            status: currentUser.status,  // Оставляем статус
            userProfileImageUrl: currentUser.userProfileImageUrl  // Сохраняем URL изображения профиля
        )

        // Вызываем функцию обновления пользователя
        AuthService.shared.updateUser(updatedUser: updatedUser) { result in
            switch result {
            case .success(let message):
                print("User update success: \(message)")

                // Обновляем данные текущего пользователя
                UserManager.shared.currentUser = updatedUser

                // Обновляем текст в текстовых полях
                self.firstNameTextField.text = updatedUser.firstName
                self.lastNameTextField.text = updatedUser.lastName
                self.emailTextField.text = updatedUser.email
                self.phoneTextField.text = updatedUser.telephone

            case .failure(let error):
                print("Error updating user: \(error.localizedDescription)")
            }
        }
    }


    func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
        private lazy var updatePasswordButton = UIButton.createButton(title: "Update Password", color: .white, textColor: UIColor.customGreen) {
            self.showPopup()  // Call showPopup when the button is pressed
        }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        setupUI()
        
        print(UserManager.shared.currentUser)
    }
}
extension Profile {
    func setupUI() {
        setupViews()
        setupConstraints()
    }
    func setupViews() {
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        contentView.addSubview(headerView)
        contentView.addSubview(profileView)
        
        profileView.addSubview(titleLabel)
        profileView.addSubview(profileImage)
        profileView.addSubview(penImage)
        profileView.addSubview(changeLabel)
        profileView.addSubview(accountLabel)
        profileView.addSubview(firstNameLabel)
        profileView.addSubview(firstNameTextField)
        profileView.addSubview(lastNameLabel)
        profileView.addSubview(lastNameTextField)
        profileView.addSubview(emailLabel)
        profileView.addSubview(emailTextField)
        profileView.addSubview(phoneLabel)
        profileView.addSubview(phoneTextField)
        profileView.addSubview(categoryLabel)
        profileView.addSubview(categoryDropDown)
        profileView.addSubview(updateProfileButton)
        profileView.addSubview(cancelLabel)
        profileView.addSubview(loginAndSecurityLabel)
        profileView.addSubview(loginLabel)
        profileView.addSubview(passwordLabel)
        profileView.addSubview(lastUpdatedLabel)
        profileView.addSubview(updatePasswordButton)
    }
    
    func setupConstraints() {
        scrollView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        contentView.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview() // Set top and bottom to match scrollView's content size
            make.leading.trailing.equalTo(view)
        }
        headerView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.left.right.equalToSuperview()
            make.height.equalTo(60)
        }
        profileView.snp.makeConstraints { make in
            make.top.equalTo(headerView.snp.bottom).offset(30)
            make.leading.trailing.equalToSuperview().offset(16).inset(16)
            make.height.equalTo(view.snp.height).multipliedBy(1.3)
        }
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(headerView.snp.bottom).offset(30)
            make.centerX.equalToSuperview()
        }
        profileImage.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(30)
            make.size.equalTo(124)
            make.leading.equalToSuperview()
        }
        penImage.snp.makeConstraints { make in
            make.bottom.equalTo(profileImage.snp.bottom)
            make.size.equalTo(20)
            make.left.equalTo(profileImage.snp.right).offset(10)
        }
        changeLabel.snp.makeConstraints { make in
            make.left.equalTo(penImage.snp.right).offset(10)
            make.centerY.equalTo(penImage.snp.centerY)
        }
        accountLabel.snp.makeConstraints { make in
            make.top.equalTo(profileImage.snp.bottom).offset(20)
            make.leading.equalToSuperview()
        }
        firstNameLabel.snp.makeConstraints { make in
            make.top.equalTo(accountLabel.snp.bottom).offset(30)
            make.leading.equalToSuperview()
        }
        firstNameTextField.snp.makeConstraints { make in
            make.top.equalTo(firstNameLabel.snp.bottom).offset(10)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(48)
        }
        lastNameLabel.snp.makeConstraints { make in
            make.top.equalTo(firstNameTextField.snp.bottom).offset(16)
            make.leading.equalToSuperview()
        }
        lastNameTextField.snp.makeConstraints { make in
            make.top.equalTo(lastNameLabel.snp.bottom).offset(10)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(48)
        }
        emailLabel.snp.makeConstraints { make in
            make.top.equalTo(lastNameTextField.snp.bottom).offset(16)
            make.leading.equalToSuperview()
        }
        emailTextField.snp.makeConstraints { make in
            make.top.equalTo(emailLabel.snp.bottom).offset(10)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(48)
        }
        phoneLabel.snp.makeConstraints { make in
            make.top.equalTo(emailTextField.snp.bottom).offset(16)
            make.leading.equalToSuperview()
        }
        phoneTextField.snp.makeConstraints { make in
            make.top.equalTo(phoneLabel.snp.bottom).offset(10)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(48)
        }
        categoryLabel.snp.makeConstraints { make in
            make.top.equalTo(phoneTextField.snp.bottom).offset(16)
            make.leading.equalToSuperview()
        }
        categoryDropDown.snp.makeConstraints { make in
            make.top.equalTo(categoryLabel.snp.bottom).offset(10)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(60)
        }
        updateProfileButton.snp.makeConstraints { make in
            make.top.equalTo(categoryDropDown.snp.bottom).offset(45)
            make.leading.equalToSuperview()
            make.height.equalTo(48)
            make.width.equalToSuperview().multipliedBy(0.4)
        }
        cancelLabel.snp.makeConstraints { make in
            make.left.equalTo(updateProfileButton.snp.right).offset(20)
            make.centerY.equalTo(updateProfileButton.snp.centerY)
        }
        loginAndSecurityLabel.snp.makeConstraints { make in
            make.top.equalTo(updateProfileButton.snp.bottom).offset(60)
            make.leading.equalToSuperview()
        }
        loginLabel.snp.makeConstraints { make in
            make.top.equalTo(loginAndSecurityLabel.snp.bottom).offset(60)
            make.leading.equalToSuperview()
        }
        passwordLabel.snp.makeConstraints { make in
            make.top.equalTo(loginLabel.snp.bottom).offset(16)
            make.leading.equalToSuperview()
        }
        lastUpdatedLabel.snp.makeConstraints { make in
            make.top.equalTo(passwordLabel.snp.bottom).offset(16)
            make.leading.equalToSuperview()
        }
        updatePasswordButton.snp.makeConstraints { make in
            make.top.equalTo(lastUpdatedLabel.snp.bottom).offset(16)
            make.leading.equalToSuperview()
            make.height.equalTo(48)
            make.width.equalToSuperview().multipliedBy(0.45)
        }
       
        let lastSubview = [headerView, profileView].last!
        lastSubview.snp.makeConstraints { make in
            make.bottom.equalToSuperview().inset(tabBarController?.tabBar.frame.height ?? 0)
        }
    }
}

extension Profile{

    @objc func showPopup() {
        let popup = PopUpView(frame: view.bounds)
        view.addSubview(popup)
    }

    @objc private func labelTapped() {
        let popup = AvatarsChangeView(frame: view.bounds)
        
        popup.onChangePressed = { [weak self] selectedURL in
            self?.changeAvatar(urlAvatar: selectedURL)
        }
        
        view.addSubview(popup)
    }

}
