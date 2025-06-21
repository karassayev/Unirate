//
//  CollapsibleSectionView.swift
//  test2
//
//  Created by Dias Karassayev on 4/15/25.
//
import UIKit
import SnapKit

class CollapsibleSectionView: UIView {
    private let titleLabel = UILabel()
    private let arrowImageView = UIImageView()
    private let descriptionLabel = UILabel()
    private var isCollapsed = true
    private var descriptionPopUpView: DescriptionPopUpView?

    init(title: String, description: String) {
        super.init(frame: .zero)
        setupViews()
        setupConstraints()
        configure(title: title, description: description)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupViews() {
        layer.cornerRadius = 16
        backgroundColor = UIColor.customGreen2

        titleLabel.font = UIFont(name: "Poppins-Bold", size: 16)
        titleLabel.textColor = .black

        arrowImageView.image = UIImage(systemName: "chevron.down")
        arrowImageView.tintColor = .black
        arrowImageView.contentMode = .scaleAspectFit

        descriptionLabel.font = UIFont(name: "Poppins-Regular", size: 14)
        descriptionLabel.textColor = .darkGray
        descriptionLabel.numberOfLines = 0
        descriptionLabel.isHidden = true

        let tap = UITapGestureRecognizer(target: self, action: #selector(toggleCollapse))
        addGestureRecognizer(tap)

        addSubview(titleLabel)
        addSubview(arrowImageView)
        addSubview(descriptionLabel)
    }

    private func setupConstraints() {
        titleLabel.snp.makeConstraints { make in
            make.top.leading.equalToSuperview().inset(16)
        }
        arrowImageView.snp.makeConstraints { make in
            make.centerY.equalTo(titleLabel)
            make.trailing.equalToSuperview().inset(16)
            make.width.height.equalTo(20)
            make.leading.equalTo(titleLabel.snp.trailing).offset(8)
        }
        descriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(12)
            make.leading.trailing.bottom.equalToSuperview().inset(16)
        }
    }

    private func configure(title: String, description: String) {
        titleLabel.text = title
        descriptionLabel.text = description
    }

    @objc private func toggleCollapse() {
        isCollapsed.toggle()
        UIView.animate(withDuration: 0.3) {
            self.descriptionLabel.isHidden = self.isCollapsed
            let angle: CGFloat = self.isCollapsed ? 0 : .pi
            self.arrowImageView.transform = CGAffineTransform(rotationAngle: angle)
        }
        
        // Show pop-up view
        if isCollapsed {
            descriptionPopUpView?.removeFromSuperview()
        } else {
            showPopUpView()
        }
    }

    private func showPopUpView() {
        descriptionPopUpView = DescriptionPopUpView(description: descriptionLabel.text ?? "")
        descriptionPopUpView?.frame = self.bounds // Adjust the frame as necessary
        if let popUpView = descriptionPopUpView {
            addSubview(popUpView)
            popUpView.snp.makeConstraints { make in
                make.top.equalTo(descriptionLabel.snp.bottom).offset(8)
                make.leading.trailing.bottom.equalToSuperview()
            }
        }
    }
}

class DescriptionPopUpView: UIView {
    private let descriptionTextView = UITextView()

    init(description: String) {
        super.init(frame: .zero)
        setupViews()
        setupConstraints()
        descriptionTextView.text = description
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupViews() {
        backgroundColor = UIColor.white
        layer.cornerRadius = 10
        descriptionTextView.font = UIFont(name: "Poppins-Regular", size: 14)
        descriptionTextView.textColor = .darkGray
        descriptionTextView.isEditable = false
        descriptionTextView.isScrollEnabled = true
        addSubview(descriptionTextView)
    }

    private func setupConstraints() {
        descriptionTextView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(16)
        }
    }
}
