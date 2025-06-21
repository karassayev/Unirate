//
//  ReviewCollectionViewCell.swift
//  test1
//
//  Created by Dias Karassayev on 3/11/25.
//

import UIKit
import SnapKit

class ReviewCollectionViewCell: UICollectionViewCell{
    //MARK: - public
    func configure(by name: String, major: String, description: String){
        nameLabel.text = name
        majorLabel.text = major
        descriptionLabel.text = description
        
    }
    //MARK: - init
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = UIFont(name: "Poppins-Bold", size: 21)
        label.numberOfLines = 0
        return label
     }()
    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = UIFont(name: "Poppins-Regular", size: 14)
        label.numberOfLines = 0
        return label
     }()
    private lazy var majorLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = UIFont(name: "Poppins-Regular", size: 16)
        label.numberOfLines = 0
        return label
     }()
    private lazy var image: UIImageView = {
         let imageView = UIImageView()
         imageView.image = UIImage(named: "profile")
         imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 20
        imageView.clipsToBounds = true
         return imageView
     }()
}
private extension ReviewCollectionViewCell{
    func setupUI() {
        layer.borderWidth = 0.7 // Border thickness
        layer.borderColor = UIColor.gray.cgColor // Border color
        layer.cornerRadius = 20 // Optional: Rounded corners
        clipsToBounds = true
        backgroundColor = .white
        setupViews()
        setupConstraints()
    }
    
    func setupViews() {
        contentView.addSubview(image)
        contentView.addSubview(nameLabel)
        contentView.addSubview(majorLabel)
        contentView.addSubview(descriptionLabel)
    }
    
    func setupConstraints() {
        image.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(40)
            make.centerX.equalToSuperview()
            make.size.equalTo(80)
        }
        nameLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(image.snp.bottom).offset(16)
        }
        majorLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(nameLabel.snp.bottom).offset(10)
        }
        descriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(majorLabel.snp.bottom).offset(30)
            make.leading.equalToSuperview().offset(10)
            make.trailing.equalToSuperview().offset(-10)
//            make.height.equalTo(3)
        }
    }
}

