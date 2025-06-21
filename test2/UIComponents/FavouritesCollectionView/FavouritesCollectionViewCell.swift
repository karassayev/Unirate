//
//  FacultyCollectionViewCell.swift
//  test2
//
//  Created by Dias Karassayev on 4/3/25.
//

import UIKit
import SnapKit
import Kingfisher

class FavouritesCollectionViewCell: UICollectionViewCell{

    //MARK: - public
    func configure(specialty: String?){
        titleLabel.text = specialty
    }
    
    private let data: [String] = [
        "Education costs","Dormitory cost", "Military edu cost", "food and additional things", "TOTAL"
    ]
    private let data2: [Int] = [1000000, 100000, 250000, 600000, 1950000]

    
    private lazy var titleLabel = UILabel.createLabel(size: 16, color: .black, font: "Poppins-Bold", text: "")

    private lazy var uniTableView: UITableView = {
        let tableView = UITableView()
        tableView.register(FavouritesTableViewCell.self, forCellReuseIdentifier: Cells.favouritesTableViewCell)
        tableView.selectionFollowsFocus = false
        tableView.allowsSelection = false
        tableView.showsVerticalScrollIndicator = false
        tableView.backgroundColor = UIColor.customGrayBackground
        tableView.isPagingEnabled = true
        tableView.isScrollEnabled = false
        return tableView
    }()
    
    //MARK: - init
    override init(frame: CGRect) {
        super.init(frame: frame)
        uniTableView.delegate = self
        uniTableView.dataSource = self
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
private extension FavouritesCollectionViewCell{
    func setupUI() {
        layer.cornerRadius = 20 // Optional: Rounded corners
        clipsToBounds = true
        backgroundColor = UIColor.customGrayBackground
        titleLabel.backgroundColor = .white
        titleLabel.layer.cornerRadius = 20
        setupViews()
        setupConstraints()
    }
    
    func setupViews() {
        contentView.addSubview(titleLabel)

        contentView.addSubview(uniTableView)

    }
    
    func setupConstraints() {
        contentView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        titleLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview()
            make.leading.trailing.equalToSuperview().offset(16).inset(16)
            make.height.equalTo(40)
        }
        uniTableView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(24)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        
    }
}

extension FavouritesCollectionViewCell:  UITableViewDataSource, UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        data.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Cells.favouritesTableViewCell, for: indexPath) as! FavouritesTableViewCell
        cell.configure(with: data[indexPath.row], value: data2[indexPath.row])
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 10  // любое значение отступа
    }
}
