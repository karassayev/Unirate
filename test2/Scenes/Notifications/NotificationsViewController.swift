//
//  NotificationsViewController.swift
//  test1
//
//  Created by Dias Karassayev on 3/25/25.
//


import UIKit
import SnapKit

class NotificationsViewController: UIViewController, UITextFieldDelegate {
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
        label.textColor = .lightGray
        label.font = UIFont(name: "Poppins-Regular", size: 14)
        label.numberOfLines = 0
        label.text = """
            Lorem ipsum dolor sit amet, consectetur adipiscing elit. Dictum arcu, dolor, molestie feugiat rutrum id urna quisque purus. Sit ut non urna auctor libero, dictumst ut adipiscing. Platea non convallis vel iaculis nec odio. Nulla habitant felis laoreet pharetra scelerisque placerat scelerisque interdum. Lacus habitasse neque, scelerisque aliquet. Nec, bibendum viverra vitae, molestie cum ut. Pharetra lectus volutpat arcu ut ultrices eu sit volutpat. Pretium egestas in massa cursus ornare. Amet, non gravida rutrum luctus
            
            Lorem ipsum dolor sit amet, consectetur adipiscing elit. Dictum arcu, dolor, molestie feugiat rutrum id urna quisque purus. Sit ut non urna auctor libero, dictumst ut adipiscing. Platea non convallis vel iaculis nec odio. Nulla habitant felis laoreet pharetra scelerisque placerat scelerisque interdum. Lacus habitasse neque, scelerisque aliquet. Nec, bibendum viverra vitae, molestie cum ut. Pharetra lectus volutpat arcu ut ultrices eu sit volutpat. Pretium egestas in massa cursus ornare. Amet, non gravida rutrum luctus
                        
            Lorem ipsum dolor sit amet, consectetur adipiscing elit. Dictum arcu, dolor, molestie feugiat rutrum id urna quisque purus. Sit ut non urna auctor libero, dictumst ut adipiscing. Platea non convallis vel iaculis nec odio. Nulla habitant felis laoreet pharetra scelerisque placerat scelerisque interdum. Lacus habitasse neque, scelerisque aliquet. Nec, bibendum viverra vitae, molestie cum ut. Pharetra lectus volutpat arcu ut ultrices eu sit volutpat. Pretium egestas in massa cursus ornare. Amet, non gravida rutrum luctus
            
            """
        return label
    }()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white

        setupUI()
    }
}
extension NotificationsViewController {
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
            make.centerX.equalToSuperview()
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

