//
//  FinanceCalculatorVC.swift
//  test2
//
//  Created by Dias Karassayev on 3/25/25.
//
//
import UIKit
import SnapKit


class FavouritesViewController: UIViewController{
    private let headerView = HeaderView()
    
    var selectedUniversities: [(university: String, faculty: String)] = []

    private let data: [String] = [
        "Education costs","Dormitory cost", "Military edu cost", "food and additional things", "TOTAL"
    ]
    
    let userNames = ["Aruzhan T.", "Dias K.", "Miras A.", "Aliya N.", "Sanzhar B."]

    let workPositions = ["iOS Developer", "QA Engineer", "Backend Developer", "UI/UX Designer", "Project Manager"]

    let reviews = [
        "Very user-friendly app with a clean interface. It’s easy to navigate even for first-time users.",
        "Works fast and hasn’t crashed once — great job! Performance is smooth even on older devices.",
        "Please add dark mode and filters to the list view. That would make using it at night much easier.",
        "Sometimes data takes a while to load, but overall it’s great. I hope future updates improve speed.",
        "I use it daily — it’s an essential tool for students! It really helps me stay organized and on track."
    ]

    var universitiesResults: [University] = []

    let universities: [String: [String: Any]] = [
        "NU": [
            "faculties": ["Engineering", "Business School", "Medicine"],
            "city": "Astana",
            "foodCost": 100,
            "tuitionFees": [
                "Engineering": 12000,
                "Business School": 15000,
                "Medicine": 18000
            ]
        ],
        "KBTU": [
            "faculties": ["IT", "Oil and Gas", "Finance"],
            "city": "Almaty",
            "foodCost": 80,
            "tuitionFees": [
                "IT": 10000,
                "Oil and Gas": 11000,
                "Finance": 9000
            ]
        ],
        "KazNU": [
            "faculties": ["Law", "Philosophy", "Biology"],
            "city": "Almaty",
            "foodCost": 70,
            "tuitionFees": [
                "Law": 7000,
                "Philosophy": 6000,
                "Biology": 7500
            ]
        ]
    ]

    private let dropdownOptions = ["Student", "Teacher"]

    
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.showsVerticalScrollIndicator = false
        return scrollView
    }()
    
    private lazy var contentView: UIView = {
        let view = UIView()
        return view
    }()
    private lazy var titleLabel = UILabel.createLabel(size: 24, color: .black, font: "Poppins-Bold", text: "Favorites")
    private lazy var descriptionLabel = UILabel.createLabel(size: 24, color: .black, font: "Poppins-Bold", text: "University lists")
    private lazy var filterLabel = UILabel.createLabel(size: 20, color: .black, font: "Poppins-Bold", text: "Filters")
    private lazy var selectUniLabel = UILabel.createLabel(size: 14, color: .black, font: "Poppins-Regular", text: "Select universities for compare")
    private lazy var selectProgramLabel = UILabel.createLabel(size: 14, color: .black, font: "Poppins-Regular", text: "Select faculties for comparison")
    private lazy var clearLabel = UIButton.createButton(title: "Apply Filters", color: UIColor.customGreen, textColor: .white){ [self] in
        clearSelection()
    }

    @objc func clearSelection() {
        print(4444)
            selectedUniversities.removeAll()
            favouritesCollectionView.reloadData()
        
    }


    private lazy var uniLabel = UILabel.createLabel(size: 16, color: .black, font: "Poppins-Regular", text: "Universities")

    private lazy var applyButton = UIButton.createButton(title: "Apply Filters", color: UIColor.customGreen, textColor: .white) { [self] in
        guard let uniTitle = uniDropDown.titleLabel?.text,
              let facultyTitle = programDropDown.titleLabel?.text,
              uniTitle != "Select University",
              facultyTitle != "Select Faculty"
        else { return }

        selectedUniversities.append((university: uniTitle, faculty: facultyTitle))
        favouritesCollectionView.reloadData()
    }
    
    private lazy var programLabel = UILabel.createLabel(size: 20, color: .black, font: "Poppins-Bold", text: "Program selection")
    private lazy var showDiffLabel = UILabel.createLabel(size: 14, color: .black, font: "Poppins-Regular", text: "Show only differences")
    
    private lazy var penImage: UIImageView = {
         let imageView = UIImageView()
         imageView.image = UIImage(named: "bucket")
         imageView.contentMode = .scaleAspectFill
         imageView.clipsToBounds = true
         return imageView
     }()
    
    private lazy var switchSHow: UISwitch = {
        let switchControl = UISwitch()
        switchControl.onTintColor = UIColor.customGreen   // Color when ON
        switchControl.tintColor = .gray     // Color when OFF
        switchControl.thumbTintColor = .white // Color of the thumb
        switchControl.translatesAutoresizingMaskIntoConstraints = false
        
        // Add target for switch value change
        switchControl.addTarget(self, action: #selector(switchChanged(_:)), for: .valueChanged)
        
        return switchControl
    }()
    
    @objc func switchChanged(_ sender: UISwitch) {
//        print("Switch is now \(sender.isOn ? "ON" : "OFF")")
    }
    
    private lazy var universitiesCollectionView: UICollectionView = {
        let collectionViewLayout = UICollectionViewFlowLayout()
        collectionViewLayout.scrollDirection = .horizontal
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: collectionViewLayout)
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.register(UniversitiesCollectionViewCell.self, forCellWithReuseIdentifier: Cells.UniversitiesCollectionViewCell)
        return collectionView
    }()
    
    private lazy var favouritesCollectionView: UICollectionView = {
        let collectionViewLayout = UICollectionViewFlowLayout()
        collectionViewLayout.scrollDirection = .horizontal
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: collectionViewLayout)
        collectionView.showsHorizontalScrollIndicator = true
        collectionView.backgroundColor = UIColor.customGrayBackground
        collectionView.register(FavouritesCollectionViewCell.self, forCellWithReuseIdentifier: Cells.favouritesCollectionViewCell)
        return collectionView
    }()
    
    private lazy var uniDropDown: UIButton = {
        let button = UIButton.createDropDown(data: Array(universities.keys), title: "Select University")
        
        let actions = Array(universities.keys).map { uniName in
            UIAction(title: uniName) { _ in
                self.updateDropDowns(for: uniName)

                // Обновить текст на кнопке
                button.updateTitle(to: uniName)
            }
        }
        button.menu = UIMenu(title: "", options: .displayInline, children: actions)
        return button
    }()

    private lazy var programDropDown = UIButton.createDropDown(data: [], title: "Select Faculty")
   
    private lazy var filterView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.customGreen2
        view.layer.cornerRadius = 20
        return view
    }()
    private lazy var secondView: UIView = {
        let view = UIView()
        view.isUserInteractionEnabled = true
        return view
    }()

    private lazy var compareView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 20
        view.backgroundColor = UIColor.customGrayBackground
        return view
    }()
    
    private func updateDropDowns(for university: String) {
        guard let data = universities[university] else { return }

        // Обновление faculties (программа)
        if let faculties = data["faculties"] as? [String] {
            programDropDown.updateMenu(with: faculties) { selected in
                print("Selected program: \(selected)")
            }
            programDropDown.updateTitle(to: "Select Faculty")
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        secondView.isUserInteractionEnabled = true
        clearLabel.layer.zPosition = 10 // или clearButton
        scrollView.delaysContentTouches = false
        scrollView.canCancelContentTouches = true

        setUpDelegates()
        setupUI()
        fetchUni()
    }
}
extension FavouritesViewController {
    func setupUI() {
        setupViews()
        setupConstraints()
    }
    func setUpDelegates(){
        universitiesCollectionView.dataSource = self
        universitiesCollectionView.delegate = self
        favouritesCollectionView.dataSource = self
        favouritesCollectionView.delegate = self
    }
    func setupViews() {
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)

        contentView.addSubview(headerView)
        contentView.addSubview(clearLabel)

        
        contentView.addSubview(titleLabel)
        contentView.addSubview(descriptionLabel)
        contentView.addSubview(universitiesCollectionView)
        contentView.addSubview(filterView)

        filterView.addSubview(filterLabel)
        filterView.addSubview(selectUniLabel)
        filterView.addSubview(uniDropDown)
        filterView.addSubview(selectProgramLabel)
        filterView.addSubview(programDropDown)
        filterView.addSubview(applyButton)
        
        contentView.addSubview(secondView)
        secondView.addSubview(switchSHow)
        secondView.addSubview(programLabel)
        secondView.addSubview(showDiffLabel)
//        secondView.addSubview(clearLabel)
        secondView.addSubview(penImage)

        contentView.addSubview(compareView)
        compareView.addSubview(uniLabel)
        compareView.addSubview(favouritesCollectionView)

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
     titleLabel.snp.makeConstraints { make in
         make.top.equalTo(headerView.snp.bottom).offset(30)
         make.leading.trailing.equalToSuperview().offset(16).inset(16)
     }
     descriptionLabel.snp.makeConstraints { make in
         make.top.equalTo(titleLabel.snp.bottom).offset(30)
         make.leading.trailing.equalToSuperview().offset(16).inset(16)
     }
     universitiesCollectionView.snp.makeConstraints { make in
         make.top.equalTo(descriptionLabel.snp.bottom).offset(16)
         make.leading.trailing.equalToSuperview().offset(16).inset(16)
         make.height.equalTo(view.snp.height).multipliedBy(0.6)
     }
     filterView.snp.makeConstraints { make in
         make.top.equalTo(universitiesCollectionView.snp.bottom).offset(30)
         make.leading.trailing.equalToSuperview().offset(16).inset(16)
         make.height.equalTo(view.snp.height).multipliedBy(0.4)
     }
     filterLabel.snp.makeConstraints { make in
         make.top.equalToSuperview().offset(24)
         make.leading.trailing.equalToSuperview().offset(16).inset(16)
     }
     selectUniLabel.snp.makeConstraints { make in
         make.top.equalTo(filterLabel.snp.bottom).offset(24)
         make.leading.equalToSuperview().offset(16)
     }
     uniDropDown.snp.makeConstraints { make in
         make.top.equalTo(selectUniLabel.snp.bottom).offset(10)
         make.leading.trailing.equalToSuperview().offset(16).inset(16)
         make.height.equalTo(48)
     }
     selectProgramLabel.snp.makeConstraints { make in
         make.top.equalTo(uniDropDown.snp.bottom).offset(24)
         make.leading.equalToSuperview().offset(16)
     }
     programDropDown.snp.makeConstraints { make in
         make.top.equalTo(selectProgramLabel.snp.bottom).offset(10)
         make.leading.trailing.equalToSuperview().offset(16).inset(16)
         make.height.equalTo(48)
     }
     applyButton.snp.makeConstraints { make in
         make.top.equalTo(programDropDown.snp.bottom).offset(24)
         make.leading.trailing.equalToSuperview().offset(16).inset(16)
         make.height.equalTo(48)
     }
     secondView.snp.makeConstraints { make in
         make.top.equalTo(filterView.snp.bottom).offset(30)
         make.leading.trailing.equalToSuperview().offset(16).inset(16)
         make.height.equalTo(view.snp.height).multipliedBy(0.12)
     }
     programLabel.snp.makeConstraints { make in
         make.top.equalToSuperview().offset(24)
         make.leading.trailing.equalToSuperview().offset(24).inset(24)
     }
     switchSHow.snp.makeConstraints { make in
         make.top.equalTo(programLabel.snp.bottom).offset(16)
         make.leading.equalToSuperview().offset(24)
         make.width.equalTo(50)
         make.height.equalTo(28)
     }
     showDiffLabel.snp.makeConstraints { make in
         make.centerY.equalTo(switchSHow.snp.centerY)
         make.left.equalTo(switchSHow.snp.right).offset(8)
     }
     clearLabel.snp.makeConstraints { make in
         make.top.equalTo(showDiffLabel.snp.bottom).offset(16)
         make.trailing.equalToSuperview().inset(40)
         make .height.equalTo(40)
     }

        penImage.snp.makeConstraints { make in
            make.centerY.equalTo(clearLabel.snp.centerY)
            make.left.equalTo(clearLabel.snp.right).offset(8)
        }
        compareView.snp.makeConstraints { make in
            make.top.equalTo(clearLabel.snp.bottom).offset(30)
            make.leading.trailing.equalToSuperview().offset(16).inset(16)
            make.height.equalTo(view.snp.height).multipliedBy(0.9)
        }
        uniLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(16)
            make.leading.equalToSuperview().offset(24)
        }
        favouritesCollectionView.snp.makeConstraints { make in
            make.top.equalTo(uniLabel.snp.bottom)
            make.leading.trailing.equalToSuperview().offset(16).inset(16)
            make.height.equalTo(view.snp.height).multipliedBy(0.7)

        }
        let lastSubview = [headerView, titleLabel, descriptionLabel, universitiesCollectionView, filterView, secondView, compareView].last!

        lastSubview.snp.makeConstraints { make in
            make.bottom.equalToSuperview().inset(tabBarController?.tabBar.frame.height ?? 0)
        }
        }
    }

//MARK: - Collection View delegate methods
extension FavouritesViewController: UICollectionViewDelegate, UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if collectionView == universitiesCollectionView {
            return universitiesResults.count // Use universitiesResults array for the number of items
        }
        else{
            return selectedUniversities.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
            switch collectionView {
            case universitiesCollectionView:
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Cells.UniversitiesCollectionViewCell, for: indexPath) as!    UniversitiesCollectionViewCell
                let university = universitiesResults[indexPath.item]
                cell.configure(
                    by: university.id,
                    name: university.name,
                    rate: university.rating,
                    description: university.description,
                    highRate: "High employment rate",
                    logoUrl: university.logoUrl,
                    isFavorite: true
            )
            return cell
                
            case favouritesCollectionView:
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Cells.favouritesCollectionViewCell, for: indexPath) as! FavouritesCollectionViewCell

                                
//                cell.configure(specialty: "SDU")
                let pair = selectedUniversities[indexPath.item]
                cell.configure(specialty: "\(pair.university) – \(pair.faculty)")

                return cell
                
            default:
                fatalError("Unexpected collectionView")
            }
            
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        if collectionView == universitiesCollectionView {
//            let selectedUniversity = uniks[indexPath.item]
//            
//            // Assuming you have a UniversityDetailViewController to show details of the selected university
//            let universityDetailVC = UniversityDetailViewController()
//            universityDetailVC.university = selectedUniversity
//            
//            // Push to the detail view controller
//            navigationController?.pushViewController(universityDetailVC, animated: true)
//        }
    }
}
//MARK: - Collection View Flow Layout
extension FavouritesViewController: UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
            return CGSize(width: 288, height: 485)

    }
}

private extension FavouritesViewController {
    private func fetchUni() {
        UniversityService().fetchTopUniversities(limit: 5) { result in
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
}

