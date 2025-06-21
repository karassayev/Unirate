//
//  FavouritesTableViewCell.swift
//  test2
//
//  Created by Dias Karassayev on 6/12/25.
//

import UIKit
import SnapKit

class FavouritesTableViewCell: UITableViewCell {

    private lazy var titleLabel = UILabel.createLabel(size: 16, color: .black, font: "Poppins-Regular", text: "")
    private lazy var valueLabel = UILabel.createLabel(size: 16, color: .black, font: "Poppins-Regular", text: "")
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    
    func configure(with title: String, value: Int) {
        titleLabel.text = title
        valueLabel.text = String(value)
    }


}

//MARK: - Setup UI
private extension FavouritesTableViewCell {
    
    func setupUI() {
        setupViews()
        setupConstraints()
        valueLabel.backgroundColor = .white
        valueLabel.layer.cornerRadius = 20
        backgroundColor = UIColor.customGrayBackground
    }
    
    func setupViews() {
        contentView.addSubview(titleLabel)
        contentView.addSubview(valueLabel)
        

    }
    
    func setupConstraints() {
        titleLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview()
            make.leading.trailing.equalToSuperview().offset(16).inset(16)
        }
        valueLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(titleLabel.snp.bottom).offset(8)
            make.leading.trailing.equalToSuperview().offset(16).inset(16)
            make.height.equalTo(40)
        }
        
    }
}
