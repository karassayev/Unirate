//
//  FinanceCalculatorVC.swift
//  test2
//
//  Created by Dias Karassayev on 3/25/25.
//
//
import UIKit
import SnapKit


class ForumViewController: UIViewController{
    private let headerView = HeaderView()
    
    var reviewResults: [Forum] = []

    
    private var price: [Int] = [0,0,0,0]

    
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

    private lazy var titleLabel = UILabel.createLabel(size: 24, color: .black, font: "Poppins-Bold", text: "Forum")
    
    private lazy var imageView: UIImageView = {
         let imageView = UIImageView()
        imageView.image = UIImage(named: "uni")
         imageView.tintColor = .black
        imageView.layer.cornerRadius = 20
         imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
         return imageView
     }()
    

    private lazy var forumTableView: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = .red
        tableView.register(ForumTableViewCell.self, forCellReuseIdentifier: Cells.forumTableViewCell)
        tableView.selectionFollowsFocus = false
        tableView.allowsSelection = false
        tableView.showsVerticalScrollIndicator = false
        tableView.isPagingEnabled = true
        tableView.isScrollEnabled = false
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupUI()
        forumTableView.delegate = self
        forumTableView.dataSource = self
        
        ReviewService().fetchForums()  { result in
            switch result {
            case .success(let reviews):
                self.reviewResults = reviews
                print("✅ Получено отзывов: \(reviews.count)")
                DispatchQueue.main.async { // Ensure the UI is updated on the main thread
                    self.forumTableView.reloadData() // Reload the collection view
                }
                // Обновите UI здесь (например, tableView.reloadData())
            case .failure(let error):
                print("❌ Ошибка при получении отзывов: \(error.localizedDescription)")
            }
        }
    }

}
extension ForumViewController {
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
        firstView.addSubview(imageView)
        
        contentView.addSubview(forumTableView)

    }
    
    func setupConstraints() {
        scrollView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        contentView.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.leading.trailing.equalTo(view)
        }
        headerView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.left.right.equalToSuperview()
            make.height.equalTo(60)
        }
        
        firstView.snp.makeConstraints { make in
            make.top.equalTo(headerView.snp.bottom).offset(20)
            make.leading.trailing.equalToSuperview().offset(16).inset(16)
            make.height.equalToSuperview().multipliedBy(0.25)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.centerX.equalToSuperview()
        }
        
        imageView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(40)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(view).multipliedBy(0.23)
        }
        
        forumTableView.snp.makeConstraints { make in
            make.top.equalTo(firstView.snp.bottom).offset(10)
            make.leading.trailing.equalToSuperview().offset(16).inset(16)
            make.height.equalTo(view.snp.height).multipliedBy(0.9)

        }

        let lastSubview = [headerView, firstView, forumTableView].last!

        lastSubview.snp.makeConstraints { make in
            make.bottom.equalToSuperview().inset(tabBarController?.tabBar.frame.height ?? 0)
        }
        }
    }

extension ForumViewController:  UITableViewDataSource, UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        reviewResults.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Cells.forumTableViewCell, for: indexPath) as! ForumTableViewCell
        cell.configure(with: reviewResults[indexPath.item])
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return self.view.frame.height * 0.25
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 10  // любое значение отступа
    }
}
