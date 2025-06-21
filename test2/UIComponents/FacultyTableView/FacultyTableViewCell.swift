//
//  FacultyTableViewCell.swift
//  test2
//
//  Created by Dias Karassayev on 4/3/25.
//

import UIKit
import SnapKit

class FacultyTableViewCell: UITableViewCell {
    var faculty: Faculty? // Сохраняем только конкретный факультет
    
    var onSpecialtyTapped: ((Specialty) -> Void)?

    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = UIFont(name: "Poppins-Bold", size: 24)
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var facultyCollectionView: UICollectionView = {
        let collectionViewLayout = UICollectionViewFlowLayout()
        collectionViewLayout.scrollDirection = .horizontal
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: collectionViewLayout)
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.register(FacultyCollectionViewCell.self, forCellWithReuseIdentifier: Cells.facultyCollectionViewCell)
        return collectionView
    }()
     
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        facultyCollectionView.delegate = self
        facultyCollectionView.dataSource = self
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    
    func configure(with faculty: Faculty?) {
        self.faculty = faculty
        titleLabel.text = faculty?.facultyDto.name
        facultyCollectionView.reloadData()
    }


}

//MARK: - Setup UI
private extension FacultyTableViewCell {
    
    func setupUI() {
        setupViews()
        setupConstraints()
    }
    
    func setupViews() {
        contentView.addSubview(facultyCollectionView)
        contentView.addSubview(titleLabel)

    }
    
    func setupConstraints() {
        titleLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview()
            make.leading.trailing.equalToSuperview().offset(16).inset(16)
        }
        facultyCollectionView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(24)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        
    }
}
extension FacultyTableViewCell: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let count = faculty?.specialtyDtos.count ?? 0
        print("Specialty count:", count) // Debugging
        return count
    }

    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Cells.facultyCollectionViewCell, for: indexPath) as! FacultyCollectionViewCell
        
        let specialty = faculty?.specialtyDtos[indexPath.item].name ?? "Unknown"
        
        cell.configure(specialty: specialty, specialtyLogoUrl: faculty?.specialtyDtos[indexPath.item].specialtyImageUrl)
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let specialty = faculty?.specialtyDtos[indexPath.item] {
            onSpecialtyTapped?(specialty)
        }
    }


    
}
//MARK: - Collection View Flow Layout
extension FacultyTableViewCell: UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 290, height: 375)
    }
}
