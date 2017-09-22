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

enum ProjectVisibleDetail: String {
    case date = "Date"
    case identifier = "Project ID"
    case activity = "Activity"
    case buillable = "Buillable"
    
    static let allValues = [date, identifier, activity, buillable]
}

enum TimeVisibleDetail:String {
    case workFrom = "From"
    case workUntil = "Until"
    case lunchBreak = "Lunch break"
    
    static let allValues = [workFrom, workUntil, lunchBreak]
}

class TimeRecordingViewController: UIViewController {
    
    //MARK:- Properties
    let timeRecordingTV = TimeRecordingTableView(frame: .zero)
    let timerView = TimerView(frame:.zero)
    let pickerView = PickerView(frame: .zero)
    
    var selectedProjectDetail: ProjectVisibleDetail?
    var timesheet = Timesheet(date: Date(), projectID: nil, activity: nil, buillable: nil, workFrom: nil, workUntil: nil, workedHours:nil, breakFrom: nil, breakUntil: nil, lunchBreak: nil)
    
    //MARK:- Views lifecycles
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTimeRecordingTV()
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
        let views: [String: UIView] = ["tableView": timeRecordingTV, "timer": timerView]
        for (_, view) in views {
            view.translatesAutoresizingMaskIntoConstraints = false
            self.view.addSubview(view)
            view.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
            view.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        }
        
        timeRecordingTV.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor).isActive = true
        timeRecordingTV.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: TimeRecordingTableView.height).isActive = true
        timerView.topAnchor.constraint(equalTo: timeRecordingTV.bottomAnchor, constant: 10).isActive = true
    }
    
    func layoutPickerView() {
        pickerView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(pickerView)
        pickerView.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        pickerView.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        pickerView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        pickerView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: -200).isActive = true
    }
    
    //MARK:- Picker view
    func setupPickerView(detail: ProjectVisibleDetail) {
        var dataSource: [String] = []
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
            
            guard let index = ProjectVisibleDetail.allValues.index(of: detail) else {
                return
            }
            
            let updatedData:(detail: ProjectVisibleDetail, newValue: String) = (detail: detail, newValue: selectedPickerItem)
            let indexPath = IndexPath(row: index, section: Parameter.allValues.index(of: .project)!)
            self?.updateProjectVisibleDetails(indexPath: indexPath, data: updatedData)
            self?.dismissPickerView()
        }
        
        //Cancel
        pickerView.cancelButtonAction = { [weak self] in
            self?.dismissPickerView()
        }
    }
    
    func presentPickerView(detail: ProjectVisibleDetail) {
        setupPickerView(detail: detail)
        self.layoutPickerView()
    }
    
    func dismissPickerView() {
        self.pickerView.removeFromSuperview()
        self.selectedProjectDetail = nil
    }
    
    //MARK: - Timesheet data tableview
    func setupTimeRecordingTV() {
        var dataSource: [Parameter: [Any]] = [:]
        for parameter in Parameter.allValues {
            switch parameter {
            case .project:
                dataSource [parameter] = ProjectVisibleDetail.allValues
            case .time:
                dataSource [parameter] = TimeVisibleDetail.allValues
            }
        }
        timeRecordingTV.dataSource = dataSource
        timeRecordingTV.delegate = self
    }
    
    //MARK:- Timer view
    func setupTimerView() {
        timerView.timerBtnAction = { [weak self] in
            var index: Int?
            var newValue: Date?
            let timeDetails = TimeVisibleDetail.allValues

            switch (self?.timerView.timerBtn.status)! {
            case .startWorking:
                newValue = Date()
                self?.updateTimerButton(status: .startLunchBreak)
                index = timeDetails.index(of: .workFrom)
            case .startLunchBreak:
                self?.timesheet.breakFrom = Date()
                self?.updateTimerButton(status: .stopLunchBreak)
            case .stopLunchBreak:
                newValue = Date()
                self?.updateTimerButton(status: .stopWorking)
                index = timeDetails.index(of: .lunchBreak)
                break
            case .stopWorking:
                newValue = Date()
                index = timeDetails.index(of: .workUntil)
                self?.updateTimerButton(status: .submit)
            case .submit:
                self?.submitTimesheet()
            }

            guard let detailIndex = index else {
                return
            }
        
            let info = timeDetails[detailIndex]
            let indexPath = IndexPath(row: detailIndex, section:1)
            let data: (detail: TimeVisibleDetail, newValue: Date) = (detail: info, newValue: newValue!)
            self?.updateTimeVisibleDetails(indexPath: indexPath, data: data)
        }
    }
    
    func updateTimerButton(status: status) {
        timerView.timerBtn.setTitle(status.rawValue, for: .normal)
        timerView.timerBtn.status = status
    }
    
    //MARK:- Update data
    func updateProjectVisibleDetails (indexPath: IndexPath, data:(detail: ProjectVisibleDetail, newValue: String)) {
        // update UI
        let cell: BasicTableViewCell = timeRecordingTV.tableView.cellForRow(at: indexPath) as! BasicTableViewCell
        cell.data = (title: data.detail.rawValue, details: data.newValue, icon: nil)
        // update model
        switch (data.detail) {
            case .activity:
                timesheet.activity = data.newValue
            case .buillable:
                timesheet.buillable = NSString(string: data.newValue).boolValue
            case .identifier:
                timesheet.projectID = data.newValue
            case .date: break
        }
    }
    
    func updateTimeVisibleDetails (indexPath: IndexPath?, data:(detail: TimeVisibleDetail, newValue: Date)) {
        var displayedValue: String?
        //update model
        switch data.detail {
        case .workFrom:
            timesheet.workFrom = data.newValue
            displayedValue = data.newValue.simpleHoursFormat()
        case .lunchBreak:
            timesheet.breakUntil = data.newValue
            let lunchBreak = TimeCalculator.lunckBreak(start: (self.timesheet.breakFrom)!, end: (self.timesheet.breakUntil)!)
            timesheet.lunchBreak = lunchBreak
            displayedValue = "\(lunchBreak.hours) : \(lunchBreak.minutes)"
        case .workUntil:
            timesheet.workUntil = data.newValue
            displayedValue = data.newValue.simpleHoursFormat()
            self.timesheet.workedHours = TimeCalculator.workedHours(start: (self.timesheet.workFrom)!, end: (self.timesheet.workUntil)!, lunchBreak: timesheet.lunchBreak!)
        }
        // update UI
        if let index = indexPath {
            let cell: BasicTableViewCell = timeRecordingTV.tableView.cellForRow(at: index) as! BasicTableViewCell
            cell.data = (title: data.detail.rawValue, details: displayedValue, icon: nil)
        }
    }
    
    //MARK:- timesheet submission
    func submitTimesheet() {
        print(timesheet)
    }
}
extension TimeRecordingViewController: TimeRecordingTableViewDelegate {
    func didSelectProjectDetail(timeRecordingTableView: TimeRecordingTableView, detail: ProjectVisibleDetail) {
        presentPickerView(detail: detail)
        self.selectedProjectDetail = detail
    }
}
