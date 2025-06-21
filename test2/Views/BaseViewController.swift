//
//  BaseViewController.swift
//  test2
//
//  Created by Dias Karassayev on 3/25/25.
//
import UIKit

class BaseViewController: UIViewController, HeaderViewDelegate {

    private var headerView: HeaderView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Initialize and set up the header view
        setupHeaderView()
    }

    private func setupHeaderView() {
        headerView = HeaderView()
        headerView.delegate = self  // Set the delegate
        view.addSubview(headerView)

        // Add any additional setup for the header view here
    }

    // Implement the delegate method
    func didTapHeartIcon() {
        print("Heart icon tapped!")
        let newScreen = NotificationsViewController()
        navigationController?.pushViewController(newScreen, animated: true)
    }
}
