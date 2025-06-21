import UIKit
import SnapKit
import iOSDropDown

import UIKit
import iOSDropDown
import SnapKit

class CalculateTableViewCell: UITableViewCell {
        
    let titleLabel = UILabel.createLabel(size: 14, color: .white, font: "Poppins-Bold", text: "")
    let priceLabel = UILabel.createLabel(size: 20, color: .white, font: "Poppins-Bold", text: "")

    private let containerView = UIView()

    var onValueChange: ((String) -> Void)?  // Замыкание для обновления данных
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.addSubview(containerView)
        containerView.addSubview(titleLabel)
        containerView.addSubview(priceLabel)

        containerView.backgroundColor = UIColor.customGreen
        containerView.layer.cornerRadius = 10
        
        containerView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(8)
        }
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(24)
            make.centerX.equalToSuperview()
        }
        priceLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(12)
            make.centerX.equalToSuperview()
        }

    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with title: String, price: String) {
        titleLabel.text = title
        priceLabel.text = price
    }
}
