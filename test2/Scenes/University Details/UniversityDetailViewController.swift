//
//  UniversityDetailViewController.swift
//  test2
//
//  Created by Dias Karassayev on 4/3/25.
//


import UIKit
import SnapKit
import Kingfisher

class UniversityDetailViewController: UIViewController {
    var university: University?
    private let headerView = HeaderView()
    
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
    
    private lazy var forumView: UIView = {
        let view = UIView()
        return view
    }()

    private lazy var titleLabel: UILabel = {
         let label = UILabel()
         label.text = university?.name
         label.textColor = .black
         label.font = UIFont(name: "Poppins-Bold", size: 24)
         label.numberOfLines = 0
         return label
     }()
    private lazy var ratingCountLabel: UILabel = {
         let label = UILabel()
         let rating = university?.ratingCount
        label.text = "(\(rating ?? 0))"
        label.textColor = .darkGray
         label.font = UIFont(name: "Poppins-Regular", size: 16)
         label.numberOfLines = 0
         return label
     }()
    
    private lazy var ratingStackView: UIStackView = {
        let starStackView = UIStackView()
        starStackView.axis = .horizontal
        starStackView.spacing = 0.2
        starStackView.distribution = .fillEqually
        
        let rating = university?.rating

        if let ratingInt = rating {
            for _ in 0..<Int(ratingInt) {
                let starImageView = UIImageView(image: UIImage(named: "star"))
                starImageView.tintColor = .systemYellow
                starImageView.contentMode = .scaleAspectFit
                starStackView.addArrangedSubview(starImageView)
            }
        }

        return starStackView
     }()
    
    private lazy var likeIcon: UIImageView = {
         let imageView = UIImageView()
        imageView.image = UIImage(named: "like")
         imageView.tintColor = .black
         return imageView
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
    
    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "uni")
        DispatchQueue.main.async { [self] in
            if let imgUrl = university?.logoUrl{
                self.imageView.kf.setImage(with: URL(string: imgUrl))
            }
        }
         imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 20
        imageView.clipsToBounds = true
         return imageView
     }()
    private lazy var detailsLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.font = UIFont(name: "Poppins-Regular", size: 16)
        label.numberOfLines = 0
        label.text = """
        Average tuition price      \(university?.baseCost ?? 0)
        Dormitory         \((university?.dormitory == true) ? "exist" : "don't have")
        Military department      \((university?.dormitory == true) ? "exist" : "don't have")
        """
        return label
    }()
    private lazy var facultyTableView: UITableView = {
        let tableView = UITableView()
        tableView.register(FacultyTableViewCell.self, forCellReuseIdentifier: Cells.facultyTableViewCell)
        tableView.selectionFollowsFocus = false
        tableView.showsVerticalScrollIndicator = false
        tableView.isPagingEnabled = true
        tableView.isScrollEnabled = false
        return tableView
    }()
    
    private lazy var commentLabel = UILabel.createLabel(size: 24, color: .black, font: "Poppins-Bold", text: "Add a comment")
    private lazy var commentTextField = UITextField.createTextField(placeholder: "Share your thought")
    private lazy var postButton = UIButton.createButton(title: "Post It", color: UIColor.customGreen, textColor: .white, image: UIImage(named: "arrow"))
    {
//        self.calculateTotal()
    }
    private lazy var commentNumLabel = UILabel.createLabel(size: 24, color: .black, font: "Poppins-Bold", text: "3 comments")
    private lazy var goForumButton = UIButton.createButton(title: "Go to Forum  →", color: UIColor.white, textColor: UIColor.customGreen, image: UIImage(named: "arrow")){
        
    }


    override func viewDidLoad() {
        super.viewDidLoad()
        setUpDelegates()
        setupUI()
    }

}
extension UniversityDetailViewController {
    
    func setUpDelegates(){
        facultyTableView.dataSource = self
        facultyTableView.delegate = self
    }
    func setupUI() {
        setupViews()
        setupConstraints()
    }
    func setupViews() {
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        contentView.addSubview(headerView)
        
        contentView.addSubview(firstView)
        firstView.addSubview(titleLabel)
        firstView.addSubview(likeIcon)
        firstView.addSubview(imageView)
        firstView.addSubview(ratingStackView)
        firstView.addSubview(calculateButton)
        firstView.addSubview(detailsLabel)
        firstView.addSubview(ratingCountLabel)

        contentView.addSubview(facultyTableView)
        
        contentView.addSubview(forumView)
        forumView.addSubview(commentLabel)
        forumView.addSubview(commentTextField)
        forumView.addSubview(postButton)
        forumView.addSubview(commentNumLabel)
        forumView.addSubview(goForumButton)


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
            make.top.equalTo(imageView.snp.bottom).offset(24)
            make.leading.equalToSuperview()
            make.right.equalTo(likeIcon.snp.left).offset(16)
        }
        likeIcon.snp.makeConstraints { make in
            make.top.equalTo(imageView.snp.bottom).offset(24)
            make.trailing.equalToSuperview().inset(16)
            make.size.equalTo(52)
        }
        ratingStackView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(24)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(24)
            make.width.equalToSuperview().multipliedBy(0.4)
        }
        ratingCountLabel.snp.makeConstraints { make in
            make.top.equalTo(ratingStackView.snp.bottom).offset(8)
            make.leading.trailing.equalToSuperview()
        }
        detailsLabel.snp.makeConstraints { make in
            make.top.equalTo(ratingStackView.snp.bottom).offset(40)
            make.leading.trailing.equalToSuperview()
        }
        
        calculateButton.snp.makeConstraints { make in
            make.top.equalTo(detailsLabel.snp.bottom).offset(30)
            make.leading.equalToSuperview()
            make.height.equalTo(48)
            make.width.equalTo(view.snp.width).multipliedBy(0.7)
        }
        
        facultyTableView.snp.makeConstraints { make in
            make.top.equalTo(firstView.snp.bottom).offset(60)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(CGFloat((university?.faculty.count ?? 0)) * (self.view.frame.height * 0.6))
//            make.bottom.equalToSuperview().inset(20)
        }
        forumView.snp.makeConstraints { make in
            make.top.equalTo(facultyTableView.snp.bottom).offset(30)
            make.leading.trailing.equalToSuperview().offset(16).inset(16)
            make.height.equalTo(view.snp.height).multipliedBy(0.6)
        }
        commentLabel.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.equalToSuperview()
        }
        commentTextField.snp.makeConstraints { make in
            make.top.equalTo(commentLabel.snp.bottom).offset(40)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(120)
        }
        
        postButton.snp.makeConstraints { make in
            make.top.equalTo(commentTextField.snp.bottom).offset(20)
            make.trailing.equalToSuperview()
            make.height.equalTo(48)
            make.width.equalTo(view.snp.width).multipliedBy(0.7)
        }
        
        commentNumLabel.snp.makeConstraints { make in
            make.top.equalTo(postButton.snp.bottom).offset(40)
            make.leading.equalToSuperview()
        }
        goForumButton.snp.makeConstraints { make in
            make.top.equalTo(postButton.snp.bottom).offset(40)
            make.trailing.equalToSuperview()
            make.height.equalTo(30)
            make.width.equalTo(view.snp.width).multipliedBy(0.5)
        }
        
        let lastSubview = [headerView, firstView, facultyTableView, forumView].last!
        lastSubview.snp.makeConstraints { make in
            make.bottom.equalToSuperview().inset(tabBarController?.tabBar.frame.height ?? 0)
        }
    }
}
extension UniversityDetailViewController:  UITableViewDataSource, UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        (university?.faculty.count)!
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Cells.facultyTableViewCell, for: indexPath) as! FacultyTableViewCell

        let facultyData = university?.faculty[indexPath.row]
        cell.configure(with: facultyData)

        cell.onSpecialtyTapped = { [weak self] specialty in
            guard let self = self else { return }
            let vc = FacultiesViewController()
            vc.configure(title: specialty.name, description: specialty.description, imgUrl: specialty.specialtyImageUrl!, gop: specialty.gopCode!, grant: specialty.grants!, min: specialty.minScores!)
            self.navigationController?.pushViewController(vc, animated: true)
        }

        return cell
    }




//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        let selectedScreen = data[indexPath.row]
//        let screenViewController = selectedScreen.viewController()
//        navigationController?.pushViewController(screenViewController, animated: true)
//        
//        tableView.deselectRow(at: indexPath, animated: true)
//    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return self.view.frame.height * 0.6
        
    }
}
