//
//  FacultyCollectionViewCell.swift
//  test2
//
//  Created by Dias Karassayev on 4/3/25.
//

import UIKit
import SnapKit
import Kingfisher

class FacultyCollectionViewCell: UICollectionViewCell{
    var collectionViewData: [String] = [] // Array that will hold data for collection view

    //MARK: - public
    func configure(specialty: String?, specialtyLogoUrl logoUrl: String?){
        nameLabel.text = specialty
        DispatchQueue.main.async {
            if let imgUrl = logoUrl{
                self.iconImageView.kf.setImage(with: URL(string: imgUrl))
            }
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
    
    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = UIFont(name: "Poppins-Bold", size: 20)
        label.numberOfLines = 0
        return label
     }()

    private lazy var iconImageView: UIImageView = {
         let imageView = UIImageView()
         imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 20
        imageView.image = UIImage(named: "faculty")
        imageView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        imageView.clipsToBounds = true
         return imageView
     }()
}
private extension FacultyCollectionViewCell{
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
    }
    
    func setupConstraints() {
        contentView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        iconImageView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.width.equalTo(290)
            make.height.equalTo(280)
        }
        nameLabel.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().offset(16).inset(16)
            make.top.equalTo(iconImageView.snp.bottom).offset(30)
        }
    }
}
