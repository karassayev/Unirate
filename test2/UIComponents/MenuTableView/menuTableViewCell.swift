//
//  MenuTableViewCell.swift
//  test1
//
//  Created by Dias Karassayev on 3/25/25.

import UIKit
import SnapKit

class MenuTableViewCell: UITableViewCell {
     
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = UIFont(name: "Poppins-Bold", size: 20)
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
     
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    
    func configure(with result: String) {
        titleLabel.text = result

    }
}

//MARK: - Setup UI
private extension MenuTableViewCell {
    
    func setupUI() {
        setupViews()
        setupConstraints()
    }
    
    func setupViews() {
        contentView.addSubview(titleLabel)
    }
    
    func setupConstraints() {
        titleLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(16)
            make.top.equalToSuperview()
//            make.trailing.equalTo(newsImageView.snp.left).offset(-16)
        }
    }
}

