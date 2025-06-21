//
//  ContactUs.swift
//  test1
//
//  Created by Dias Karassayev on 3/24/25.
//


import UIKit
import SnapKit

class ContactUs: UIViewController{
    private let headerView = HeaderView()
    
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.showsVerticalScrollIndicator = false
        return scrollView
    }()
    
    private lazy var contentView: UIView = {
        let view = UIView()
        return view
    }()
    private lazy var firstView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 20
        return view
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Contact Us"
        label.textColor = .black
        label.font = UIFont(name: "Poppins-Bold", size: 24)
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = .lightGray
        label.font = UIFont(name: "Poppins-Regular", size: 16)
        label.numberOfLines = 0
        label.text = "The harder you work for something, the greater you’ll feel when you achieve it."
        return label
    }()
    private lazy var nameTextField = UITextField.createTextField(placeholder: "Name", imageName: "user")
    private lazy var emailTextField = UITextField.createTextField(placeholder: "Email", imageName: "mail")
    private lazy var messageTextField = UITextField.createTextField(placeholder: "Message")

    private lazy var sendButton: UIButton = {
        let button = UIButton()
        button.setTitle("Send Request", for: .normal)
        button.backgroundColor = UIColor.customGreen
        button.layer.cornerRadius = 10
        button.titleLabel?.font = UIFont(name: "Poppins-Bold", size: 16)
        button.configuration?.cornerStyle = .capsule
        return button
    }()
    private lazy var mapImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "map") // Set your image here
        imageView.contentMode = .scaleAspectFill
        imageView.tintColor = .black
        return imageView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white

        setupUI()
    }
}
extension ContactUs {
    func setupUI() {
        setupViews()
        setupConstraints()
    }
    func setupViews() {
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        contentView.addSubview(headerView)
        contentView.addSubview(firstView)
        
        firstView.addSubview(titleLabel)
        firstView.addSubview(descriptionLabel)
        firstView.addSubview(nameTextField)
        firstView.addSubview(emailTextField)
        firstView.addSubview(messageTextField)
        firstView.addSubview(sendButton)
        firstView.addSubview(mapImageView)

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
        firstView.snp.makeConstraints { make in
            make.top.equalTo(headerView.snp.bottom).offset(30)
            make.leading.trailing.equalToSuperview().offset(16).inset(16)
            make.height.equalTo(view.snp.height).multipliedBy(0.9)
        }

        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(headerView.snp.bottom).offset(30)
            make.centerX.equalToSuperview()
        }
        descriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(30)
            make.centerX.equalToSuperview()
            make.leading.trailing.equalToSuperview()
        }
        nameTextField.snp.makeConstraints { make in
            make.top.equalTo(descriptionLabel.snp.bottom).offset(30)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(48)
        }
        emailTextField.snp.makeConstraints { make in
            make.top.equalTo(nameTextField.snp.bottom).offset(16)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(48)

        }
        messageTextField.snp.makeConstraints { make in
            make.top.equalTo(emailTextField.snp.bottom).offset(16)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(90)
        }
        sendButton.snp.makeConstraints { make in
            make.top.equalTo(messageTextField.snp.bottom).offset(24)
            make.right.equalToSuperview().inset(16)
            make.height.equalTo(48)
            make.width.equalToSuperview().multipliedBy(0.6)
        }
        mapImageView.snp.makeConstraints { make in
            make.top.equalTo(sendButton.snp.bottom).offset(80)
            make.leading.trailing.equalToSuperview()
            make.height.equalToSuperview().multipliedBy(0.34)
        }
        let lastSubview = [headerView, firstView].last!
        lastSubview.snp.makeConstraints { make in
            make.bottom.equalToSuperview().inset(tabBarController?.tabBar.frame.height ?? 0)
        }
    }
}

