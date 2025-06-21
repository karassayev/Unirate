//
//  Global.swift
//  test1
//
//  Created by Dias Karassayev on 3/5/25.
//

import UIKit

class DropDownButton: UIButton {
    var selectedValue: String?
}

struct Cells{
    static let FeatureCollectionViewCell = "FeatureCollectionViewCell"
    static let UniversitiesCollectionViewCell = "UniversityCell"
    static let reviewsCollectionViewCell = "ReviewCell"
    static let totalsTableViewCell = "totalsCell"
    static let menuTableViewCell = "menuCell"
    static let calculateTableViewCell = "calculateCell"
    static let facultyTableViewCell = "facultyeCell"
    static let facultyCollectionViewCell = "facultyeCell"
    static let forumTableViewCell = "forumCell"
    static let commentCollectionViewCell = "commentCell"
    static let favouritesCollectionViewCell = "favCell"
    static let favouritesTableViewCell = "favouriteCell"



}
extension UIColor {
    static let customGreen = UIColor(red: 0/255, green: 147/255, blue: 121/255, alpha: 1.0)
    static let transparentGreen = UIColor(red: 248/255, green: 255/255, blue: 253/255, alpha: 1.0)
    static let customGreen2 = UIColor(red: 229/255.0, green: 244/255.0, blue: 242/255.0, alpha: 1.0)
    static let customGrayBackground = UIColor(red: 249/255.0, green: 249/255.0, blue: 249/255.0, alpha: 1.0)
}
enum Screen: String {
    case financeCalculator = "Finance calculator"
    case personalInfo = "Personal Info"
    case favourites = "Favourites"
    case loginSecurity = "Login and Security"
    case notifications = "Notifications"
    case support = "Support"
    case contacts = "Contacts"
    case logOut = "Log out"
    
    // Map the enum case to the corresponding UIViewController
    func viewController() -> UIViewController {
        switch self {
        case .financeCalculator:
            return FinanceCalculatorVC()
        case .personalInfo:
            return Profile()
        case .favourites:
            return FavouritesViewController()
        case .loginSecurity:
            return CreateAccountVC()
        case .notifications:
            return TermsAndConditions()
        case .support:
            return FAQViewController()
        case .contacts:
            return ContactUs()
        case .logOut:
            return ViewController()
        }
    }
}





extension UILabel{
    static func createLabel(size: Int, color: UIColor, font: String, text: String, target: Any? = nil, action: Selector? = nil) -> UILabel {
        let label = UILabel()
        label.text = text
        label.textColor = color
        label.font = UIFont(name: font, size: CGFloat(size))
        label.textAlignment = .center
        label.numberOfLines = 0
        label.isUserInteractionEnabled = true // Enable user interaction

        // Add the tap gesture recognizer only if action is provided
        if let action = action, let target = target {
            let tapGesture = UITapGestureRecognizer(target: target, action: action)
            label.addGestureRecognizer(tapGesture)
        }
        
        return label
    }


}
extension UIButton{
    static func createButton(title: String, color: UIColor, textColor: UIColor, action: @escaping () -> Void, image: UIImage? = nil) -> UIButton {
        let button: UIButton
        
        if let image = image {
            // Button with image (using configuration)
            var config = UIButton.Configuration.filled()
            config.title = title
            config.baseForegroundColor = textColor
            config.baseBackgroundColor = color
            config.image = image
            config.imagePadding = 10
            config.cornerStyle = .capsule
            
            let font = UIFont(name: "Poppins-Bold", size: 16) ?? UIFont.systemFont(ofSize: 16, weight: .bold)
            config.attributedTitle = AttributedString(title, attributes: AttributeContainer([.font: font]))
            
            button = UIButton(configuration: config)
        } else {
            // Button without image (standard UIButton)
            button = UIButton(type: .system)
            button.setTitle(title, for: .normal)
            button.setTitleColor(textColor, for: .normal)
            button.backgroundColor = color
            button.titleLabel?.font = UIFont(name: "Poppins-Bold", size: 16)
            button.layer.cornerRadius = 20
            button.layer.borderWidth = 1
            button.layer.borderColor = UIColor.customGreen.cgColor
        }
        
        button.addAction(UIAction(handler: { _ in action() }), for: .touchUpInside)
        
        return button
    }

    
    static func createDropDown(data: [String] = [], title: String = "Select") -> DropDownButton {
        let button = DropDownButton(type: .system)

        var config = UIButton.Configuration.filled()
        config.image = UIImage(systemName: "chevron.down")
        config.baseBackgroundColor = .white
        config.baseForegroundColor = .black
        config.cornerStyle = .medium
        config.imagePlacement = .trailing
        config.imagePadding = 6

        if let customFont = UIFont(name: "Poppins-Regular", size: 16) {
            config.attributedTitle = AttributedString(title, attributes: AttributeContainer([.font: customFont]))
        }

        config.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 16, bottom: 10, trailing: 16)

        button.configuration = config
        button.contentHorizontalAlignment = .leading
        button.showsMenuAsPrimaryAction = true
        button.tintColor = .black

        // Установим пустое меню на старте
        button.menu = UIMenu(title: "", options: .displayInline, children: [])

        // Стилизация
        button.layer.cornerRadius = 10
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.lightGray.cgColor

        // Если есть данные — можно сразу установить меню
        if !data.isEmpty {
            button.updateMenu(with: data) { _ in }
        }

        return button
    }


    }


extension UITextField{
    static func createTextField(placeholder: String, imageName: String? = nil, isSecure: Bool = false) -> UITextField {
        let textField = UITextField()
        textField.backgroundColor = .white
        textField.placeholder = placeholder
        textField.layer.cornerRadius = 20
        textField.font = UIFont(name: "Poppins-Regular", size: 16)
        textField.textColor = .black
        textField.layer.borderWidth = 1
        textField.autocapitalizationType = .none
        textField.isSecureTextEntry = isSecure
        textField.layer.borderColor = UIColor.lightGray.cgColor
        textField.clearButtonMode = .whileEditing

        textField.attributedPlaceholder = NSAttributedString(
            string: placeholder,
            attributes: [
                .foregroundColor: UIColor.black,
                .font: UIFont(name: "Poppins-Regular", size: 16)!
            ]
        )

        let leftPadding: CGFloat = imageName == nil ? 12 : 40
        let leftView = UIView(frame: CGRect(x: 0, y: 0, width: leftPadding, height: 40))

        if let imageName = imageName, let image = UIImage(named: imageName) {
            let imageView = UIImageView(image: image)
            imageView.contentMode = .scaleAspectFit
            imageView.frame = CGRect(x: 8, y: 10, width: 20, height: 20)
            leftView.addSubview(imageView)
        }

        textField.leftView = leftView
        textField.leftViewMode = .always

        return textField
    }


}

extension UIButton {
    func updateMenu(with options: [String], onSelect: @escaping (String) -> Void) {
           self.menu = UIMenu(title: "", options: .displayInline, children: options.map { option in
               UIAction(title: option) { _ in
                   self.updateTitle(to: option)
                   onSelect(option)
               }
           })
           self.showsMenuAsPrimaryAction = true
       }

       func updateTitle(to title: String) {
           self.setTitle(title, for: .normal)
       }
}
