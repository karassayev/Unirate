import UIKit
import CHIPageControl
import SnapKit
import MarqueeLabel

class MainPage: UIViewController, HeaderViewDelegate {
    
    func didTapHeartIcon() {
        print("kkkk")
        let newScreen = NotificationsViewController()
        navigationController?.pushViewController(newScreen, animated: true)
    }
    
    let featuresTitles = ["Financial Calculator", "Connect with Students & Alumni", "University Rankings", "University Search & Comparison"]
    let featuresDescription = ["Plan your budget with our financial calculator, which helps you estimate tuition, living expenses, and other costs.",
                               "Engage with real students and alumni to get valuable advice and insights to guide your decisions.",
                               "View up-to-date rankings and compare universities by reputation in various disciplines.",
        "I really needed a tool like UniRate during high school. That financial calculator would’ve helped me and my parents a lot."]
    
    let userNames = ["Aruzhan T.", "Dias K.", "Miras A.", "Aliya N.", "Sanzhar B."]

    let workPositions = ["iOS Developer", "QA Engineer", "Backend Developer", "UI/UX Designer", "Project Manager"]

    let reviews = [
        "Very user-friendly app with a clean interface. It’s easy to navigate even for first-time users.",
        "Works fast and hasn’t crashed once — great job! Performance is smooth even on older devices.",
        "Please add dark mode and filters to the list view. That would make using it at night much easier.",
        "Sometimes data takes a while to load, but overall it’s great. I hope future updates improve speed.",
        "I use it daily — it’s an essential tool for students! It really helps me stay organized and on track."
    ]

    
//    private let universitiesCollectionView = BaseUniCollectionView()
//    private let universitiesView = UniversitiesView()
    let universityService = UniversityService()
    var universitiesResults: [University] = []
    var favoriteUniversities: Set<Int> = []


    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.showsVerticalScrollIndicator = false
        return scrollView
    }()
    
    private lazy var contentView: UIView = {
        let view = UIView()
        return view
    }()
    
    private lazy var headerView: UIView = {
        let view = UIView()
        return view
    }()
    private lazy var welcomeContentView: UIView = {
        let view = UIView()
        return view
    }()
    private lazy var featureContentView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.transparentGreen
        return view
    }()
    private lazy var runningLineView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.customGreen.withAlphaComponent(0.05)
        return view
    }()
    private lazy var universitiesView: UIView = {
        let view = UIView()
        return view
    }()
    private lazy var reviewsView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.transparentGreen
        return view
    }()
    private lazy var footerView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 20
        view.backgroundColor = UIColor.customGreen2
        return view
    }()
    private lazy var backImage: UIImageView = {
         let imageView = UIImageView()
        imageView.image = UIImage(named: "main1")
         imageView.tintColor = .black
         imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
         return imageView
     }()
    private lazy var logoIcon: UIImageView = {
         let imageView = UIImageView()
        imageView.image = UIImage(named: "logo")
         imageView.tintColor = .black
         return imageView
     }()
    private lazy var logoLabel: UILabel = {
         let label = UILabel()
         label.text = "UniRate logo"
         label.textColor = .black
        label.font = UIFont(name: "Poppins-Bold", size: 14)
         return label
     }()
    private lazy var heartIcon: UIImageView = {
         let imageView = UIImageView()
         imageView.image = UIImage(systemName: "heart")
         imageView.tintColor = .gray
         return imageView
     }()
    private lazy var menuIcon: UIImageView = {
         let imageView = UIImageView()
         imageView.image = UIImage(systemName: "line.horizontal.3")
         imageView.tintColor = .gray
         return imageView
     }()
    private lazy var titleLabel: UILabel = {
         let label = UILabel()
         label.text = "UniRate platform!"
         label.textColor = .black
         label.textAlignment = .left
         label.font = UIFont(name: "Poppins-Bold", size: 48)
         label.numberOfLines = 0
         return label
     }()
    private lazy var descriptionLabel: UILabel = {
         let label = UILabel()
         label.text = "Discover, Compare, and Choose the Best Universities Worldwide with UniRate."
         label.textAlignment = .left
         label.textColor = .gray
         label.font = UIFont.systemFont(ofSize: 16)
         label.numberOfLines = 0
         return label
     }()
    private lazy var discoverButton: UIButton = {
        var config = UIButton.Configuration.filled()
        config.title = "Discover"
        config.baseForegroundColor = .white
        config.baseBackgroundColor = UIColor.customGreen
        config.image = UIImage(named: "rocket")
        config.imagePadding = 10
        config.cornerStyle = .capsule
        let font = UIFont(name: "Poppins-Bold", size: 18) ?? UIFont.systemFont(ofSize: 18, weight: .bold)
        config.attributedTitle = AttributedString("Discover", attributes: AttributeContainer([.font: font]))
        
        let button = UIButton(configuration: config)
        button.addTarget(self, action: #selector(scrollToCollectionView), for: .touchUpInside)
        return button
    }()
    private lazy var chatIcon: UIImageView = {
         let imageView = UIImageView()
        imageView.image = UIImage(named: "chatAI")
         imageView.tintColor = .black
        imageView.isUserInteractionEnabled = true
         return imageView
     }()
    private lazy var runningLineLabel: MarqueeLabel = {
        let label = MarqueeLabel()
        label.type = .continuousReverse
        label.text = "🎉The best universities are waiting for you!   Admission 2025 -2026🎉"
        label.textColor = .black
        label.font = UIFont(name: "Poppins-Regular", size: 16)
        label.speed = .rate(50)
        label.fadeLength = 10.0
        label.leadingBuffer = 30.0
        return label
    }()
    private lazy var featureLabel1: UILabel = {
         let label = UILabel()
         label.text = "Explore Our Core"
         label.textColor = .black
        label.font = UIFont(name: "Poppins-Regular", size: 14)
         label.textAlignment = .center
         return label
     }()
    private lazy var featureLabel2: UILabel = {
         let label = UILabel()
         label.text = "Discover the Smart Way to Choose Your Future University"
         label.textColor = .black
         label.font = UIFont(name: "Poppins-Bold", size: 24)
         label.textAlignment = .center
         label.numberOfLines = 0
         return label
     }()
    private lazy var universitiesLabel: UILabel = {
         let label = UILabel()
         label.text = "Most Popular"
         label.textColor = .black
        label.font = UIFont(name: "Poppins-Regular", size: 14)
         label.textAlignment = .center
         return label
     }()
    private lazy var universitiesDescription: UILabel = {
         let label = UILabel()
         label.text = "University lists"
         label.textColor = .black
         label.font = UIFont(name: "Poppins-Bold", size: 24)
         label.textAlignment = .center
         label.numberOfLines = 0
         return label
     }()
    
    private lazy var reviewsLabel: UILabel = {
         let label = UILabel()
         label.text = "See how our landing page platform is making an impact."
         label.textColor = .black
        label.font = UIFont(name: "Poppins-Regular", size: 14)
        label.numberOfLines = 0
         label.textAlignment = .center
         return label
     }()
    private lazy var reviewsDescription: UILabel = {
         let label = UILabel()
         label.text = "Real Stories from Satisfied Students"
         label.textColor = .black
         label.font = UIFont(name: "Poppins-Bold", size: 24)
         label.textAlignment = .center
         label.numberOfLines = 0
         return label
     }()
    
    private lazy var featuresCollectionView: UICollectionView = {
        let collectionViewLayout = UICollectionViewFlowLayout()
        collectionViewLayout.scrollDirection = .horizontal
        featuresCollectionView = UICollectionView(frame: .zero, collectionViewLayout: collectionViewLayout)
        featuresCollectionView.showsHorizontalScrollIndicator = false
        featuresCollectionView.register(FeatureCollectionViewCell.self, forCellWithReuseIdentifier: Cells.FeatureCollectionViewCell)
        featuresCollectionView.backgroundColor = .transparentGreen
        featuresCollectionView.isPagingEnabled = true
        return featuresCollectionView
    }()
    private lazy var universitiesCollectionView: UICollectionView = {
        let collectionViewLayout = UICollectionViewFlowLayout()
        collectionViewLayout.scrollDirection = .horizontal
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: collectionViewLayout)
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.register(UniversitiesCollectionViewCell.self, forCellWithReuseIdentifier: Cells.UniversitiesCollectionViewCell)
        return collectionView
    }()
    
    private lazy var reviewsCollectionView: UICollectionView = {
        let collectionViewLayout = UICollectionViewFlowLayout()
        collectionViewLayout.scrollDirection = .horizontal
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: collectionViewLayout)
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.register(ReviewCollectionViewCell.self, forCellWithReuseIdentifier: Cells.reviewsCollectionViewCell)
        collectionView.backgroundColor = .transparentGreen
        return collectionView
    }()
    
    private lazy var footerLabel: UILabel = {
         let label = UILabel()
         label.text = "Join Our Newsletter"
         label.textColor = .black
        label.font = UIFont(name: "Poppins-Bold", size: 24)
         return label
     }()
    private lazy var footerDescriptionLabel: UILabel = {
         let label = UILabel()
         label.text = "Never miss a beat on new landing page designs and features."
         label.textColor = .black
        label.numberOfLines = 0
        label.font = UIFont(name: "Poppins-Regular", size: 14)
         return label
     }()
    private lazy var emailTextField = UITextField.createTextField(placeholder: "Enter your email here")
    
    private lazy var subscribeButton: UIButton = {
        var config = UIButton.Configuration.filled()
        config.title = "Subscribe"
        config.baseForegroundColor = .white
        config.baseBackgroundColor = UIColor.customGreen
        config.image = UIImage(named: "main4")
        config.imagePadding = 10
        config.cornerStyle = .capsule

        let font = UIFont(name: "Poppins-Bold", size: 18) ?? UIFont.systemFont(ofSize: 18, weight: .bold)
        config.attributedTitle = AttributedString("Subscribe", attributes: AttributeContainer([.font: font]))

        let button = UIButton(configuration: config)
        
        // Add target for the button
        button.addTarget(self, action: #selector(subscribeButtonTapped), for: .touchUpInside)
        
        return button
    }()

    @objc func subscribeButtonTapped() {
        print("kotak")
//        guard let email = emailTextField.text, !email.isEmpty else {
//            // Handle empty email case if needed
//            return
//        }
//
        AuthService.shared.subscribe(email: emailTextField.text!) { result in
            switch result {
            case .success(_):
                print("success subscription")

            case .failure(_):
                print("fail subscription")

            }
        }
    }

    @objc func scrollToCollectionView() {
        let targetRect = universitiesCollectionView.convert(universitiesCollectionView.bounds, to: scrollView)
        scrollView.scrollRectToVisible(targetRect, animated: true)
    }



    

    
    private func setupDelegates() {
        featuresCollectionView.dataSource = self
        featuresCollectionView.delegate = self
        universitiesCollectionView.dataSource = self
        universitiesCollectionView.delegate = self
        reviewsCollectionView.dataSource = self
        reviewsCollectionView.delegate = self
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let page = Int((scrollView.contentOffset.x + (288 / 2)) / 288)
        pageControl.set(progress: page, animated: true)
    }
    private lazy var pageControl: CHIPageControlPuya = {
        let pc = CHIPageControlPuya()
        pc.numberOfPages = 5
        pc.radius = 4
        pc.tintColor = .lightGray
        pc.currentPageTintColor = UIColor.customGreen
        return pc
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        fetchUni()
        setupDelegates()
        setupUI()
    }
}

//MARK: - Setup UI
private extension MainPage {
    func setupUI() {
        setupViews()
        setupConstraints()
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(imageTapped))
        chatIcon.addGestureRecognizer(tapGesture)
    }
    
    func setupViews() {
        view.addSubview(scrollView)
        view.addSubview(chatIcon)

        scrollView.addSubview(contentView)
        
        contentView.addSubview(headerView)
        headerView.addSubview(logoIcon)
        headerView.addSubview(logoLabel)
        headerView.addSubview(heartIcon)
        headerView.addSubview(menuIcon)

        contentView.addSubview(welcomeContentView)
        welcomeContentView.addSubview(titleLabel)
        welcomeContentView.addSubview(descriptionLabel)
        welcomeContentView.addSubview(discoverButton)
        contentView.addSubview(backImage)
        
        contentView.addSubview(runningLineView)
        runningLineView.addSubview(runningLineLabel)

        contentView.addSubview(featureContentView)
        featureContentView.addSubview(featureLabel1)
        featureContentView.addSubview(featureLabel2)
        featureContentView.addSubview(featuresCollectionView)
        
        contentView.addSubview(universitiesView)
        universitiesView.addSubview(universitiesLabel)
        universitiesView.addSubview(universitiesDescription)
        universitiesView.addSubview(universitiesCollectionView)
        universitiesView.addSubview(pageControl)
        
        contentView.addSubview(reviewsView)
        reviewsView.addSubview(reviewsLabel)
        reviewsView.addSubview(reviewsDescription)
        reviewsView.addSubview(reviewsCollectionView)

        contentView.addSubview(footerView)
        footerView.addSubview(footerLabel)
        footerView.addSubview(footerDescriptionLabel)
        footerView.addSubview(emailTextField)
        footerView.addSubview(subscribeButton)
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
        logoIcon.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(16)
            make.centerY.equalToSuperview()
            make.width.height.equalTo(32)
        }
        logoLabel.snp.makeConstraints { make in
            make.left.equalTo(logoIcon.snp.right).offset(8)
            make.centerY.equalToSuperview()
        }
        heartIcon.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(-50)
            make.centerY.equalToSuperview()
            make.width.height.equalTo(24)
        }
        menuIcon.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(-16)
            make.centerY.equalToSuperview()
            make.width.height.equalTo(24)
        }
        
        welcomeContentView.snp.makeConstraints { make in
            make.top.equalTo(headerView.snp.bottom)
            make.left.right.equalToSuperview()
            make.height.equalTo(scrollView.snp.height).multipliedBy(0.5) //height
        }
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(32)
            make.left.equalToSuperview().inset(16)
            make.right.lessThanOrEqualToSuperview().inset(16)
        }
        descriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(16)
            make.left.equalToSuperview().inset(16)
            make.right.lessThanOrEqualToSuperview().inset(16)
        }        
        discoverButton.snp.makeConstraints { make in
            make.top.equalTo(descriptionLabel.snp.bottom).offset(32)
            make.left.equalToSuperview().offset(16)
            make.width.equalTo(200)
            make.height.equalTo(50)
        }
        chatIcon.snp.makeConstraints { make in
            make.centerY.equalToSuperview().offset(40)
            make.right.equalToSuperview().offset(-16)
            make.size.equalTo(52)
        }
        backImage.snp.makeConstraints { make in
            make.top.equalTo(discoverButton.snp.bottom).offset(40)
            make.centerX.equalToSuperview()
            make.width.equalTo(289)
            make.height.equalTo(192)
        }
        runningLineView.snp.makeConstraints { make in
            make.top.equalTo(backImage.snp.bottom).offset(30)
            make.height.equalTo(35)
            make.width.equalToSuperview()
        }
        runningLineLabel.snp.makeConstraints { make in
            make.width.equalToSuperview()
            make.centerY.equalToSuperview()
        }
        featureContentView.snp.makeConstraints { make in
            make.top.equalTo(runningLineView.snp.bottom).offset(20)
            make.left.right.equalToSuperview()
            make.height.equalTo(view.snp.height).multipliedBy(0.6) //height

        }
        featureLabel1.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(24)
            make.centerX.equalToSuperview()
        }
        featureLabel2.snp.makeConstraints { make in
            make.top.equalTo(featureLabel1.snp.bottom).offset(8)
            make.leading.trailing.equalToSuperview().offset(16).inset(16)
        }
        featuresCollectionView.snp.makeConstraints { make in
            make.top.equalTo(featureLabel2.snp.bottom).offset(16)
            make.leading.trailing.equalToSuperview().offset(16).inset(16)
            make.bottom.equalToSuperview().inset(30)
        }
        universitiesView.snp.makeConstraints { make in
            make.top.equalTo(featuresCollectionView.snp.bottom).offset(30)
            make.leading.trailing.equalToSuperview().offset(16).inset(16)
            make.height.equalTo(view.snp.height).multipliedBy(0.7)
        }
        universitiesLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(24)
            make.centerX.equalToSuperview()
        }
        universitiesDescription.snp.makeConstraints { make in
            make.top.equalTo(universitiesLabel.snp.bottom).offset(8)
            make.centerX.equalToSuperview()
        }
        universitiesCollectionView.snp.makeConstraints { make in
            make.top.equalTo(universitiesDescription.snp.bottom).offset(16)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalToSuperview().inset(30)
        }
        pageControl.snp.makeConstraints { make in
            make.top.equalTo(universitiesCollectionView.snp.bottom).offset(10)
            make.centerX.equalToSuperview()
            make.height.equalTo(20)
        }
        reviewsView.snp.makeConstraints { make in
            make.top.equalTo(pageControl.snp.bottom).offset(30)

            make.leading.trailing.equalToSuperview()
            make.height.equalTo(view.snp.height).multipliedBy(0.7)
        }
        reviewsLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(24)
            make.leading.trailing.equalToSuperview().offset(16).inset(16)
            make.centerX.equalToSuperview()
        }
        reviewsDescription.snp.makeConstraints { make in
            make.top.equalTo(reviewsLabel.snp.bottom).offset(8)
            make.leading.trailing.equalToSuperview().offset(16).inset(16)
            make.centerX.equalToSuperview()
        }
        reviewsCollectionView.snp.makeConstraints { make in
            make.top.equalTo(reviewsDescription.snp.bottom).offset(16)
            make.leading.trailing.equalToSuperview().offset(16).inset(16)
            make.bottom.equalToSuperview().inset(30)
        }
        footerView.snp.makeConstraints { make in
            make.top.equalTo(reviewsView.snp.bottom).offset(30)
            make.leading.trailing.equalToSuperview().offset(16).inset(16)
            make.height.equalTo(view.snp.height).multipliedBy(0.4)
        }
        footerLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(60)
        }
        footerDescriptionLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.leading.trailing.equalToSuperview().offset(16).inset(16)
            make.top.equalTo(footerLabel.snp.bottom).offset(20)
        }
        emailTextField.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().offset(16).inset(16)
            make.top.equalTo(footerDescriptionLabel.snp.bottom).offset(60)
            make.height.equalTo(48)
        }
        subscribeButton.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().offset(16).inset(16)
            make.top.equalTo(emailTextField.snp.bottom).offset(12)
            make.height.equalTo(48)
        }
        let lastSubview = [headerView, welcomeContentView, featureContentView, universitiesView, reviewsView, footerView].last!
        lastSubview.snp.makeConstraints { make in
            make.bottom.equalToSuperview().inset(tabBarController?.tabBar.frame.height ?? 0)
        }
    }
}

//MARK: - Collection View delegate methods
extension MainPage: UICollectionViewDelegate, UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == universitiesCollectionView {
            return universitiesResults.count // Use universitiesResults array for the number of items
        }
        return featuresTitles.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch collectionView {
        case featuresCollectionView:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Cells.FeatureCollectionViewCell, for: indexPath) as! FeatureCollectionViewCell
            cell.configure(title: featuresTitles[indexPath.item], description: featuresDescription[indexPath.item])
            return cell

        case universitiesCollectionView:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Cells.UniversitiesCollectionViewCell, for: indexPath) as! UniversitiesCollectionViewCell
            let university = universitiesResults[indexPath.item]
            cell.configure(
                by: university.id,
                name: university.name,
                rate: university.rating,
                description: university.description,
                highRate: "High employment rate",
                logoUrl: university.logoUrl,
                isFavorite: favoriteUniversities.contains(university.id)
            )

            cell.onLikeTapped = { [weak self] id in
                guard let self else { return }
                print("Тап по id:", id)
                print("Содержимое избранных:", favoriteUniversities)
                if favoriteUniversities.contains(id) {
                    // Удаляем из избранных
                    favoriteUniversities.remove(id)
                    UniversityService().removeFromFavorites(universityId: id) { result in
                        switch result {
                        case .success:
                            print("✅ Университет удалён из избранного")
                        case .failure(let error):
                            print("❌ Ошибка при удалении: \(error)")
                        }
                    }
                } else {
                    // Добавляем в избранные
                    favoriteUniversities.insert(id)
                    let userId = UserManager.shared.currentUser?.id ?? 0
                    UniversityService().addToFavorites(universityId: id, userId: userId) { result in
                        switch result {
                        case .success:
                            print("✅ Университет добавлен в избранное")
                        case .failure(let error):
                            print("❌ Ошибка при добавлении: \(error)")
                        }
                    }
                }

                self.universitiesCollectionView.reloadItems(at: [indexPath])
            }
            return cell

            
        case reviewsCollectionView:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Cells.reviewsCollectionViewCell, for: indexPath) as! ReviewCollectionViewCell
            cell.configure(by: userNames[indexPath.item], major: workPositions[indexPath.item], description: reviews[indexPath.item])
            return cell

        default:
            fatalError("Unexpected collectionView")
        }
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == universitiesCollectionView {
            let selectedUniversity = universitiesResults[indexPath.item]
            
            // Assuming you have a UniversityDetailViewController to show details of the selected university
            let universityDetailVC = UniversityDetailViewController()
            universityDetailVC.university = selectedUniversity
            
            // Push to the detail view controller
            navigationController?.pushViewController(universityDetailVC, animated: true)
        }
    }
}
//MARK: - Collection View Flow Layout
extension MainPage: UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        switch collectionView {
        case featuresCollectionView:
            return CGSize(width: 245, height: 270)
        case universitiesCollectionView:
            return CGSize(width: 288, height: 465)
        case reviewsCollectionView:
            return CGSize(width: 288, height: 331)
        default:
            return CGSize(width: 245, height: 270)
        }
    }
}

//MARK: - Setup UI
private extension MainPage {
    private func fetchUni() {
        universityService.fetchTopUniversities(limit: 5) { result in
            switch result {
            case .success(let universities):
                self.universitiesResults = universities
                DispatchQueue.main.async { // Ensure the UI is updated on the main thread
                    self.universitiesCollectionView.reloadData() // Reload the collection view
                }
            case .failure(let error):
                print("Error fetching universities: \(error)")
            }
        }
    }
    @objc private func imageTapped() {
        let detailVC = ChatViewController()
        navigationController?.pushViewController(detailVC, animated: true)

    }

}

