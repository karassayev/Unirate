//
//  MenuViewController.swift
//  test1
//
//  Created by Dias Karassayev on 3/25/25.
//

import UIKit
import SnapKit

class MenuViewController: UIViewController, UITextFieldDelegate {

    private let data: [Screen] = [
        .financeCalculator,
        .personalInfo,
        .favourites,
        .loginSecurity,
        .notifications,
        .support,
        .contacts,
        .logOut
    ]
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
    private lazy var chatIcon: UIImageView = {
         let imageView = UIImageView()
        imageView.image = UIImage(named: "chatAI")
        imageView.contentMode = .scaleAspectFill
         imageView.tintColor = .black
         return imageView
     }()
    private lazy var profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "profile") // Set your image here
        imageView.contentMode = .scaleAspectFill
        imageView.tintColor = .black
        return imageView
    }()
    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.text = "Dias"
        label.textColor = .black
        label.font = UIFont(name: "Poppins-Bold", size: 18)
        label.textAlignment = .left
        label.numberOfLines = 0
        return label
    }()
    private lazy var menuTableView: UITableView = {
        let tableView = UITableView()
        tableView.register(MenuTableViewCell.self, forCellReuseIdentifier: Cells.menuTableViewCell)
        tableView.selectionFollowsFocus = false
        tableView.showsVerticalScrollIndicator = false
        tableView.isPagingEnabled = true
        return tableView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        menuTableView.delegate = self
        menuTableView.dataSource = self


        setupUI()
    }
}
extension MenuViewController {
    func setupUI() {
        setupViews()
        setupConstraints()
    }
    func setupViews() {
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        contentView.addSubview(headerView)
        contentView.addSubview(firstView)
        
        firstView.addSubview(profileImageView)
        firstView.addSubview(nameLabel)
        contentView.addSubview(menuTableView)
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
            make.height.equalTo(view.snp.height).multipliedBy(0.08)
        }
        profileImageView.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(10)
            make.size.equalTo(64)
        }
        nameLabel.snp.makeConstraints { make in
            make.left.equalTo(profileImageView.snp.right).offset(25)
            make.height.equalTo(64)
        }
        menuTableView.snp.makeConstraints { make in
            make.top.equalTo(firstView.snp.bottom).offset(30)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(view.snp.height).multipliedBy(0.6)
        }
        
        let lastSubview = [headerView, firstView, menuTableView].last!
        lastSubview.snp.makeConstraints { make in
            make.bottom.equalToSuperview().inset(tabBarController?.tabBar.frame.height ?? 0)
        }
        }
    }

extension MenuViewController:  UITableViewDataSource, UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Cells.menuTableViewCell, for: indexPath) as! MenuTableViewCell
        cell.configure(with: data[indexPath.row].rawValue)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedScreen = data[indexPath.row]
        let screenViewController = selectedScreen.viewController()
        navigationController?.pushViewController(screenViewController, animated: true)
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        return self.view.frame.height * 0.062
        62
    }
}
