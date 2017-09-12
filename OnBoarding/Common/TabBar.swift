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
        let homeNC = UINavigationController.init(rootViewController: homeVC)
        let homeTBI = UITabBarItem.init(title: "Home", image: UIImage.init(named: "Home"), tag: 01)
        homeVC.tabBarItem = homeTBI
        
        let gsdVC = GSDViewController()
        let gsdNC = UINavigationController.init(rootViewController: gsdVC)
        let gsdTBI = UITabBarItem.init(title: "GSD", image: UIImage.init(named: "Gsd"), tag: 02)
        gsdVC.tabBarItem = gsdTBI
        
        let profileVC = ProfileViewController()
        let profileNC = UINavigationController.init(rootViewController: profileVC)
        let profileTBI = UITabBarItem.init(title: "Profile", image: UIImage.init(named: "Profile"), tag: 03)
        profileVC.tabBarItem = profileTBI
        
        let tabBar = UITabBarController()
        tabBar.viewControllers = [homeNC, gsdNC, profileNC]
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.window?.rootViewController = tabBar
    }
}
