//
//  TimesheetViewController.swift
//  OnBoarding
//
//  Created by mmaalej on 20/09/2017.
//  Copyright © 2017 mmaalej. All rights reserved.
//

import UIKit

struct TimesheetEntry: Equatable {
    var info: EntryInfo
    var key: EntryKey
    var value: String
    
    static func ==(lhs: TimesheetEntry, rhs: TimesheetEntry) -> Bool {
        return lhs.key == rhs.key
    }
}

enum EntryInfo: String {
    case project = "project"
    case time = "time"
    static let allValues = [project, time]
}

enum EntryKey: String {
    case date = "Date"
    case identifier = "Project ID"
    case activity = "Activity"
    case buillable = "Buillable"
    case startWorking = "From"
    case stopWorking = "Until"
    case lunchBreak = "Lunch break"
    
    static let allProjectKeys = [date, identifier, activity, buillable]
    static let allTimeKeys = [startWorking, stopWorking, lunchBreak]
    
    func section() -> EntryInfo {
        switch self {
        case .date, .identifier, .activity, .buillable: return EntryInfo.allValues[0]
        case .startWorking, .stopWorking, .lunchBreak: return EntryInfo.allValues[1]
        }
    }
    
    func index() -> Int {
        let section = self.section()
        switch section {
        case .project:
            return EntryKey.allProjectKeys.index(of: self)!
        case .time:
            return EntryKey.allTimeKeys.index(of: self)!
        }
    }
}

class TimesheetViewController: UIViewController {
    
    //MARK:- Properties
    let timesheetInfoTV = TimesheetInfoTableView(frame: .zero)
    let timerView = TimerView(status: .startWorking)
    let pickerView = PickerView(frame: .zero)
    
    var timesheetEntries: [EntryInfo: [TimesheetEntry]] = [:]
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
        for parameter in EntryInfo.allValues {
            switch parameter {
            case .project:
                var entries: [TimesheetEntry] = []
                for key in EntryKey.allProjectKeys {
                    let timesheetEntry = TimesheetEntry (info: parameter, key: key, value: "-")
                    entries.append(timesheetEntry)
                    timesheetEntries [.project] = entries
                }
            case .time:
                var entries: [TimesheetEntry] = []
                for key in EntryKey.allTimeKeys {
                    let timesheetEntry = TimesheetEntry (info: parameter, key: key, value: "-")
                    entries.append(timesheetEntry)
                    timesheetEntries [.time] = entries
                }
            }
        }
        timesheetInfoTV.dataSource = timesheetEntries
        timesheetInfoTV.delegate = self
    }
    
    //MARK:- Timer view
    func setupTimerView() {
        timerView.timerBtnAction = { [weak self] in
            var key: EntryKey?
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
            case .send, .idle:
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
    func update(key:EntryKey, value: Any) {
        let section = key.section()
        switch (key) {
        case .activity:
            timesheet.activity = value as? String ?? nil
            timesheetEntries[section]![key.index()].value = timesheet.activity!
        case .buillable:
            timesheet.buillable = value as? String ?? nil
            timesheetEntries[section]![key.index()].value = timesheet.buillable!
        case .identifier:
            timesheet.projectID = value as? String ?? nil
            timesheetEntries[section]![key.index()].value = timesheet.projectID!
        case .date:
            break
        case .startWorking:
            timesheet.workFrom = value as? Date ?? nil
            timesheetEntries[section]![key.index()].value = (timesheet.workFrom?.simpleHoursFormat())!
        case .lunchBreak:
            timesheet.breakUntil = value as? Date ?? nil
            let lunchBreak = TimeCalculator.lunckBreak(start: (self.timesheet.breakFrom)!, end: (self.timesheet.breakUntil)!)
            timesheet.lunchBreak = lunchBreak
            let hours = (timesheet.lunchBreak?.hours)!
            let minutes = (timesheet.lunchBreak?.minutes)!
            timesheetEntries[section]![key.index()].value = "\(hours) : \(minutes)"

        case . stopWorking:
            timesheet.workUntil = value as? Date ?? nil
            timesheetEntries[section]![key.index()].value = (timesheet.workUntil?.simpleHoursFormat())!
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

