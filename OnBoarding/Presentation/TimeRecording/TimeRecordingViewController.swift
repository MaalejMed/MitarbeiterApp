//
//  TimeRecordingViewController.swift
//  OnBoarding
//
//  Created by mmaalej on 20/09/2017.
//  Copyright © 2017 mmaalej. All rights reserved.
//

import UIKit

enum InfoKey {
    case project
    case time
}
enum InfoParamter: String {
    case date = "Date"
    case identifier = "Project ID"
    case activity = "Activity"
    case buillable = "Buillable"
    
    case startWork = "From"
    case stopWork = "Until"
    case lunchBreak = "Lunch break"
    
    static let allValues: [InfoKey: [InfoParamter]] = [ .project: [date, identifier, activity, buillable], .time : [startWork, stopWork, lunchBreak]]
}

class TimeRecordingViewController: UIViewController {
    
    //MARK:- Properties
    let projectInfoTableView = ProjectInfoTableView(frame: .zero)
    let timerView = TimerView(frame:.zero)
    let pickerView = PickerView(frame: .zero)
    
    var selectedParameter: InfoParamter?
    var selectedItem: String?
    
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
        let views: [String: UIView] = ["projectInfo": projectInfoTableView, "timer": timerView]
        for (_, view) in views {
            view.translatesAutoresizingMaskIntoConstraints = false
            self.view.addSubview(view)
            view.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
            view.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        }
        
        projectInfoTableView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor).isActive = true
        
        projectInfoTableView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: ProjectInfoTableView.height).isActive = true

        timerView.topAnchor.constraint(equalTo: projectInfoTableView.bottomAnchor, constant: 10).isActive = true
        
    }
    
    func layoutPickerView() {
        pickerView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(pickerView)
        pickerView.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        pickerView.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        pickerView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        pickerView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: -200).isActive = true
    }
    
    //MARK:- Setup views
    func setupProjectInfoView() {
        projectInfoTableView.dataSource = InfoParamter.allValues
        projectInfoTableView.delegate = self
    }
    
    func setupPickerView(parameter: InfoParamter) {
        var dataSource: [String] = []
        switch parameter {
        case .date:
            break
        case .identifier:
            dataSource = ["000001", "000002", "000003", "000004"]
        case .activity:
            dataSource = ["Activity 1", "Activity 2", "Activity 3", "Activity 4"]
        case .buillable:
            dataSource = ["YES", "NO"]
        case .startWork, .stopWork, .lunchBreak: break
        }
        
        pickerView.dataSource = dataSource
        
        pickerView.doneButtonAction = { [weak self] (selectedItem: String) in
            guard let parameter = self?.selectedParameter else {
                return
            }
            
            let projectParam = InfoParamter.allValues[.project]
            guard let parameterIndex = projectParam?.index(of: parameter) else {
                return
            }
            
            let indexPath = IndexPath(row: parameterIndex, section:0)
            let cell: BasicTableViewCell = self?.projectInfoTableView.tableView.cellForRow(at: indexPath) as! BasicTableViewCell
            cell.data = (title: self?.selectedParameter?.rawValue, details: selectedItem, icon: nil)
            self?.dismissPickerView()
        }
        
        pickerView.cancelButtonAction = { [weak self] in
            self?.dismissPickerView()
        }
    }
    
    //MARK:- PickerView
    func presentPickerView(parameter: InfoParamter) {
        setupPickerView(parameter: parameter)
            self.layoutPickerView()
    }
    
    func dismissPickerView() {
        self.pickerView.removeFromSuperview()
        selectedParameter = nil
        selectedItem = nil
    }
}

extension TimeRecordingViewController: ProjectInfoTableViewDelegate {
    func didSelectProjectParamter(projectInfoTableView: ProjectInfoTableView, parameter: InfoParamter) {
        presentPickerView(parameter: parameter)
        selectedParameter = parameter
    }
}

