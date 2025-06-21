//
//  AvatarCell.swift
//  test2
//
//  Created by Dias Karassayev on 4/22/25.
//
import UIKit
import Kingfisher

class AvatarCell: UICollectionViewCell {
    
    static let identifier = "AvatarCell"
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 40
        imageView.clipsToBounds = true
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.addSubview(imageView)
        
        // Using SnapKit to set constraints
        imageView.snp.makeConstraints { make in
            make.top.equalTo(contentView.snp.top)
            make.left.equalTo(contentView.snp.left)
            make.right.equalTo(contentView.snp.right)
            make.bottom.equalTo(contentView.snp.bottom)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with url: String?) {
        // Load image from URL (you can use libraries like SDWebImage or AlamofireImage for this)
        DispatchQueue.main.async {
            if let imgUrl = url{
                self.imageView.kf.setImage(with: URL(string: imgUrl))
            }
        }
    }
}
