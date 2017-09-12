//
//  HomeViewController.swift
//  OnBoarding
//
//  Created by mmaalej on 11/09/2017.
//  Copyright © 2017 mmaalej. All rights reserved.
//

import UIKit

enum CollectionItem: String{
    case Time = "Timesheet"
    case Expenses = "Travel expenses"
    case Elearning = "E-Learning"
    case Others = "Others"
    
   static let allValues = [Time, Expenses, Elearning, Others]
    
    func icon() -> UIImage {
        switch self {
        case .Time:
            return UIImage.init(named: "Time")!
        case .Expenses:
            return UIImage.init(named: "Expenses")!
        case .Elearning:
            return UIImage.init(named: "Elearning")!
        case .Others:
            return UIImage.init(named: "Others")!
        }
    }
}

class HomeViewController: UIViewController {
    
    //Properties
    let homeView = HomeView(frame: .zero)
    
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
