import UIKit
import SnapKit

class PopUpView: UIView {
    
    private let containerView = UIView()
    private let titleLabel = UILabel.createLabel(size: 20, color: .black, font: "Poppins-Regular", text: "Create a new password ")
    private let closeButton = UIButton()
    private let oldPasswordLabel = UILabel.createLabel(size: 14, color: .black, font: "Poppins-Regular", text: "Current password")
    private let newPasswordLabel = UILabel.createLabel(size: 14, color: .black, font: "Poppins-Regular", text: "New password")
    private let confirmPasswordLabel = UILabel.createLabel(size: 14, color: .black, font: "Poppins-Regular", text: "Confirm new password")
    
    private let oldPasswordField = UITextField.createTextField(placeholder: "Enter you current password")
    private let newPasswordField = UITextField.createTextField(placeholder: "Enter your new password")
    private let confirmPasswordField = UITextField.createTextField(placeholder: "Re-enter your new password")
    
    private lazy var changeButton: UIButton = UIButton.createButton(
        title: "Save",
        color: UIColor.customGreen2,
        textColor: UIColor.customGreen,
        action: {
            self.signInButtonTapped()
        }
    )




    @objc func signInButtonTapped() {
        // Проверяем, что все поля заполнены и корректны
        guard let oldPassword = oldPasswordField.text, !oldPassword.isEmpty,
              let newPassword = newPasswordField.text, !newPassword.isEmpty,
              let confirmPassword = confirmPasswordField.text, !confirmPassword.isEmpty else {
            // Если одно из полей пустое, показываем ошибку или сообщение
            print("❌ All fields must be filled")
            return
        }

        // Проверяем, что новый пароль и подтверждение пароля совпадают
        guard newPassword == confirmPassword else {
            print("❌ Passwords do not match")
            return
        }

        // Получаем текущего пользователя
        guard var currentUser = UserManager.shared.currentUser else {
            print("❌ No current user available")
            return
        }

        // Обновляем только пароль
        currentUser.password = newPassword  // Обновляем только пароль

        // Обновляем пользователя через сервис
        AuthService.shared.updateUser(updatedUser: currentUser) { result in
            switch result {
            case .success(let message):
                print("User update success: \(message)")
                // Дополнительные действия после успешного обновления (например, показать сообщение об успехе)
                // Если нужно, обновляем данные текущего пользователя в UserManager
                UserManager.shared.currentUser = currentUser
            case .failure(let error):
                print("Error updating user: \(error.localizedDescription)")
                // Дополнительные действия после ошибки обновления (например, показать сообщение об ошибке)
            }
        }
    }


    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        animatePopup()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
        animatePopup()
    }

    private func animatePopup() {
        backgroundColor = UIColor.black.withAlphaComponent(0.0)
        containerView.alpha = 0
        containerView.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)

        UIView.animate(withDuration: 0.3) {
            self.backgroundColor = UIColor.black.withAlphaComponent(0.5)
            self.containerView.alpha = 1
            self.containerView.transform = .identity
        }
    }

    @objc private func dismiss() {
        UIView.animate(withDuration: 0.2, animations: {
            self.alpha = 0
        }) { _ in
            self.removeFromSuperview()
        }
    }
}
private extension PopUpView {
    
    func setupUI() {
        setupViews()
        setupConstraints()
    }

    func setupViews() {
        addSubview(containerView)
        containerView.backgroundColor = .white
        containerView.layer.cornerRadius = 20

        containerView.addSubview(titleLabel)
        
        // Close Button
        closeButton.setImage(UIImage(named: "close"), for: .normal)
        closeButton.tintColor = .black
        closeButton.layer.borderColor = UIColor.customGreen.cgColor
        closeButton.addTarget(self, action: #selector(dismiss), for: .touchUpInside)
        containerView.addSubview(closeButton)
        
        // Labels
        oldPasswordLabel.text = "Last password"
        newPasswordLabel.text = "New password"
        confirmPasswordLabel.text = "Confirm password"
        [oldPasswordLabel, newPasswordLabel, confirmPasswordLabel].forEach {
            $0.font = UIFont(name: "Poppins-Regular", size: 14)
            $0.textColor = .black
            containerView.addSubview($0)
        }

        // TextFields
        [oldPasswordField, newPasswordField, confirmPasswordField].forEach {
            containerView.addSubview($0)
        }
        containerView.addSubview(changeButton)
    }

    func setupConstraints() {
        containerView.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.leading.trailing.equalToSuperview().offset(16).inset(16)
            $0.height.equalTo(410)
        }

        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(20)
            $0.left.equalToSuperview().offset(20)
        }

        closeButton.snp.makeConstraints {
            $0.centerY.equalTo(titleLabel.snp.centerY)
            $0.right.equalToSuperview().inset(20)
            $0.width.height.equalTo(52)
        }

        oldPasswordLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(30)
            $0.left.equalToSuperview().offset(20)
        }

        oldPasswordField.snp.makeConstraints {
            $0.top.equalTo(oldPasswordLabel.snp.bottom).offset(6)
            $0.left.right.equalToSuperview().inset(20)
            $0.height.equalTo(40)
        }

        newPasswordLabel.snp.makeConstraints {
            $0.top.equalTo(oldPasswordField.snp.bottom).offset(12)
            $0.left.equalToSuperview().offset(20)
        }

        newPasswordField.snp.makeConstraints {
            $0.top.equalTo(newPasswordLabel.snp.bottom).offset(6)
            $0.left.right.equalToSuperview().inset(20)
            $0.height.equalTo(40)
        }

        confirmPasswordLabel.snp.makeConstraints {
            $0.top.equalTo(newPasswordField.snp.bottom).offset(12)
            $0.left.equalToSuperview().offset(20)
        }

        confirmPasswordField.snp.makeConstraints {
            $0.top.equalTo(confirmPasswordLabel.snp.bottom).offset(6)
            $0.left.right.equalToSuperview().inset(20)
            $0.height.equalTo(40)
        }

        changeButton.snp.makeConstraints {
            $0.top.equalTo(confirmPasswordField.snp.bottom).offset(30)
            $0.right.equalToSuperview().inset(16)
            $0.width.equalToSuperview().multipliedBy(0.2)
            $0.height.equalTo(44)
        }
    }
}
