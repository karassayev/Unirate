//
//  UniversitiesViewController.swift
//  test1
//
//  Created by Dias Karassayev on 3/12/25.
//

import UIKit
import SnapKit
import M13Checkbox
import MARKRangeSlider
import LTHRadioButton

class UniversitiesViewController: UIViewController {
    private let headerView = HeaderView()
    private let dropdownOptions = ["Almaty", "Astana"] // ← your dynamic list
    
    let minPriceField = UITextField()
    let maxPriceField = UITextField()
    let dashLabel = UILabel()
    var universitiesResults: [University] = []

//    let slider = MARKRangeSlider()


    private lazy var universitiesView: UIView = {
        let view = UIView()
        return view
    }()
    
    private lazy var filterLabel: UILabel = {
         let label = UILabel()
         label.text = "Filters"
         label.textColor = .black
        label.font = UIFont(name: "Poppins-Bold", size: 20)
         label.textAlignment = .left
         return label
     }()
    
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
    
    private lazy var filterView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.customGreen2
        view.layer.cornerRadius = 20
        return view
    }()
    private lazy var searchField = UITextField.createTextField(placeholder: "Search for University")
    private lazy var searchButton: UIImageView = {
         let imageView = UIImageView()
        imageView.image = UIImage(named: "magnifier")
         imageView.tintColor = .black
        imageView.isUserInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(imageTapped))
        imageView.addGestureRecognizer(tapGesture)
         return imageView
     }()
    
    @objc func imageTapped() {
        print("Image tapped!")
//        guard let query = searchField.text, !query.isEmpty else {
//            print("Search field is empty")
//            return
//        }
        UniversityService().search(searchField: searchField.text) { result in
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

    private lazy var markImage: UIImageView = {
         let imageView = UIImageView()
        imageView.image = UIImage(named: "mark")
         imageView.tintColor = .black
         return imageView
     }()
    
    private lazy var titleLabel: UILabel = {
         let label = UILabel()
         label.text = "Universities"
         label.textColor = .black
         label.font = UIFont(name: "Poppins-Bold", size: 24)
         label.textAlignment = .center
         label.numberOfLines = 0
         return label
     }()
    private lazy var dropdownButton: UIButton = {
        let button = UIButton(configuration: .filled(), primaryAction: nil)

        var config = UIButton.Configuration.filled()
        config.image = UIImage(systemName: "chevron.down")
        config.baseBackgroundColor = .white
        config.baseForegroundColor = .black
        config.cornerStyle = .medium

        config.imagePlacement = .trailing
        config.imagePadding = 6
        
        if let customFont = UIFont(name: "Poppins-Regular", size: 16) {
            config.attributedTitle = AttributedString("Search for city", attributes: AttributeContainer([.font: customFont]))
        }

        button.configuration = config
        button.showsMenuAsPrimaryAction = true
        
        let actions = dropdownOptions.map { option in
            UIAction(title: option) { _ in
                print("Selected \(option)")
            }
        }
        
        let menu = UIMenu(title: "", options: .displayInline, children: actions)
        button.menu = menu
        button.showsMenuAsPrimaryAction = true // Show menu on tap
        
        return button
    }()
    
    private lazy var checkDorm: M13Checkbox = {
        let check = createCheckbox()
        return check
    }()
    
    private lazy var checkMil: M13Checkbox = {
        let check = createCheckbox()
        return check
    }()
    private lazy var dormLabel: UILabel = {
        let label = createCheckboxTitle(title: "Dormitory")
         return label
     }()
    private lazy var milLabel: UILabel = {
        let label = createCheckboxTitle(title: "Military")
         return label
     }()
    
    private lazy var dollarImage: UIImageView = {
         let imageView = UIImageView()
        imageView.image = UIImage(named: "dollar")
         imageView.tintColor = .black
         return imageView
     }()
    private lazy var priceLabel: UILabel = {
        let label = createTitle(title: "Price")
         return label
     }()
    private lazy var sortImage: UIImageView = {
         let imageView = UIImageView()
        imageView.image = UIImage(named: "sort")
         imageView.tintColor = .black
         return imageView
     }()
    private lazy var sortLabel: UILabel = {
        let label = createTitle(title: "Sort by rating")
         return label
     }()
    private func createTitle(title: String) ->  UILabel {
        let label = UILabel()
        label.text = title
        label.textColor = .black
        label.font = UIFont(name: "Poppins-Bold", size: 16)
        label.textAlignment = .left
        label.numberOfLines = 0
        return label
    }
    private lazy var applyButton: UIButton = {
        let button = UIButton()
        button.setTitle("Apply Filters", for: .normal)
        button.backgroundColor = UIColor.customGreen
        button.layer.cornerRadius = 20
        button.titleLabel?.font = UIFont(name: "Poppins-Bold", size: 16)
        button.configuration?.cornerStyle = .capsule
        button.addTarget(self, action: #selector(subscribeButtonTapped), for: .touchUpInside)
        return button
    }()
    @objc func subscribeButtonTapped() {
        
        UniversityService().search(maxTuition: Int(slider.value), hasMilitaryDepartment: checkMil.isEnabled, hasDormitory: checkDorm.isEnabled) { result in
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

    private lazy var lowRadioButton: LTHRadioButton = {
        let button = createRadioButton()
        button.tag = 1
        let tap = UITapGestureRecognizer(target: self, action: #selector(radioButtonTapped(_:)))
        button.addGestureRecognizer(tap)
        return button
    }()
    private lazy var highRadioButton: LTHRadioButton = {
        let button = createRadioButton()
        button.tag = 2
        let tap = UITapGestureRecognizer(target: self, action: #selector(radioButtonTapped(_:)))
        button.addGestureRecognizer(tap)
        return button
    }()
    private lazy var lowToHighLabel: UILabel = {
        let label = createCheckboxTitle(title: "Lowest to Highest")
        return label
    }()
    private lazy var highToLowLabel: UILabel = {
        let label = createCheckboxTitle(title: "Highest to Lowest")
        return label
    }()
    
    private lazy var slider: UISlider = {
        let slider = UISlider()
        slider.minimumValue = 500000// Minimum value
        slider.maximumValue = 3000000 // Maximum value
        slider.value = 500000 // Initial value
        slider.isContinuous = true // Determines whether to trigger action continuously
        slider.tintColor = UIColor.customGreen // Set the color of the slider track
        slider.addTarget(self, action: #selector(sliderValueChanged(_:)), for: .valueChanged)
        return slider
    }()
    
    
    @objc func sliderValueChanged(_ sender: UISlider) {
        let value = Int(sender.value)
        maxPriceField.text = "₸ \(value)"
    }
//    @objc func sliderValueChanged() {
//        print("Slider range: \(slider.leftValue) - \(slider.rightValue)")
//    }
    private lazy var universitiesCollectionView: UICollectionView = {
        let collectionViewLayout = UICollectionViewFlowLayout()
        collectionViewLayout.scrollDirection = .horizontal
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: collectionViewLayout)
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.register(UniversitiesCollectionViewCell.self, forCellWithReuseIdentifier: Cells.UniversitiesCollectionViewCell)
        return collectionView
    }()
    private lazy var universitiesLabel = UILabel.createLabel(size: 14, color: .black, font: "Poppins-Regular", text: "Most Popular")
    private lazy var universitiesDescription = UILabel.createLabel(size: 24, color: .black, font: "Poppins-Bold", text: "University lists")

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        universitiesCollectionView.dataSource = self
        universitiesCollectionView.delegate = self

        
        setupUI()
    }
}
extension UniversitiesViewController {
    func setupUI() {
        setupViews()
        setupConstraints()
        setupTextField(minPriceField, text: "₸ 500 000")
        setupTextField(maxPriceField, text: "₸ 3 000 000")
        setupDashLabel()
//        setupRangeSlider()
    }
    func setupViews() {
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        contentView.addSubview(headerView)
        
        contentView.addSubview(firstView)
        firstView.addSubview(titleLabel)
        firstView.addSubview(searchField)
        firstView.addSubview(searchButton)
        
        contentView.addSubview(filterView)
        filterView.addSubview(filterLabel)
        filterView.addSubview(dropdownButton)
        filterView.addSubview(markImage)
        filterView.addSubview(checkDorm)
        filterView.addSubview(checkMil)
        filterView.addSubview(dormLabel)
        filterView.addSubview(milLabel)
        filterView.addSubview(dollarImage)
        filterView.addSubview(priceLabel)
        filterView.addSubview(sortImage)
        filterView.addSubview(sortLabel)
        filterView.addSubview(lowRadioButton)
        filterView.addSubview(lowToHighLabel)
        filterView.addSubview(highRadioButton)
        filterView.addSubview(highToLowLabel)
        filterView.addSubview(slider)
        filterView.addSubview(minPriceField)
        filterView.addSubview(maxPriceField)
        filterView.addSubview(dashLabel)
        filterView.addSubview(applyButton)

        contentView.addSubview(universitiesView)
        universitiesView.addSubview(universitiesLabel)
        universitiesView.addSubview(universitiesDescription)
        universitiesView.addSubview(universitiesCollectionView)
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
            make.leading.trailing.equalToSuperview().offset(16).inset(16)
            make.top.equalTo(headerView.snp.bottom).offset(40)
            make.height.equalToSuperview().multipliedBy(0.6)
        }
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(headerView.snp.bottom).offset(30)
            make.centerX.equalToSuperview()
        }
        searchField.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.top.equalTo(titleLabel.snp.bottom).offset(30)
            make.width.equalToSuperview().multipliedBy(0.75)
            make.height.equalTo(48)
        }
        searchButton.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(30)
            make.left.equalTo(searchField.snp.right).offset(15)
            make.width.equalTo(56)
            make.height.equalTo(48)
        }
        filterView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().offset(16).inset(16)
            make.top.equalTo(searchButton.snp.bottom).offset(48)
            make.height.equalToSuperview().multipliedBy(0.4)
        }
        filterLabel.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().offset(16).inset(16)
            make.top.equalToSuperview().offset(24)
        }
        markImage.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(16)
            make.top.equalTo(filterLabel.snp.bottom).offset(30)
            make.size.equalTo(32)
        }
        dropdownButton.snp.makeConstraints { make in
            make.top.equalTo(filterLabel.snp.bottom).offset(24)
            make.left.equalTo(markImage.snp.right).offset(8)
            make.width.equalToSuperview().multipliedBy(0.6)
            make.height.equalTo(45)
        }
        checkDorm.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(16)
            make.top.equalTo(dropdownButton.snp.bottom).offset(24)
            make.size.equalTo(28)
        }
        checkMil.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(16)
            make.top.equalTo(checkDorm.snp.bottom).offset(8)
            make.size.equalTo(28)
        }
        dormLabel.snp.makeConstraints { make in
            make.left.equalTo(checkDorm.snp.right).offset(8)
            make.centerY.equalTo(checkDorm.snp.centerY)
        }
        milLabel.snp.makeConstraints { make in
            make.left.equalTo(checkDorm.snp.right).offset(8)
            make.centerY.equalTo(checkMil.snp.centerY)
        }
        dollarImage.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(16)
            make.top.equalTo(checkMil.snp.bottom).offset(30)
            make.size.equalTo(30)
        }
        priceLabel.snp.makeConstraints { make in
            make.left.equalTo(dollarImage.snp.right).offset(8)
            make.centerY.equalTo(dollarImage.snp.centerY)
        }
        minPriceField.snp.makeConstraints { make in
            make.top.equalTo(priceLabel.snp.bottom).offset(30)
            make.left.equalToSuperview().offset(16)
            make.width.equalTo(100)
            make.height.equalTo(48)
        }

        dashLabel.snp.makeConstraints { make in
            make.centerY.equalTo(minPriceField)
            make.left.equalTo(minPriceField.snp.right).offset(8)
            make.width.equalTo(20)
        }

        maxPriceField.snp.makeConstraints { make in
            make.centerY.equalTo(minPriceField)
            make.left.equalTo(dashLabel.snp.right).offset(8)
            make.width.equalTo(100)
            make.height.equalTo(48)
        }
        slider.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().offset(16).inset(16)
            make.top.equalTo(maxPriceField.snp.bottom).offset(10)
            make.height.equalTo(30)
        }
        sortImage.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(16)
            make.top.equalTo(slider.snp.bottom).offset(10)
            make.size.equalTo(30)
        }
        sortLabel.snp.makeConstraints { make in
            make.left.equalTo(sortImage.snp.right).offset(8)
            make.centerY.equalTo(sortImage.snp.centerY)
        }
        lowRadioButton.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(16)
            make.top.equalTo(sortImage.snp.bottom).offset(30)
            make.size.equalTo(24)
        }
        lowToHighLabel.snp.makeConstraints { make in
            make.left.equalTo(lowRadioButton.snp.right).offset(8)
            make.centerY.equalTo(lowRadioButton.snp.centerY)
        }
        highRadioButton.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(16)
            make.top.equalTo(lowToHighLabel.snp.bottom).offset(8)
            make.size.equalTo(24)
        }
        highToLowLabel.snp.makeConstraints { make in
            make.left.equalTo(highRadioButton.snp.right).offset(8)
            make.centerY.equalTo(highRadioButton.snp.centerY)
        }

        applyButton.snp.makeConstraints { make in
            make.top.equalTo(highToLowLabel.snp.bottom).offset(30)
            make.trailing.equalToSuperview()
            make.height.equalTo(48)
            make.width.equalTo(view.snp.width).multipliedBy(0.5)
        }
        
        
        universitiesView.snp.makeConstraints { make in
            make.top.equalTo(filterView.snp.bottom).offset(60)
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
        let lastSubview = [headerView, firstView, filterView, universitiesView].last!
        lastSubview.snp.makeConstraints { make in
            make.bottom.equalToSuperview().inset(tabBarController?.tabBar.frame.height ?? 0)
        }
    }
}
//MARK: - Set Up CheckBoxes
extension UniversitiesViewController {
    
    private func createRadioButton() -> LTHRadioButton {
        let button = LTHRadioButton(selectedColor: UIColor.customGreen)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(radioButtonTapped(_:)))
        button.addGestureRecognizer(tap)
        
        return button
    }

    @objc func radioButtonTapped(_ gesture: UITapGestureRecognizer) {
        guard let sender = gesture.view as? LTHRadioButton else { return }
        switch sender.tag {
        case 1:
            print("Low Radio Button was tapped")
        case 2:
            print("High Radio Button was tapped")
        default:
            print("Unknown Button tapped")
        }
        lowRadioButton.deselect(animated: false)
        highRadioButton.deselect(animated: false)
        
        sender.select(animated: false)
    }


    private func createCheckbox() ->  M13Checkbox {
        let checkbox = M13Checkbox()
        checkbox.stateChangeAnimation = .spiral
        checkbox.boxType = .square
        checkbox.tintColor = UIColor.customGreen
        checkbox.secondaryTintColor = UIColor.customGreen
        checkbox.backgroundColor = .white
        checkbox.cornerRadius = 0
        checkbox.setCheckState(.unchecked, animated: false)
        checkbox.addTarget(self, action: #selector(checkboxTapped(_:)), for: .valueChanged)
        return checkbox
    }
    
    private func createCheckboxTitle(title: String) ->  UILabel {
        let label = UILabel()
        label.text = title
        label.textColor = .black
        label.font = UIFont(name: "Poppins-Regular", size: 16)
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }

    @objc func checkboxTapped(_ sender: M13Checkbox) {
        if sender.checkState == .checked {
            sender.tintColor = .white
            sender.secondaryTintColor = .white
            sender.backgroundColor = UIColor.customGreen
        } else {
            sender.tintColor = .green
            sender.secondaryTintColor = UIColor.customGreen
            sender.backgroundColor = .white
        }
    }
    private func setupTextField(_ textField: UITextField, text: String) {
        textField.text = text
        textField.textAlignment = .center
        textField.backgroundColor = .white
        textField.layer.cornerRadius = 20
        textField.layer.borderWidth = 1
        textField.layer.borderColor = UIColor.lightGray.cgColor
//        textField.isUserInteractionEnabled = false
        textField.font = UIFont(name: "Poppins-Regular", size: 16)
    }
    private func setupDashLabel() {
        dashLabel.text = "-"
        dashLabel.textColor = .gray
        dashLabel.textAlignment = .center
    }
//    func setupRangeSlider() {
//        slider.setMinValue(0, maxValue: 100)
//        slider.setLeftValue(20, rightValue: 80)
//        
//        slider.tintColor = .lightGray
////        slider.handleColor = UIColor.systemBlue
////        slider.lineHeight = 4
//
//        
//        slider.addTarget(self, action: #selector(sliderValueChanged), for: .valueChanged)
//    }
}
//MARK: - Collection View delegate methods
extension UniversitiesViewController: UICollectionViewDelegate, UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return universitiesResults.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Cells.UniversitiesCollectionViewCell, for: indexPath) as! UniversitiesCollectionViewCell
            let university = universitiesResults[indexPath.item]
            cell.configure(
                by: university.id,
                name: university.name,
                rate: university.rating,
                description: university.description,
                highRate: "High employment rate",
                logoUrl: university.logoUrl,
                isFavorite: false
            )


            return cell

    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == universitiesCollectionView {
            let selectedUniversity = universitiesResults[indexPath.item]
            
            // Assuming you have a UniversityDetailViewController to show details of the selected university
            let universityDetailVC = UniversityDetailViewController()
            universityDetailVC.university = selectedUniversity
            
            navigationController?.pushViewController(universityDetailVC, animated: true)
        }
    }
}
//MARK: - Collection View Flow Layout
extension UniversitiesViewController: UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
            return CGSize(width: 288, height: 465)
    }
}
