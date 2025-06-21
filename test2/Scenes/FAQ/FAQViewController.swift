////
////  FAQViewController.swift
////  test1
////
////  Created by Dias Karassayev on 3/25/25.
//
//
//
//import UIKit
//import SnapKit
//
//class FAQViewController: UIViewController {
//    
//    private let headerView = HeaderView()
//
//    private lazy var scrollView: UIScrollView = {
//        let scrollView = UIScrollView()
//        scrollView.showsVerticalScrollIndicator = false
//        return scrollView
//    }()
//
//    private lazy var contentView: UIView = {
//        let view = UIView()
//        return view
//    }()
//
//    private lazy var titleLabel: UILabel = {
//        let label = UILabel()
//        label.text = "FAQ"
//        label.textColor = .black
//        label.font = UIFont(name: "Poppins-Bold", size: 24)
//        label.textAlignment = .center
//        return label
//    }()
//
//    private let section1 = CollapsibleSectionView(title: "What is this app?", description: "This app helps you rate universities and share reviews.")
//    private let section2 = CollapsibleSectionView(title: "How to register?", description: "Go to the register screen and fill in your details.")
//    private let section3 = CollapsibleSectionView(title: "Is it free?", description: "Yes, it's completely free to use.")
//
//    private lazy var stack: UIStackView = {
//        let stack = UIStackView(arrangedSubviews: [section1, section2, section3])
//        stack.axis = .vertical
//        stack.spacing = 12
//        return stack
//    }()
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        view.backgroundColor = .white
//        setupUI()
//    }
//}
//
//private extension FAQViewController {
//    func setupUI() {
//        view.addSubview(scrollView)
//        scrollView.addSubview(contentView)
//        contentView.addSubview(headerView)
//        contentView.addSubview(titleLabel)
//
//        contentView.addSubview(stack)
//        
//        scrollView.snp.makeConstraints { make in
//            make.edges.equalToSuperview()
//        }
//        contentView.snp.makeConstraints { make in
//            make.edges.equalToSuperview()
//            make.width.equalTo(view)
//        }
//        headerView.snp.makeConstraints { make in
//            make.top.left.right.equalToSuperview()
//            make.height.equalTo(60)
//        }
//        titleLabel.snp.makeConstraints { make in
//            make.top.equalTo(headerView.snp.bottom).offset(24)
//            make.centerX.equalToSuperview()
//        }
//        stack.snp.makeConstraints { make in
//            make.top.equalTo(titleLabel.snp.bottom).offset(24)
//            make.leading.trailing.equalToSuperview().inset(16)
//            make.bottom.equalToSuperview().inset(16)
//        }
//    }
//}
struct FAQItem {
    let question: String
    let answer: String
    var isExpanded: Bool
}
import UIKit
import SnapKit

class FAQViewController: UIViewController {
    
    private let tableView = UITableView()
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
    
    
    private var items: [FAQItem] = [
        FAQItem(question: "What is Unirate?", answer: """
        Unirate is a platform that helps students explore and compare universities in Kazakhstan. We provide detailed information about programs, admission scores, grants, reviews, and career paths to help you make informed decisions.
        """, isExpanded: true),
        FAQItem(question: "Is Unirate free to use?", answer: """
        Yes, Unirate is completely free for all users. You can browse universities, programs, and student reviews without any charges or sign-up.
        """, isExpanded: true),
        FAQItem(question: "How accurate is the information on Unirate?", answer: """
        We gather our data from official sources such as the Ministry of Education of Kazakhstan, university websites, and verified student contributions. We regularly update content to ensure accuracy.
        """, isExpanded: true),
        FAQItem(question: "I’m a high school student. How can Unirate help me?", answer: """
        Unirate helps you: Discover suitable university programs. Learn about admission requirements and scores. See real student reviews. Understand career prospects based on your interests.
        """, isExpanded: true),
        FAQItem(question: "How can I contact the Unirate team?", answer: """
        You can reach out to us via our Contact Us page or email us directly at support@unirate.kz. We’re happy to help!
        """, isExpanded: true),
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.customGreen2
        title = "FAQ"
        
        setupTableView()
    }
    
    private func setupTableView() {
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide).inset(16)
        }
        tableView.register(FAQCell.self, forCellReuseIdentifier: FAQCell.identifier)
        tableView.dataSource = self
        tableView.showsVerticalScrollIndicator = false
        tableView.delegate = self
        tableView.separatorStyle = .none
        tableView.estimatedRowHeight = 80
        tableView.rowHeight = UITableView.automaticDimension
        tableView.backgroundColor = .clear
    }
}

extension FAQViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        guard let cell = tableView.dequeueReusableCell(withIdentifier: FAQCell.identifier, for: indexPath) as? FAQCell else {
            return UITableViewCell()
        }
        let item = items[indexPath.row]
        cell.configure(with: item)
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        items[indexPath.row].isExpanded.toggle()
        tableView.reloadRows(at: [indexPath], with: .automatic)
    }
}

class FAQCell: UITableViewCell {
    
    static let identifier = "FAQCell"

    private let container = UIView()
    private let icon = UIImageView()
    private let questionLabel = UILabel()
    private let answerBackground = UIView()
    private let answerLabel = UILabel()
    
    private let plusIcon = UIImage(systemName: "plus.circle")
    private let minusIcon = UIImage(systemName: "minus.circle")

    private var stackView: UIStackView!
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(with item: FAQItem) {
        questionLabel.text = item.question
        answerLabel.text = item.answer
        let isExpanded = item.isExpanded
        
        icon.image = isExpanded ? minusIcon : plusIcon
        icon.tintColor = isExpanded ? UIColor.customGreen : UIColor.systemGray
        questionLabel.textColor = isExpanded ? UIColor.customGreen : UIColor.label
        
        answerBackground.isHidden = !isExpanded
    }

    private func setupUI() {
        backgroundColor = .clear
        contentView.addSubview(container)
        container.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(8)
        }
        container.backgroundColor = UIColor.white
        container.layer.cornerRadius = 20

        // Horizontal stack for icon + question
        let headerStack = UIStackView(arrangedSubviews: [icon, questionLabel])
        headerStack.axis = .horizontal
        headerStack.spacing = 10
        icon.snp.makeConstraints { $0.width.height.equalTo(20) }

        // Answer view
        answerBackground.backgroundColor = .white
        answerBackground.layer.cornerRadius = 16
        answerLabel.numberOfLines = 0
        answerLabel.font = UIFont.systemFont(ofSize: 14)
        answerLabel.textColor = UIColor.darkGray

        answerBackground.addSubview(answerLabel)
        answerLabel.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(16)
        }

        // Main vertical stack
        stackView = UIStackView(arrangedSubviews: [headerStack, answerBackground])
        stackView.axis = .vertical
        stackView.spacing = 12
        stackView.alignment = .fill
        stackView.distribution = .fill

        container.addSubview(stackView)
        stackView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(16)
        }

        questionLabel.numberOfLines = 0
        questionLabel.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
    }
}
