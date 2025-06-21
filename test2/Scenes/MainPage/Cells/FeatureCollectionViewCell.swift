//
//  NewsCategoryCollectionViewCell.swift
//  newsApp
//
//  Created by Dias Karassayev on 3/12/24.
//

import UIKit
import SnapKit

class FeatureCollectionViewCell: UICollectionViewCell{
    //MARK: - public
    func configure(title: String, description: String){
        titleLabel.text = title
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
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = UIFont(name: "Poppins-Bold", size: 18)
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
    private lazy var iconImageView: UIImageView = {
         let imageView = UIImageView()
         imageView.image = UIImage(named: "main3")
         imageView.contentMode = .scaleAspectFill
         imageView.clipsToBounds = true
         return imageView
     }()
}
private extension FeatureCollectionViewCell{
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
        contentView.addSubview(titleLabel)
        contentView.addSubview(descriptionLabel)
        contentView.addSubview(iconImageView)
    }
    
    func setupConstraints() {
        iconImageView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(30)
            make.size.equalTo(48)
            make.centerX.equalToSuperview()
        }
        titleLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(10)
            make.trailing.equalToSuperview().offset(-10)
            make.top.equalTo(iconImageView.snp.bottom).offset(10)
        }
        descriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(20)
            make.leading.equalToSuperview().offset(10)
            make.trailing.equalToSuperview().offset(-10)
//            make.height.equalTo(3)
        }
    }
}
