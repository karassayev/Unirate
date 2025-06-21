//
//  ForumTableViewCell.swift
//  test2
//
//  Created by Dias Karassayev on 5/11/25.
//

import UIKit
import SnapKit
import iOSDropDown


class ForumTableViewCell: UITableViewCell {
        
    
    var forum: Forum? // Сохраняем только конкретный факультет
        
    
    private lazy var numCommentsLabel = UILabel.createLabel(size: 16, color: .gray, font: "Poppins-Regular", text: "10 comments")
    let titleLabel = UILabel.createLabel(size: 24, color: .black, font: "Poppins-Bold", text: "")
    let commentLabel = UILabel.createLabel(size: 16, color: .gray, font: "Poppins-Regular", text: "")
    
    
    private lazy var commentCollectionView: UICollectionView = {
        let collectionViewLayout = UICollectionViewFlowLayout()
        collectionViewLayout.scrollDirection = .vertical
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: collectionViewLayout)
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.register(CommentCollectionViewCell.self, forCellWithReuseIdentifier: Cells.commentCollectionViewCell)
        return collectionView
    }()
    
    private lazy var messageImage: UIImageView = {
         let imageView = UIImageView()
        imageView.image = UIImage(named: "message")
         imageView.tintColor = .black
         imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
         return imageView
     }()

    private let containerView = UIView()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        commentCollectionView.delegate = self
        commentCollectionView.dataSource = self
        
        contentView.addSubview(containerView)
        containerView.addSubview(titleLabel)
        containerView.addSubview(commentLabel)
        containerView.addSubview(numCommentsLabel)
        containerView.addSubview(messageImage)
//        containerView.addSubview(commentCollectionView)

        
        containerView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(8)
        }
        messageImage.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.equalToSuperview()
            make.size.equalTo(30)
        }
        numCommentsLabel.snp.makeConstraints { make in
            make.centerY.equalTo(messageImage.snp.centerY)
            make.left.equalTo(messageImage.snp.right).offset(10)
        }
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(messageImage.snp.bottom).offset(10)
            make.leading.equalToSuperview()
        }
        commentLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(10)
            make.leading.trailing.equalToSuperview()
        }
        
//        commentCollectionView.snp.makeConstraints { make in
//            make.top.equalTo(commentLabel.snp.bottom).offset(24)
//            make.leading.trailing.equalToSuperview()
//            make.height.equalTo(200)
////            make.bottom.equalToSuperview() // 👈 This ensures full cell height
//        }


    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(with review: Forum?) {
        self.forum = review
        titleLabel.text = review?.name
        commentLabel.text = review?.description
        numCommentsLabel.text = "\(review?.topReviews.count ?? 0) comments"

        commentCollectionView.reloadData()
    }
}
extension ForumTableViewCell: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return forum?.topReviews.count ?? 0
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Cells.commentCollectionViewCell, for: indexPath) as! CommentCollectionViewCell

        if let review = forum?.topReviews[indexPath.row] {
            cell.configure(
                name: review.userName ?? "Anonymous",
                role: review.status,
                comment: review.comment,
                time: review.createdAt,
                avatarUrl: review.profileImgUrl
            )
        }
        
        return cell
    }
}

//MARK: - Collection View Flow Layout
extension ForumTableViewCell: UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 342, height: 100)
    }
}
