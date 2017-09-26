//
//  TimesheetViewController.swift
//  OnBoarding
//
//  Created by mmaalej on 20/09/2017.
//  Copyright © 2017 mmaalej. All rights reserved.
//

import UIKit

enum TimesheetInfo: String {
    case project = "project"
    case time = "time"
    static let allValues = [project, time]
    
    func startIndex() -> Int {
        switch self {
        case .project: return 0
        case .time: return TimesheetKey.allProjectKeys.count
        }
    }
}

enum TimesheetKey: String {
    case date = "Date"
    case identifier = "Project ID"
    case activity = "Activity"
    case buillable = "Buillable"
    case startWorking = "From"
    case stopWorking = "Until"
    case lunchBreak = "Lunch break"
    
    static let allProjectKeys = [date, identifier, activity, buillable]
    static let allTimeKeys = [startWorking, stopWorking, lunchBreak]
    
    func section() -> TimesheetInfo {
        switch self {
        case .date, .identifier, .activity, .buillable: return TimesheetInfo.allValues[0]
        case .startWorking, .stopWorking, .lunchBreak: return TimesheetInfo.allValues[1]
        }
    }
    
    func indexPathForKey() -> IndexPath {
        let section = self.section()
        var index = section.startIndex()
        switch section {
        case .project:
            index += TimesheetKey.allProjectKeys.index(of: self)!
        case .time:
            index += TimesheetKey.allTimeKeys.index(of: self)!
        }
        return IndexPath(row: index, section: section.hashValue)
    }
}

struct TimesheetEntry: Equatable {
    var info: TimesheetInfo
    var key: TimesheetKey
    var value: String
    
    static func ==(lhs: TimesheetEntry, rhs: TimesheetEntry) -> Bool {
        return lhs.key == rhs.key
    }
}

class TimesheetViewController: UIViewController {
    
    //MARK:- Properties
    let timesheetInfoTV = TimesheetInfoTableView(frame: .zero)
    let timerView = TimerView(status: .startWorking)
    let pickerView = PickerView(frame: .zero)

    var timesheetEntries: [TimesheetEntry] = []
    var timesheet = Timesheet(date: Date(), projectID: nil, activity: nil, buillable: nil, workFrom: nil, workUntil: nil, workedHours:nil, breakFrom: nil, breakUntil: nil, lunchBreak: nil)
    
    //MARK:- Views lifecycles
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTimesheetInfoTV()
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
        let views: [String: UIView] = ["tableView": timesheetInfoTV, "timer": timerView]
        for (_, view) in views {
            view.translatesAutoresizingMaskIntoConstraints = false
            self.view.addSubview(view)
            view.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
            view.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        }
        
        timesheetInfoTV.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor).isActive = true
        timesheetInfoTV.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: TimesheetInfoTableView.height).isActive = true
        timerView.topAnchor.constraint(equalTo: timesheetInfoTV.bottomAnchor, constant: 10).isActive = true
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
    func setupPickerView(entry: TimesheetEntry) {
        var dataSource: [String] = []
        switch entry.key {
        case .date:
            break
        case .identifier:
            dataSource = ["000001", "000002", "000003", "000004"]
        case .activity:
            dataSource = ["Activity 1", "Activity 2", "Activity 3", "Activity 4"]
        case .buillable:
            dataSource = ["Yes", "No"]
        case .lunchBreak, .startWorking, .stopWorking: break
        }
        pickerView.dataSource = dataSource
        
        //Done button
        pickerView.doneButtonAction = { [weak self] (newValue: String) in
            self?.update(key: entry.key, value: newValue)
            self?.dismissPickerView()
        }
        
        //Cancel
        pickerView.cancelButtonAction = { [weak self] in
            self?.dismissPickerView()
        }
    }
    
    func presentPickerView(entry: TimesheetEntry) {
        setupPickerView(entry: entry)
        self.layoutPickerView()
    }
    
    func dismissPickerView() {
        self.pickerView.removeFromSuperview()
    }
    
    //MARK: - Timesheet data tableview
    func setupTimesheetInfoTV() {
        for parameter in TimesheetInfo.allValues {
            switch parameter {
            case .project:
                for key in TimesheetKey.allProjectKeys {
                    let timesheetEntry = TimesheetEntry (info: parameter, key: key, value: "-")
                    timesheetEntries.append(timesheetEntry)
                }
            case .time:
                for key in TimesheetKey.allTimeKeys {
                    let timesheetEntry = TimesheetEntry (info: parameter, key: key, value: "-")
                    timesheetEntries.append(timesheetEntry)
                }
            }
        }
        timesheetInfoTV.dataSource = timesheetEntries
        timesheetInfoTV.delegate = self
    }
    
    //MARK:- Timer view
    func setupTimerView() {
        timerView.timerBtnAction = { [weak self] in
            var key: TimesheetKey?
            var value: Any?
            switch (self?.timerView.timerBtn.status)! {
            case .startWorking:
                self?.updateTimerButton(status: .startLunchBreak)
                key = .startWorking
                value = Date()
            case .startLunchBreak: // there is No UI update for this action
                self?.timesheet.breakFrom = Date()
                self?.updateTimerButton(status: .stopLunchBreak)
                return
            case .stopLunchBreak:
                self?.updateTimerButton(status: .stopWorking)
                key = .lunchBreak
                value = Date()
            case .stopWorking:
                self?.updateTimerButton(status: .submit)
                key = .stopWorking
                value = Date()
            case .submit:
                self?.preview()
                return
            case .send:
                return
            }
            self?.update(key: key!, value: value!)
        }
    }
    
    func updateTimerButton(status: Status) {
        timerView.timerBtn.setTitle(status.rawValue, for: .normal)
        timerView.timerBtn.status = status
    }
    
    //MARK:- Update data
    func update(key:TimesheetKey, value: Any) {
        switch (key) {
        case .activity:
            timesheet.activity = value as? String ?? nil
            self.timesheetEntries[key.indexPathForKey().row].value = timesheet.activity!
        case .buillable:
            timesheet.buillable = value as? String ?? nil
            self.timesheetEntries[key.indexPathForKey().row].value = timesheet.buillable!
        case .identifier:
            timesheet.projectID = value as? String ?? nil
            self.timesheetEntries[key.indexPathForKey().row].value = timesheet.projectID!
        case .date:
            break
        case .startWorking:
            timesheet.workFrom = value as? Date ?? nil
            self.timesheetEntries[key.indexPathForKey().row].value = (timesheet.workFrom?.simpleHoursFormat())!
        case .lunchBreak:
            timesheet.breakUntil = value as? Date ?? nil
            self.timesheetEntries[key.indexPathForKey().row].value = (timesheet.breakUntil?.simpleHoursFormat())!
            let lunchBreak = TimeCalculator.lunckBreak(start: (self.timesheet.breakFrom)!, end: (self.timesheet.breakUntil)!)
            timesheet.lunchBreak = lunchBreak
            self.timesheetEntries[key.indexPathForKey().row].value = "\(lunchBreak.hours) : \(lunchBreak.minutes)"
        case . stopWorking:
            timesheet.workUntil = value as? Date ?? nil
            self.timesheetEntries[key.indexPathForKey().row].value = (timesheet.breakUntil?.simpleHoursFormat())!
            self.timesheet.workedHours = TimeCalculator.workedHours(start: (self.timesheet.workFrom)!, end: (self.timesheet.workUntil)!, lunchBreak: timesheet.lunchBreak!)
        }
        
        timesheetInfoTV.dataSource = self.timesheetEntries
    }
    
    //MARK:- timesheet submission
    func preview() {
        guard timesheet.date != nil, timesheet.projectID != nil, timesheet.activity != nil, timesheet.buillable != nil, timesheet.workFrom != nil, timesheet.workUntil != nil, timesheet.workedHours != nil, timesheet.breakFrom != nil, timesheet.breakUntil != nil, timesheet.lunchBreak != nil else {
            return
        }
        let timesheetPreviewVC = TimesheetPreviewViewController()
        timesheetPreviewVC.timesheet = timesheet
        self.navigationController?.pushViewController(timesheetPreviewVC, animated: true)
    }
}
extension TimesheetViewController: TimesheetInfoTableViewDelegate {
    func didSelectTimesheetInfo(timesheetInfoTableView: TimesheetInfoTableView, entry: TimesheetEntry) {
        presentPickerView(entry: entry)
    }
}
