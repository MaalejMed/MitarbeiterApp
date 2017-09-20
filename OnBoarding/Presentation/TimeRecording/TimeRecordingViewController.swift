//
//  TimeRecordingViewController.swift
//  OnBoarding
//
//  Created by mmaalej on 20/09/2017.
//  Copyright © 2017 mmaalej. All rights reserved.
//

import UIKit

enum ProjectParamter: String {
    case date = "Date"
    case identifier = "Project ID"
    case activity = "Activity"
    case buillable = "Buillable"
    
    static let allValues = [date, identifier, activity, buillable]
}

class TimeRecordingViewController: UIViewController {
    
    //MARK:- Properties
    let projectInfoTableView = ProjectInfoTableView()
    
    //MARK:- Views lifecycles
    override func viewDidLoad() {
        super.viewDidLoad()
        layout()
        setupProjectInfoView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.view.backgroundColor = .white
        self.title = "Time"
        self.navigationController?.navigationBar.barTintColor = UIColor.navigationBarBgColor
    }
    
    //MARK:- Layout
    func layout() {
        let views: [String: UIView] = ["projectInfo": projectInfoTableView]
        for (_, view) in views {
            view.translatesAutoresizingMaskIntoConstraints = false
            self.view.addSubview(view)
            view.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
            view.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        }
        
        projectInfoTableView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor).isActive = true
        projectInfoTableView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        
    }
    
    //MARK:- Setup views
    func setupProjectInfoView() {
        projectInfoTableView.dataSource = ProjectParamter.allValues
    }
}
