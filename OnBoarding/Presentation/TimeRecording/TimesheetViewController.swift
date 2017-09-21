//
//  TimesheetViewController.swift
//  OnBoarding
//
//  Created by mmaalej on 20/09/2017.
//  Copyright © 2017 mmaalej. All rights reserved.
//

import UIKit

enum Parameter: String {
    case project = "project"
    case time = "time"
    
    static let allValues = [project, time]
}

enum ProjectDetail: String {
    case date = "Date"
    case identifier = "Project ID"
    case activity = "Activity"
    case buillable = "Buillable"
    
    static let allValues = [date, identifier, activity, buillable]
}

enum TimeDetail: String {
    case from = "From"
    case until = "Until"
    case lunchBreak = "Lunch break"
    
    static let allValues = [from, until, lunchBreak]
}

class TimesheetViewController: UIViewController {
    
    //MARK:- Properties
    let timesheetDataTV = TimesheetDataTableView(frame: .zero)
    let timerView = TimerView(frame:.zero)
    let pickerView = PickerView(frame: .zero)
    var selectedProjectDetail: ProjectDetail?
    
    
    
    var selectedinfoValue: String?
    var startBreak: Date?
    
    //MARK:- Views lifecycles
    override func viewDidLoad() {
        super.viewDidLoad()
        setupProjectInfoTableView()
        setupTimerView()
        layout()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.view.backgroundColor = .white
        self.title = "Time"
        self.navigationController?.navigationBar.barTintColor = UIColor.navigationBarBgColor
    }
    
    //MARK:- Layout
    func layout() {
        let views: [String: UIView] = ["tableView": timesheetDataTV, "timer": timerView]
        for (_, view) in views {
            view.translatesAutoresizingMaskIntoConstraints = false
            self.view.addSubview(view)
            view.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
            view.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        }
        
        timesheetDataTV.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor).isActive = true
        timesheetDataTV.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: TimesheetDataTableView.height).isActive = true
        timerView.topAnchor.constraint(equalTo: timesheetDataTV.bottomAnchor, constant: 10).isActive = true
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
    func setupProjectInfoTableView() {
        var dataSource: [Parameter: [Any]] = [:]
        for parameter in Parameter.allValues {
            switch parameter {
            case .project:
                dataSource [parameter] = ProjectDetail.allValues
            case .time:
                dataSource [parameter] = TimeDetail.allValues
            }
        }
        timesheetDataTV.dataSource = dataSource
        timesheetDataTV.delegate = self
    }
    
    func setupPickerView(detail: ProjectDetail) {
        var dataSource: [String] = []
        
        //Data source
        switch detail {
        case .date:
            break
        case .identifier:
            dataSource = ["000001", "000002", "000003", "000004"]
        case .activity:
            dataSource = ["Activity 1", "Activity 2", "Activity 3", "Activity 4"]
        case .buillable:
            dataSource = ["YES", "NO"]
        }
        pickerView.dataSource = dataSource
        
        //Done button
        pickerView.doneButtonAction = { [weak self] (selectedPickerItem: String) in
            guard let detail = self?.selectedProjectDetail else {
                return
            }
            
            guard let index = ProjectDetail.allValues.index(of: detail) else {
                return
            }
            
            let indexPath = IndexPath(row: index, section: Parameter.allValues.index(of: .project)!)
            let cell: BasicTableViewCell = self?.timesheetDataTV.tableView.cellForRow(at: indexPath) as! BasicTableViewCell
            cell.data = (title: self?.selectedProjectDetail?.rawValue, details: selectedPickerItem, icon: nil)
            self?.dismissPickerView()
        }
        
        //Cancel
        pickerView.cancelButtonAction = { [weak self] in
            self?.dismissPickerView()
        }
    }
    
    func setupTimerView() {
        timerView.timerBtnAction = { [weak self] in
            var index: Int?
            var dateString: String?
            let timeDetails = TimeDetail.allValues
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "HH:mm:ss"

            switch (self?.timerView.timerBtn.status)! {
            case .startWorking:
                index = timeDetails.index(of: .from)
                dateString = dateFormatter.string(from: Date())
                self?.updateTimerButton(status: .startLunchBreak)
            case .startLunchBreak:
                self?.startBreak = Date()
                self?.updateTimerButton(status: .stopLunchBreak)
            case .stopLunchBreak:
                index = timeDetails.index(of: .lunchBreak)
                let now = Date()
                let interval = now.timeIntervalSince((self?.startBreak)!)
                let lunch: (minutes: Int, seconds: Int) = interval.inMinutes()
                dateString = "\(lunch.minutes) : \(lunch.seconds)"
                self?.updateTimerButton(status: .stopWorking)
                break
            case .stopWorking:
                index = timeDetails.index(of: .until)
                dateString = dateFormatter.string(from: Date())
                self?.updateTimerButton(status: .submit)
            case .submit: break
            }

            guard let detailIndex = index else {
                return
            }
            
            let info = timeDetails[detailIndex]
            let indexPath = IndexPath(row: detailIndex, section:1)
            let cell: BasicTableViewCell = self?.timesheetDataTV.tableView.cellForRow(at: indexPath) as! BasicTableViewCell
            cell.data = (title: info.rawValue, details: dateString, icon: nil)
        }
    }
    
    func updateTimerButton(status: status) {
        timerView.timerBtn.setTitle(status.rawValue, for: .normal)
        timerView.timerBtn.status = status
    }
    
    //MARK:- PickerView
    func presentPickerView(detail: ProjectDetail) {
        setupPickerView(detail: detail)
            self.layoutPickerView()
    }
    
    func dismissPickerView() {
        self.pickerView.removeFromSuperview()
        self.selectedProjectDetail = nil
        selectedinfoValue = nil
    }
}

extension TimesheetViewController: TimesheetDataTableViewDelegate {
    func didSelectProjectDetail(timesheetDataTableView: TimesheetDataTableView, detail: ProjectDetail) {
        presentPickerView(detail: detail)
        self.selectedProjectDetail = detail
    }
}

