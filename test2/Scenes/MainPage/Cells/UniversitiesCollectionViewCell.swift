//
//  UniversitiesCollectionViewCell.swift
//  test1
//
//  Created by Dias Karassayev on 3/11/25.
//

import UIKit
import SnapKit
import Kingfisher

class UniversitiesCollectionViewCell: UICollectionViewCell{
    private var universityId: Int?
    var onLikeTapped: ((Int) -> Void)?
    
    //MARK: - public
    func configure(by id: Int, name: String, rate: Double, description: String, highRate: String, logoUrl: String?, isFavorite: Bool){
        self.universityId = id
        nameLabel.text = name
        rateLabel.text = String(rate)
        highRateLabel.text = highRate
        descriptionLabel.text = description

        let likeImageName = isFavorite ? "liked" : "like"
        likeIcon.image = UIImage(named: likeImageName)

        if let imgUrl = logoUrl {
            self.iconImageView.kf.setImage(with: URL(string: imgUrl))
        }
    }

    //MARK: - init
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc private func likeTapped() {
        if let id = universityId {
            onLikeTapped?(id)
        }
    }

    
    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.text = "SDU"
        label.font = UIFont(name: "Poppins-Bold", size: 20)
//        label.numberOfLines = 0
        return label
     }()

    private lazy var likeIcon: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "like")
        imageView.tintColor = .black
        imageView.backgroundColor = UIColor.customGreen2
        imageView.layer.cornerRadius = 20
        imageView.isUserInteractionEnabled = true // включаем тап
        let tap = UITapGestureRecognizer(target: self, action: #selector(likeTapped))
        imageView.addGestureRecognizer(tap)
        return imageView
    }()

    private lazy var rateLabel: UILabel = {
        let label = UILabel()
        label.text = "5"
        label.textAlignment = .center
        label.font = UIFont(name: "Poppins-Regular", size: 16)
        label.layer.borderWidth = 2// Border thickness
        label.layer.borderColor = UIColor.black.cgColor // Border color
        label.layer.cornerRadius = 8.0 // Corner radius
        label.layer.masksToBounds = true 
        label.numberOfLines = 0
        return label
     }()
    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.text = "SDU"
        label.font = UIFont(name: "Poppins-Regular", size: 14)
        label.numberOfLines = 3
        return label
     }()
    private lazy var highRateLabel: UILabel = {
        let label = UILabel()
        label.text = "SDU"
        label.textAlignment = .left
        label.font = UIFont(name: "Poppins-Regular", size: 12)
        label.backgroundColor = UIColor.customGreen2
        label.layer.cornerRadius = 8.0 // Corner radius
        label.layer.masksToBounds = true 
        label.numberOfLines = 0
        return label
     }()
    private lazy var iconImageView: UIImageView = {
         let imageView = UIImageView()
        imageView.image = UIImage(named: "uni")
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 20
        imageView.clipsToBounds = true
         return imageView
     }()
}
private extension UniversitiesCollectionViewCell{
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
        contentView.addSubview(iconImageView)
        contentView.addSubview(nameLabel)
        contentView.addSubview(rateLabel)
        contentView.addSubview(highRateLabel)
        contentView.addSubview(descriptionLabel)
        contentView.addSubview(likeIcon)
    }
    
    func setupConstraints() {
        iconImageView.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(-5)
            make.width.equalTo(290)
            make.height.equalTo(280)
            make.centerX.equalToSuperview()
        }
        likeIcon.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(12)
            make.size.equalTo(52)
            make.trailing.equalToSuperview().inset(12)
        }
        nameLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(8)
            make.width.equalToSuperview().multipliedBy(0.6)
            make.top.equalTo(iconImageView.snp.bottom).offset(20)
        }
        rateLabel.snp.makeConstraints { make in
            make.top.equalTo(iconImageView.snp.bottom).offset(20)
            make.trailing.equalToSuperview().inset(8)
            make.size.equalTo(40)
        }
        descriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(nameLabel.snp.bottom).offset(20)
            make.leading.trailing.equalToSuperview().offset(8).inset(8)
        }
       highRateLabel.snp.makeConstraints { make in
            make.top.equalTo(descriptionLabel.snp.bottom).offset(10)
            make.leading.equalToSuperview().offset(8).inset(8)
           make.height.equalTo(28)
        }
    }
}
