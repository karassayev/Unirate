//
//  AvatarsChangeView.swift
//  test2
//
//  Created by Dias Karassayev on 4/22/25.
//

import UIKit
import SnapKit

class AvatarsChangeView: UIView {
    
    var onChangePressed: ((String?) -> Void)?
    private var selectedAvatarURL: String?

    private let containerView = UIView()
    private let titleLabel = UILabel.createLabel(size: 20, color: .black, font: "Poppins-Regular", text: "Change your avatar")
    private let closeButton = UIButton()
    
    let avatars = [
        "https://i.postimg.cc/5X9hQqf2/10avatar.png",
        "https://i.postimg.cc/Ny5Zps9h/11avatar.png",
        "https://i.postimg.cc/JHWgrjTm/12avatar.png",
        "https://i.postimg.cc/5HTTrhLX/13avatar.png",
        "https://i.postimg.cc/z3n6dPBf/14avatar.png",
        "https://i.postimg.cc/7GzdrKnm/15avatar.png",
        "https://i.postimg.cc/rRCHKzb4/16avatar.png",
        "https://i.postimg.cc/f3PQNtnT/2avatar.png",
        "https://i.postimg.cc/S2zFNSkL/3avatar.png",
        "https://i.postimg.cc/GTw04WmW/4avatar.png",
        "https://i.postimg.cc/9wG6ZL4r/5avatar.png",
        "https://i.postimg.cc/3Wm5sxLY/6avatar.png",
        "https://i.postimg.cc/vcyFbwj9/7avatar.png",
        "https://i.postimg.cc/gnK90BF7/8avatar.png",
        "https://i.postimg.cc/mPd0YzrN/9avatar.png"
    ]
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.itemSize = CGSize(width: 80, height: 80)
        layout.minimumLineSpacing = 16
        layout.minimumInteritemSpacing = 16
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .white
        collectionView.register(AvatarCell.self, forCellWithReuseIdentifier: AvatarCell.identifier)
        collectionView.delegate = self
        collectionView.dataSource = self
        return collectionView
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        animatePopup()
    }
    private lazy var changeButton = UIButton.createButton(title: "Change", color: UIColor.customGreen, textColor: .white) {
        self.onChangePressed?(self.selectedAvatarURL)
        self.dismiss()
    }
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
        animatePopup()
    }

    private func animatePopup() {
        backgroundColor = UIColor.black.withAlphaComponent(0.0)
        containerView.alpha = 0
        containerView.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)

        UIView.animate(withDuration: 0.3) {
            self.backgroundColor = UIColor.black.withAlphaComponent(0.5)
            self.containerView.alpha = 1
            self.containerView.transform = .identity
        }
    }

    @objc private func dismiss() {
        UIView.animate(withDuration: 0.2, animations: {
            self.alpha = 0
        }) { _ in
            self.removeFromSuperview()
        }
    }

}
private extension AvatarsChangeView {
    
    func setupUI() {
        setupViews()
        setupConstraints()
    }

    func setupViews() {
        addSubview(containerView)
        containerView.backgroundColor = .white
        containerView.layer.cornerRadius = 20
        containerView.addSubview(collectionView)
        containerView.addSubview(changeButton)

        closeButton.setImage(UIImage(named: "close"), for: .normal)
        closeButton.tintColor = .black
        closeButton.layer.borderColor = UIColor.customGreen.cgColor
        closeButton.addTarget(self, action: #selector(dismiss), for: .touchUpInside)
        containerView.addSubview(closeButton)
        containerView.addSubview(titleLabel)

    }

    func setupConstraints() {
        containerView.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.leading.trailing.equalToSuperview().offset(16).inset(16)
            $0.height.equalToSuperview().multipliedBy(0.7)
        }

        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(20)
            $0.left.equalToSuperview().offset(20)
        }

        closeButton.snp.makeConstraints {
            $0.centerY.equalTo(titleLabel.snp.centerY)
            $0.right.equalToSuperview().inset(20)
            $0.width.height.equalTo(52)
        }
        
        collectionView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().offset(16).inset(16)
            make.top.equalTo(titleLabel.snp.bottom).offset(16)
            make.bottom.equalToSuperview().inset(60)
        }
        changeButton.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().offset(16).inset(16)
            make.top.equalTo(collectionView.snp.bottom)
            make.height.equalTo(48)
        }
    }
}
extension AvatarsChangeView: UICollectionViewDelegate, UICollectionViewDataSource {
    
    // MARK: - UICollectionViewDataSource
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return avatars.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AvatarCell.identifier, for: indexPath) as? AvatarCell else {
            return UICollectionViewCell()
        }
        
        let avatarURL = avatars[indexPath.row]
        cell.configure(with: avatarURL)
        return cell
    }
    
    // MARK: - UICollectionViewDelegate
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedAvatarURL = avatars[indexPath.row]

        // Perform additional actions after selection (e.g., update user profile)
    }
}
