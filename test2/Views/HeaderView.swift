//
//  HeaderView.swift
//  test1
//
//  Created by Dias Karassayev on 3/12/25.
//

import UIKit
import SnapKit

protocol HeaderViewDelegate: AnyObject {
    func didTapHeartIcon()
}

class HeaderView: UIView {
    weak var delegate: HeaderViewDelegate?
            
    @objc func imageTapped() {
        delegate?.didTapHeartIcon()
        print(222)

    }
    
    private lazy var headerView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()
    private lazy var logoIcon: UIImageView = {
         let imageView = UIImageView()
        imageView.image = UIImage(named: "logo")
         imageView.tintColor = .black
         return imageView
     }()
    private lazy var logoLabel: UILabel = {
         let label = UILabel()
         label.text = "UniRate"
         label.textColor = .black
        label.font = UIFont(name: "Poppins-Bold", size: 14)
         return label
     }()
//    private lazy var heartIcon: UIImageView = {
//         let imageView = UIImageView()
//         imageView.isUserInteractionEnabled = true
//        imageView.backgroundColor = .red// Allow interaction
//         imageView.image = UIImage(systemName: "heart")
//         imageView.tintColor = .gray
//        
//        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(imageTapped))
//        imageView.addGestureRecognizer(tapGesture)
//         return imageView
//     }()
    private lazy var heartIcon: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "heart"), for: .normal)
        button.tintColor = .gray
        button.addTarget(self, action: #selector(imageTapped), for: .touchUpInside)
        return button
    }()

    private lazy var menuIcon: UIImageView = {
         let imageView = UIImageView()
         imageView.image = UIImage(systemName: "line.horizontal.3")
         imageView.tintColor = .gray
         return imageView
     }()
    

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    //MARK: - init
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
}

private extension HeaderView{
    func setupUI() {
        setupViews()
        setupConstraints()
    }
    func setupViews() {
        addSubview(headerView)
        addSubview(logoIcon)
        addSubview(logoLabel)
        addSubview(heartIcon)
        addSubview(menuIcon)
    }
    func setupConstraints() {
        headerView.snp.makeConstraints { make in
            make.top.equalToSuperview()

            make.left.right.equalToSuperview()
            make.height.equalTo(60)
        }
        logoIcon.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(16)
            make.centerY.equalToSuperview()
            make.width.height.equalTo(32)
        }
        logoLabel.snp.makeConstraints { make in
            make.left.equalTo(logoIcon.snp.right).offset(8)
            make.centerY.equalToSuperview()
        }
        heartIcon.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(-50)
            make.centerY.equalToSuperview()
            make.width.height.equalTo(24)
        }
        menuIcon.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(-16)
            make.centerY.equalToSuperview()
            make.width.height.equalTo(24)
        }
    }
}
