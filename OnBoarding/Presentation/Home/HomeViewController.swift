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
    let homeView: HomeView = {
        let contentView = CollectionView(items: modules, bgColor: UIColor.bgColor)
        let view = HomeView (header: "The following modules help you completing your day to day operations", contentView: contentView)
        view.backgroundColor = UIColor.bgColor
        return view
    }()
    
    //MARK:- Views lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        layout()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.view.backgroundColor = .white
        self.navigationController?.isNavigationBarHidden = false
        self.navigationController?.navigationBar.topItem?.title = "Welcome on Board"
    }
    
    //MARK:- Layout
    func layout() {
        homeView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(homeView)
        homeView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor).isActive = true
        homeView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        homeView.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        homeView.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
    }
}
