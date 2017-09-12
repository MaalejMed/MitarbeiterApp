//
//  TabBar.swift
//  OnBoarding
//
//  Created by mmaalej on 12/09/2017.
//  Copyright © 2017 mmaalej. All rights reserved.
//

import UIKit

class TabBar {
    
    //TabBar
    static func setupAppTabBar() {
        let homeVC = HomeViewController()
        let homeTBI = UITabBarItem.init(title: "Home", image: UIImage.init(named: "Home"), tag: 01)
        homeVC.tabBarItem = homeTBI
        
        let profileVC = ProfileViewController()
        let profileNC = UINavigationController.init(rootViewController: profileVC)
        let profileTBI = UITabBarItem.init(title: "Profile", image: UIImage.init(named: "Profile"), tag: 03)
        profileVC.tabBarItem = profileTBI
        
        let gsdVC = GSDViewController()
        let gsdNC = UINavigationController.init(rootViewController: gsdVC)
        let gsdTBI = UITabBarItem.init(title: "GSD", image: UIImage.init(named: "Gsd"), tag: 02)
        gsdVC.tabBarItem = gsdTBI
        
        let tabBar = UITabBarController()
        tabBar.viewControllers = [homeVC, gsdVC, profileVC]
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.window?.rootViewController = tabBar
    }
}
