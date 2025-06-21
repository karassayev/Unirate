//
//  FacultiesViewController.swift
//  test1
//
//  Created by Dias Karassayev on 3/20/25.
//

import UIKit
import SnapKit
import MXSegmentedControl

class FacultiesViewController: UIViewController {
    private let headerView = HeaderView()
//    private let totalTableView = TotalTableViewController()
    var a = ""
    var b = ""
    var c = ""
    private var items = ["Item 1", "Item 2", "Item 3"]

//    private lazy var tableView = TotalTableViewController(items: items)
    
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.showsVerticalScrollIndicator = false
        return scrollView
    }()
    
    private lazy var contentView: UIView = {
        let view = UIView()
        return view
    }()
    
    private lazy var firstView: UIView = {
        let view = UIView()
        return view
    }()
    private lazy var secondView: UIView = {
        let view = UIView()
        return view
    }()
    private lazy var totalsView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.transparentGreen
        return view
    }()
    private lazy var imageView: UIImageView = {
         let imageView = UIImageView()
         imageView.image = UIImage(named: "uni")
         imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 20
        imageView.clipsToBounds = true
         return imageView
     }()
    
    private lazy var titleLabel: UILabel = {
         let label = UILabel()
//         label.text = "Information Systems"
         label.textColor = .black
         label.font = UIFont(name: "Poppins-Bold", size: 24)
         label.textAlignment = .center
         label.numberOfLines = 0
         return label
     }()
    private lazy var detailsLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.font = UIFont(name: "Poppins-Regular", size: 18)
        label.numberOfLines = 0
        let fullText = """
        Details
        
        GOP code       \(a)
        Grants         \(b)
        Minimum scores     \(c)
        """
        let attributedText = NSMutableAttributedString(string: fullText)
        if let range = fullText.range(of: "Details") {
            let nsRange = NSRange(range, in: fullText)
            attributedText.addAttribute(.font, value: UIFont(name: "Poppins-Bold", size: 20) ?? "", range: nsRange)
        }
        label.attributedText = attributedText
        return label
    }()
    
    private lazy var descriptionLabel: UILabel = {
         let label = UILabel()
//         label.text = "The Information Systems Department plays a crucial role in managing and optimizing the technology infrastructure of our organization. This team is responsible for developing innovative solutions that enhance data management, streamline operations, and support decision-making processes. With a focus on integrating cutting-edge technologies, the department ensures that all systems are secure, efficient, and aligned with the strategic goals of the company."
         label.textColor = .black
         label.font = UIFont(name: "Poppins-Regular", size: 16)
         label.textAlignment = .left
         label.numberOfLines = 0
         return label
     }()
    private lazy var totalLabel: UILabel = {
         let label = UILabel()
         label.text = "Information Systems"
         label.textColor = .black
         label.font = UIFont(name: "Poppins-Bold", size: 24)
         label.textAlignment = .center
         label.numberOfLines = 0
         return label
     }()
    private lazy var syllabusLabel: UILabel = {
         let label = UILabel()
         label.text = "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sapien, est felis, sagittis viver nulla mattis scelerisque."
         label.textColor = .black
         label.font = UIFont(name: "Poppins-Regular", size: 16)
         label.textAlignment = .left
         label.numberOfLines = 0
         label.isHidden = true
         return label
     }()
    private lazy var calculateButton: UIButton = {
        let button = UIButton()
        button.setTitle("Calculate tuition cost", for: .normal)
        button.backgroundColor = UIColor.customGreen
        button.layer.cornerRadius = 20
        button.titleLabel?.font = UIFont(name: "Poppins-Bold", size: 16)
        button.configuration?.cornerStyle = .capsule
        return button
    }()
    private lazy var segmentControl: MXSegmentedControl = {
        let items = ["Description", "Syllabus"]
        let control = MXSegmentedControl(withTitles: items)
//        control.selectedIndex = 1  // Use selectedIndex instead of selectedSegmentIndex
//        control.backgroundColor = UIColor.customGreen2
//        // Uncomment and customize as needed
        control.textColor = UIColor.black
        control.selectedTextColor = UIColor.customGreen
        control.indicator.lineView.frame.size.height = 8
        control.font = UIFont(name: "Poppins-Bold", size: 20)!
        control.indicator.lineView.backgroundColor = UIColor.customGreen
        control.addTarget(self, action: #selector(segmentChanged(_:)), for: .valueChanged)
        return control
    }()

    func configure(title: String, description: String, imgUrl: String?, gop: String, grant: String, min: String){
        titleLabel.text = title
        descriptionLabel.text = description
        DispatchQueue.main.async { [self] in
            if let url = imgUrl{
                self.imageView.kf.setImage(with: URL(string: url))
            }
        }
        a = gop
        b = grant
        c = min
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        
        
        setupUI()
    }
    @objc private func segmentChanged(_ sender: MXSegmentedControl) {
        // Get the selected segment index
        let selectedIndex = sender.selectedIndex // Correct property name
        
        // Change visibility based on the selected index
        let isDescriptionSelected = selectedIndex == 0
        descriptionLabel.isHidden = !isDescriptionSelected
        syllabusLabel.isHidden = isDescriptionSelected
        
        // Optionally, change indicator colors based on the selected segment
        // Change indicator colors based on the selected index
        if selectedIndex == 0 {
            sender.indicator.boxView.backgroundColor = UIColor.customGreen // Customize for "Description"
            sender.indicator.lineView.backgroundColor = UIColor.customGreen
        } else if selectedIndex == 1 {
            sender.indicator.boxView.backgroundColor = UIColor.customGreen // Customize for "Syllabus"
            sender.indicator.lineView.backgroundColor = UIColor.customGreen
        }
    }

}
extension FacultiesViewController {
    func setupUI() {
        setupViews()
        setupConstraints()
    }
    func setupViews() {
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
//        view.addSubview(tableView)

        
        contentView.addSubview(headerView)
        
        contentView.addSubview(firstView)
        firstView.addSubview(imageView)
        firstView.addSubview(titleLabel)
        firstView.addSubview(detailsLabel)
        firstView.addSubview(calculateButton)
        
        contentView.addSubview(secondView)
        secondView.addSubview(segmentControl)
        secondView.addSubview(descriptionLabel)
        secondView.addSubview(syllabusLabel)
        
        contentView.addSubview(totalsView)

    }
    
    func setupConstraints() {
        scrollView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        contentView.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview() // Set top and bottom to match scrollView's content size
            make.leading.trailing.equalTo(view)
        }
        headerView.snp.makeConstraints { make in
            make.top.equalToSuperview()

            make.left.right.equalToSuperview()
            make.height.equalTo(60)
        }
            firstView.snp.makeConstraints { make in
                make.top.equalTo(headerView.snp.bottom).offset(30)
                make.leading.trailing.equalToSuperview().offset(16).inset(16)
                make.height.equalTo(view.snp.height).multipliedBy(0.6)
            }
            imageView.snp.makeConstraints { make in
                make.top.equalToSuperview()
                make.leading.trailing.equalToSuperview()
                make.height.equalTo(view.snp.height).multipliedBy(0.25)
            }
            titleLabel.snp.makeConstraints { make in
                make.top.equalTo(imageView.snp.bottom).offset(30)
                make.leading.trailing.equalToSuperview().offset(16).inset(16)
            }
            detailsLabel.snp.makeConstraints { make in
                make.top.equalTo(titleLabel.snp.bottom).offset(30)
                make.leading.equalToSuperview()
                
            }
            calculateButton.snp.makeConstraints { make in
                make.top.equalTo(detailsLabel.snp.bottom).offset(30)
                make.leading.equalToSuperview()
                make.height.equalTo(48)
                make.width.equalTo(view.snp.width).multipliedBy(0.7)
            }
        secondView.snp.makeConstraints { make in
            make.top.equalTo(firstView.snp.bottom).offset(30)
            make.leading.trailing.equalToSuperview().offset(16).inset(16)
            make.bottom.equalToSuperview().inset(16) // Or another relevant bottom constraint
        }
            segmentControl.snp.makeConstraints { make in
                make.top.equalToSuperview()
                make.leading.trailing.equalToSuperview()
                make.height.equalTo(40)
            }
        descriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(segmentControl.snp.bottom).offset(10)
            make.leading.trailing.bottom.equalToSuperview()
        }

        syllabusLabel.snp.makeConstraints { make in
            make.top.equalTo(segmentControl.snp.bottom).offset(10)
            make.leading.trailing.bottom.equalToSuperview()
        }
        let lastSubview = [headerView, firstView, secondView].last!
        lastSubview.snp.makeConstraints { make in
            make.bottom.equalToSuperview().inset(tabBarController?.tabBar.frame.height ?? 0)
        }
//        tableView.snp.makeConstraints { make in
//            make.edges.equalToSuperview()
//            make.height.equalToSuperview()
//            make.leading.trailing.equalToSuperview()
//        }
        }
    }

