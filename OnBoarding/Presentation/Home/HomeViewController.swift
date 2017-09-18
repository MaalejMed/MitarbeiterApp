//
//  HomeViewController.swift
//  OnBoarding
//
//  Created by mmaalej on 11/09/2017.
//  Copyright © 2017 mmaalej. All rights reserved.
//

import UIKit

let modules: [(String, UIImage)] = [
    ("Time recording", UIImage.init(named: "Time")!),
    ("Travel Expenses", UIImage.init(named: "Expenses")!),
    ("Others", UIImage.init(named: "Others")!),
    ("E-Learning", UIImage.init(named: "Elearning")!),
]

class HomeViewController: UIViewController {
    
    //Properties
    let profileView = ProfileView(frame: .zero)
    let homeView: HomeView = {
        let contentView = HomeCollectionView(items: modules, bgColor: UIColor.bgColor)
        let view = HomeView (header: "The following modules help you completing your day to day operations", contentView: contentView)
        view.backgroundColor = UIColor.bgColor
        return view
    }()
    
    //MARK:- Views lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupProfileView()
        layout()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.view.backgroundColor = .white
        self.navigationController?.isNavigationBarHidden = false
        self.navigationController?.navigationBar.topItem?.title = "Welcome on Board"
        self.navigationController?.navigationBar.barTintColor = UIColor.navigationBarBgColor
    }
    
    //MARK:- Layout
    func layout() {
        let views: [String: UIView] = ["profile": profileView, "home": homeView]
        for (_, view) in views{
            view.translatesAutoresizingMaskIntoConstraints = false
            self.view.addSubview(view)
            view.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
            view.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        }
        
        profileView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor).isActive = true
        profileView.bottomAnchor.constraint(equalTo: homeView.topAnchor).isActive = true
        homeView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor).isActive = true
       
    }
    
    //MARK:- Views
    func setupProfileView() {
        profileView.data = (name: "Mohamed Maalej (645438)", profileImage: UIImage.init(named: "Logo")!, changeProfileImageAction: nil)
        profileView.backgroundColor = UIColor.bgColor
    }
}
