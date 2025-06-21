//
//  ChatVell.swift
//  test2
//
//  Created by Dias Karassayev on 4/16/25.
//

import UIKit
import SnapKit

class ChatCell: UITableViewCell {
    
    // MARK: - UI Components
    
    private let bubbleView = UIView()
    private let messageLabel = UILabel.createLabel(size: 16, color: .black, font: "Poppins-Regular", text: "")
    private let timestampLabel = UILabel.createLabel(size: 11, color: .lightGray, font: "Poppins-Regular", text: "")
    // MARK: - Init
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Configuration
    
    func configure(with message: ChatMessage) {
        messageLabel.text = message.text
        
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM d, h:mm a"
        timestampLabel.text = formatter.string(from: message.timestamp)
        
        switch message.sender {
        case .user:
            bubbleView.backgroundColor = .lightText
            messageLabel.textAlignment = .left
            timestampLabel.textAlignment = .right
            bubbleView.snp.remakeConstraints { make in
                make.right.equalToSuperview().inset(12)
                make.top.bottom.equalToSuperview().inset(8)
                make.width.lessThanOrEqualToSuperview().multipliedBy(0.7)
            }
        case .gemini:
            bubbleView.backgroundColor = UIColor.customGreen2
            messageLabel.textAlignment = .left
            timestampLabel.textAlignment = .left
            bubbleView.snp.remakeConstraints { make in
                make.left.equalToSuperview().inset(12)
                make.top.bottom.equalToSuperview().inset(8)
                make.width.lessThanOrEqualToSuperview().multipliedBy(0.7)
            }
        }
    }
}

// MARK: - UI Setup

private extension ChatCell {
    
    func setupUI() {
        selectionStyle = .none
        
        contentView.addSubview(bubbleView)
        bubbleView.layer.cornerRadius = 16
        bubbleView.clipsToBounds = true
        
        [messageLabel, timestampLabel].forEach { bubbleView.addSubview($0) }
        
        messageLabel.snp.makeConstraints { make in
            make.top.left.right.equalToSuperview().inset(12)
        }
        
        timestampLabel.snp.makeConstraints { make in
            make.top.equalTo(messageLabel.snp.bottom).offset(4)
            make.left.right.equalToSuperview().inset(12)
            make.bottom.equalToSuperview().inset(8)
        }
    }
}
