//
//  TabBarController.swift
//  test1
//
//  Created by Dias Karassayev on 3/11/25.
//

import UIKit

final class TabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let homeVC = MainPage()
        let universitiesVC = UniversitiesViewController()
        let forumVC = ForumViewController()
        let menuVC = MenuViewController()
        
        homeVC.tabBarItem = UITabBarItem(title: "Main Page", image: UIImage(named: "tab1"), selectedImage: UIImage(named: "tab"))
        universitiesVC.tabBarItem = UITabBarItem(title: "Universities", image: UIImage(named: "tab2"), selectedImage: nil)
        forumVC.tabBarItem = UITabBarItem(title: "Forum", image: UIImage(named: "tab3"), selectedImage: nil)
        menuVC.tabBarItem = UITabBarItem(title: "Menu", image: UIImage(named: "tab4"), selectedImage: nil)

        
        // Embed view controllers in navigation controllers
        let homeNavController = UINavigationController(rootViewController: homeVC)
        let universitiesNavController = UINavigationController(rootViewController: universitiesVC)
        let forumNavController = UINavigationController(rootViewController: forumVC)
        let menuNavController = UINavigationController(rootViewController: menuVC)
        
        // Set tab bar tint color
        tabBar.tintColor = .label
        
        // Set view controllers
        setViewControllers([homeNavController, universitiesNavController, forumNavController, menuNavController], animated: true)
    }
}

