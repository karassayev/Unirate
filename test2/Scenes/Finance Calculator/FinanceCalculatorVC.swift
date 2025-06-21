//
//  FinanceCalculatorVC.swift
//  test2
//
//  Created by Dias Karassayev on 3/25/25.
//
//
import UIKit
import SnapKit
import iOSDropDown
import M13Checkbox

class FinanceCalculatorVC: UIViewController{
    private let headerView = HeaderView()
    
    var allUniversities: [University] = []
    
    private var total = 0
    
    private var data: [String] = [
        "Education costs","Dormitory cost", "Military edu cost", "TOTAL"
    ]
    private var price: [Int] = [0,0,0,0]
    
    
    private let dropdownOptions = ["Student", "Teacher"]
    
    
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.showsVerticalScrollIndicator = false
        return scrollView
    }()
    
    private lazy var contentView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.customGreen2
        
        return view
    }()
    private lazy var titleLabel = UILabel.createLabel(size: 24, color: .black, font: "Poppins-Bold", text: "Finance Calculator")
    private lazy var descriptionLabel = UILabel.createLabel(size: 16, color: .black, font: "Poppins-Regular", text: "This tool will help you estimate the value of your education average cost.")
    private lazy var calculateLabel = UILabel.createLabel(size: 18, color: .black, font: "Poppins-Regular", text: "Calculate the total cost of education")
    private lazy var uniNameLabel = UILabel.createLabel(size: 14, color: .black, font: "Poppins-Regular", text: "University name")
    private lazy var programLabel = UILabel.createLabel(size: 14, color: .black, font: "Poppins-Regular", text: "Program")
    private lazy var cityLabel = UILabel.createLabel(size: 14, color: .black, font: "Poppins-Regular", text: "CIty")
    private lazy var calculateButton = UIButton.createButton(title: "Calculate", color: UIColor.customGreen, textColor: .white) {
        self.calculateTotal()
    }
    
    private lazy var uniDropDown: UIButton = {
        let button = UIButton.createDropDown(data: [], title: "Select University")
        
        button.menu = UIMenu(title: "", options: .displayInline, children: [])
        
        return button
    }()
    
    
    private lazy var programDropDown = UIButton.createDropDown(title: "Select Program")
    private lazy var cityDropDown = UIButton.createDropDown(title: "City")
    
    private lazy var checkMil: M13Checkbox = {
        let check = createCheckbox()
        return check
    }()
    private lazy var checkDorm: M13Checkbox = {
        let check = createCheckbox()
        return check
    }()
    private lazy var dormLabel = UILabel.createLabel(size: 14, color: .black, font: "Poppins-Regular", text: "Dormitory")
    private lazy var militaryLabel = UILabel.createLabel(size: 14, color: .black, font: "Poppins-Regular", text: "Military")
    
    private lazy var totalsLabel = UILabel.createLabel(size: 24, color: .black, font: "Poppins-Bold", text: "Totals")
    private lazy var taxLabel = UILabel.createLabel(size: 14, color: .black, font: "Poppins-Bold", text: "Pre and post tax estimates")
    
    private lazy var mainView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 20
        return view
    }()
    private lazy var calculateView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 20
        return view
    }()
    
    
    private lazy var menuTableView: UITableView = {
        let tableView = UITableView()
        tableView.register(CalculateTableViewCell.self, forCellReuseIdentifier: Cells.calculateTableViewCell)
        tableView.selectionFollowsFocus = false
        tableView.showsVerticalScrollIndicator = false
        tableView.isPagingEnabled = true
        tableView.isScrollEnabled = false
        return tableView
    }()
    
    private func updateDropDowns(for university: University) {
        // Обновление программы (faculties)
        let faculties = university.faculty.map { $0.facultyDto.name }
        programDropDown.updateMenu(with: faculties) { selected in
            print("Selected program: \(selected)")
        }
        programDropDown.updateTitle(to: "Select Program")
        
        // Обновление города
        if let city = university.location {
            // Если город существует, обновляем выпадающий список города
            cityDropDown.updateMenu(with: [city]) { selectedCity in
                print("Selected city: \(selectedCity)")
            }
            cityDropDown.updateTitle(to: city)  // Устанавливаем название города на кнопке
        } else {
            // Если города нет, показываем сообщение о его отсутствии
            cityDropDown.updateMenu(with: ["No city available"]) { _ in }
            cityDropDown.updateTitle(to: "City")
        }
        
    }
    
    
    
    
    
    
    @objc func checkboxTapped(_ sender: UIButton) {
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        menuTableView.delegate = self
        menuTableView.dataSource = self
        setupUI()
        
        UniversityService().fetchAllUniversities { result in
            switch result {
            case .success(let universities):
                self.allUniversities = universities
                
                let actions = universities.map { university in
                    UIAction(title: university.name) { _ in
                        self.updateDropDowns(for: university)
                        self.uniDropDown.updateTitle(to: university.name)
                    }
                }
                
                DispatchQueue.main.async {
                    self.uniDropDown.menu = UIMenu(title: "", options: .displayInline, children: actions)
                }
                
            case .failure(let error):
                print("Ошибка: \(error.localizedDescription)")
            }
        }
        
        
        
    }
    private func calculateTotal() {
        guard let universityName = uniDropDown.currentTitle,
              let program = programDropDown.currentTitle,
              let city = cityDropDown.currentTitle,
              let selectedUniversity = allUniversities.first(where: { $0.name == universityName }) else {
            return
        }
        
        // Initialize a new cost model for the selected university
        var universityCost = UniversityCost(educationCost: 0, dormitoryCost: 0, militaryCost: 0, total: 0)
        
        // Стоимость обучения для выбранной программы
        universityCost.educationCost = selectedUniversity.baseCost
        universityCost.total += universityCost.educationCost
        
        if checkDorm.checkState == .checked, let dormitoryCost = selectedUniversity.dormitoryCost {
            universityCost.dormitoryCost = dormitoryCost
            universityCost.total += dormitoryCost
        }
        
        if checkMil.checkState == .checked, let militaryCost = selectedUniversity.militaryDepartmentCost {
            universityCost.militaryCost = militaryCost
            universityCost.total += militaryCost
        }
        
        // Update the table data and reload it
        updateTableData(with: universityCost)
    }

    private func updateTableData(with cost: UniversityCost) {
        var tempData: [String] = []
        var tempPrice: [Int] = []

        tempData.append("Education costs")
        tempPrice.append(cost.educationCost)

        tempData.append("Dormitory cost")
        tempPrice.append(cost.dormitoryCost ?? 0)

        tempData.append("Military edu cost")
        tempPrice.append(cost.militaryCost ?? 0)

        tempData.append("TOTAL")
        tempPrice.append(cost.total)

        data = tempData
        price = tempPrice

        let indexPaths = (0..<data.count).map { IndexPath(row: $0, section: 0) }

        menuTableView.performBatchUpdates({
            menuTableView.reloadRows(at: indexPaths, with: .fade)
        }, completion: nil)
    }



}
extension FinanceCalculatorVC {
    func setupUI() {
        setupViews()
        setupConstraints()
    }
    func setupViews() {
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)

        contentView.addSubview(headerView)
        
        contentView.addSubview(titleLabel)
        contentView.addSubview(descriptionLabel)
        contentView.addSubview(mainView)
        
        mainView.addSubview(calculateLabel)
        mainView.addSubview(uniNameLabel)
        mainView.addSubview(uniDropDown)
        mainView.addSubview(programLabel)
        mainView.addSubview(programDropDown)
        mainView.addSubview(cityLabel)
        mainView.addSubview(cityDropDown)
        mainView.addSubview(checkMil)
        mainView.addSubview(militaryLabel)
        mainView.addSubview(checkDorm)
        mainView.addSubview(dormLabel)
        mainView.addSubview(calculateButton)

        contentView.addSubview(calculateView)
        calculateView.addSubview(totalsLabel)
        calculateView.addSubview(taxLabel)
        calculateView.addSubview(menuTableView)


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
        mainView.snp.makeConstraints { make in
            make.top.equalTo(descriptionLabel.snp.bottom).offset(30)
            make.leading.trailing.equalToSuperview().offset(16).inset(16)
            make.height.equalTo(view.snp.height).multipliedBy(0.6)
        }
        calculateLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(24)
            make.leading.trailing.equalToSuperview().offset(16).inset(16)
        }
        uniNameLabel.snp.makeConstraints { make in
            make.top.equalTo(calculateLabel.snp.bottom).offset(24)
            make.leading.equalToSuperview().offset(16)
        }
        uniDropDown.snp.makeConstraints { make in
            make.top.equalTo(uniNameLabel.snp.bottom).offset(10)
            make.leading.trailing.equalToSuperview().offset(16).inset(16)
            make.height.equalTo(48)
        }
        programLabel.snp.makeConstraints { make in
            make.top.equalTo(uniDropDown.snp.bottom).offset(24)
            make.leading.equalToSuperview().offset(16)
        }
        programDropDown.snp.makeConstraints { make in
            make.top.equalTo(programLabel.snp.bottom).offset(10)
            make.leading.trailing.equalToSuperview().offset(16).inset(16)
            make.height.equalTo(48)
        }
        cityLabel.snp.makeConstraints { make in
            make.top.equalTo(programDropDown.snp.bottom).offset(24)
            make.leading.equalToSuperview().offset(16)
        }
        cityDropDown.snp.makeConstraints { make in
            make.top.equalTo(cityLabel.snp.bottom).offset(10)
            make.leading.trailing.equalToSuperview().offset(16).inset(16)
            make.height.equalTo(48)
        }

        checkMil.snp.makeConstraints { make in
            make.top.equalTo(cityDropDown.snp.bottom).offset(24)
            make.leading.equalToSuperview().offset(16)
            make.size.equalTo(28)
        }
        militaryLabel.snp.makeConstraints { make in
            make.centerY.equalTo(checkMil.snp.centerY)
            make.left.equalTo(checkMil.snp.right).offset(10)
        }
        checkDorm.snp.makeConstraints { make in
            make.top.equalTo(checkMil.snp.bottom).offset(10)
            make.leading.equalToSuperview().offset(16)
            make.size.equalTo(28)
        }
        dormLabel.snp.makeConstraints { make in
            make.centerY.equalTo(checkDorm.snp.centerY)
            make.left.equalTo(checkDorm.snp.right).offset(10)
        }
        calculateButton.snp.makeConstraints { make in
            make.top.equalTo(checkDorm.snp.bottom).offset(24)
            make.leading.trailing.equalToSuperview().offset(16).inset(16)
            make.height.equalTo(48)
        }
        calculateView.snp.makeConstraints { make in
            make.top.equalTo(mainView.snp.bottom).offset(30)
            make.leading.trailing.equalToSuperview().offset(16).inset(16)
            make.height.equalTo(view.snp.height).multipliedBy(0.75)
        }
        totalsLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(30)
            make.leading.trailing.equalToSuperview().offset(16).inset(16)
        }
        taxLabel.snp.makeConstraints { make in
            make.top.equalTo(totalsLabel.snp.bottom).offset(10)
            make.leading.trailing.equalToSuperview().offset(16).inset(16)
        }
        menuTableView.snp.makeConstraints { make in
            make.top.equalTo(taxLabel.snp.bottom).offset(10)
            make.leading.trailing.equalToSuperview().offset(16).inset(16)
            make.height.equalTo(view.snp.height).multipliedBy(0.6)

        }
        let lastSubview = [headerView, titleLabel, descriptionLabel, mainView, calculateView].last!

        lastSubview.snp.makeConstraints { make in
            make.bottom.equalToSuperview().inset(tabBarController?.tabBar.frame.height ?? 0)
        }
        }
    }

extension FinanceCalculatorVC:  UITableViewDataSource, UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Cells.calculateTableViewCell, for: indexPath) as! CalculateTableViewCell
        cell.configure(with: data[indexPath.row], price: "\(price[indexPath.row]) ₸") // Ensure price is passed as a string
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return self.view.frame.height * 0.14
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 10  // любое значение отступа
    }
}
extension FinanceCalculatorVC{
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
}
