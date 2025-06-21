//
//  CommentCollectionViewCell.swift
//  test2
//
//  Created by Dias Karassayev on 5/11/25.
//

//
//  FacultyCollectionViewCell.swift
//  test2
//
//  Created by Dias Karassayev on 4/3/25.
//

import UIKit
import SnapKit
import Kingfisher

class CommentCollectionViewCell: UICollectionViewCell{

    //MARK: - public
    func configure(name: String?, role: String?, comment: String?, time: String?, avatarUrl: String?){
        nameLabel.text = name
        roleLabel.text = role
        commentLabel.text = comment
        timeLabel.text = formatDate(time ?? "08.05.2025, 05:46:32")

        DispatchQueue.main.async {
            if let imgUrl = avatarUrl{
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
    
    private lazy var nameLabel = UILabel.createLabel(size: 14, color: .black, font: "Poppins-Regular", text: "")
    private lazy var roleLabel = UILabel.createLabel(size: 14, color: .gray, font: "Poppins-Regular", text: "")
    private lazy var commentLabel = UILabel.createLabel(size: 14, color: .gray, font: "Poppins-Regular", text: "")
    private lazy var timeLabel = UILabel.createLabel(size: 12, color: .gray, font: "Poppins-Regular", text: "")

    private lazy var iconImageView: UIImageView = {
         let imageView = UIImageView()
        imageView.image = UIImage(named: "profile")
         imageView.tintColor = .black
        imageView.layer.cornerRadius = 24
         imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
         return imageView
     }()
    
    func formatDate(_ isoString: String) -> String {
        let inputFormatter = DateFormatter()
        inputFormatter.locale = Locale(identifier: "en_US_POSIX")
        inputFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSSS"

        let outputFormatter = DateFormatter()
        outputFormatter.dateFormat = "dd.MM.yyyy, HH:mm:ss"

        if let date = inputFormatter.date(from: isoString) {
            return outputFormatter.string(from: date)
        } else {
            return isoString // fallback if parsing fails
        }
    }
}
private extension CommentCollectionViewCell{
    func setupUI() {
        setupViews()
        setupConstraints()
    }
    
    func setupViews() {
        contentView.addSubview(iconImageView)
        contentView.addSubview(nameLabel)
        contentView.addSubview(roleLabel)
        contentView.addSubview(commentLabel)
        contentView.addSubview(timeLabel)

    }
    
    func setupConstraints() {
        contentView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        iconImageView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(20)
            make.size.equalTo(48)
            make.leading.equalToSuperview()
        }
        nameLabel.snp.makeConstraints { make in
            make.left.equalTo(iconImageView.snp.right).offset(5)
            make.centerY.equalTo(iconImageView.snp.centerY)
        }
        roleLabel.snp.makeConstraints { make in
            make.left.equalTo(nameLabel.snp.right).offset(5)
            make.centerY.equalTo(nameLabel.snp.centerY)
        }
        commentLabel.snp.makeConstraints { make in
            make.top.equalTo(iconImageView.snp.bottom).offset(10)
            make.leading.equalToSuperview()
        }
        timeLabel.snp.makeConstraints { make in
            make.top.equalTo(commentLabel.snp.bottom).offset(10)
            make.leading.equalToSuperview()
        }
    }
}
