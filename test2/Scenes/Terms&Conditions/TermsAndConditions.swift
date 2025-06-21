//
//  TermsAndConditions.swift
//  test1
//
//  Created by Dias Karassayev on 3/25/25.
//

import UIKit
import SnapKit

class TermsAndConditions: UIViewController, UITextFieldDelegate {
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
        return view
    }()
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Terms and conditions"
        label.textColor = .black
        label.font = UIFont(name: "Poppins-Bold", size: 24)
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.textColor = .black
        label.font = UIFont(name: "Poppins-Bold", size: 18)
        label.numberOfLines = 0
        label.text = "Blandit nec feugiat vitae luctus."
        return label
    }()
    private lazy var label: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.textColor = .gray
        label.font = UIFont(name: "Poppins-Regular", size: 14)
        label.numberOfLines = 0
        label.text = """
            Welcome to UniRate! These Terms and Conditions outline the rules and regulations for using our platform. By accessing or using UniRate,you agree to comply with and be bound by these terms.UniRate is an informational platform designed to help studentsexplore, compare, and evaluate universities worldwide. We alsoprovide tools like a financial calculator and a student forum forsharing knowledge and experiences.All information you provide must be accurate and up-to-date. Youagree not to misuse, modify, or harm the platform or any of itsfeatures.To access certain features (e.g., the forum), you may need to createan account. You are responsible for maintaining the confidentialityof your login information. UniRate reserves the right to suspend ordelete accounts that violate our terms or community guidelines.All content on UniRate, including text, graphics, tools, andbranding, is owned or licensed by UniRate and protected by copyrightlaws. You may not copy, distribute, or modify content withoutpermission. Users retain ownership of their forum posts, but byposting, you grant UniRate a non-exclusive license to display andshare your content.Be respectful and helpful when engaging in the community. Do notpost spam, offensive content, or misinformation. UniRate reservesthe right to remove any content that violates these guidelines.UniRate strives to provide accurate and updated information, but wedo not guarantee the completeness or reliability of university data,rankings, or financial estimates. Any decisions you make using ourplatform are your responsibility.UniRate is not liable for any damages or losses resulting from theuse of our website or tools. We are not affiliated with anyuniversities listed on the platform.We may update these Terms and Conditions from time to time. Anychanges will be posted here with a revised date.If you have any questions about these terms, feel free to reach outat: unirate@gmail.com
            """
        return label
    }()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white

        setupUI()
    }
}
extension TermsAndConditions {
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
        firstView.addSubview(label)

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
//            make.height.equalTo(view.snp.height).multipliedBy(0.6)
        }
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.trailing.equalToSuperview()
        }
        descriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(30)
            make.leading.trailing.equalToSuperview()
        }
        label.snp.makeConstraints { make in
            make.top.equalTo(descriptionLabel.snp.bottom).offset(20)
            make.centerX.equalToSuperview()
            make.leading.trailing.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        let lastSubview = [headerView, firstView].last!
        lastSubview.snp.makeConstraints { make in
            make.bottom.equalToSuperview().inset(tabBarController?.tabBar.frame.height ?? 0)
        }
        }
    }

