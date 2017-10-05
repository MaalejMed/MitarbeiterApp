//
//  TimesheetViewController.swift
//  OnBoarding
//
//  Created by mmaalej on 20/09/2017.
//  Copyright © 2017 mmaalej. All rights reserved.
//

import UIKit

class TimesheetViewController: UIViewController {
    
    //MARK:- Properties
    let timesheetInfoTV = TimesheetInfoTableView(frame: .zero)
    let timerButton = TimerButton(frame: .zero)
    let pickerView = PickerView(frame: .zero)
    
    var timesheetEntries: [EntryInfo: [TimesheetEntry]] = [:]
    var timesheet = Timesheet(date: Date(), projectID: nil, activity: nil, buillable: nil, workFrom: nil, workUntil: nil, workedHours:nil, breakFrom: nil, breakUntil: nil, lunchBreak: nil)
    
    //MARK:- Views lifecycles
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTimesheetInfoTV()
        setupTimerButton()
        layout()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.view.backgroundColor = UIColor.BgColor
        self.title = "Time"
        self.navigationController?.navigationBar.tintColor = UIColor.white
        self.navigationController?.navigationBar.barTintColor = UIColor.navBarBgColor
    }
    
    func presentPickerView(entry: TimesheetEntry) {
        setupPickerView(entry: entry)
        self.layoutPickerView()
    }
    
    func dismissPickerView() {
        self.pickerView.removeFromSuperview()
    }
    
    //MARK:- Layout
    func layout() {
        let views: [String: UIView] = ["tableView": timesheetInfoTV, "timer": timerButton]
        for (_, view) in views {
            view.translatesAutoresizingMaskIntoConstraints = false
            self.view.addSubview(view)
        }
        
        timesheetInfoTV.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        timesheetInfoTV.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        
        timerButton.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 70).isActive = true
        timerButton.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -70).isActive = true
        
        
        timesheetInfoTV.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor).isActive = true
        timesheetInfoTV.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: TimesheetInfoTableView.height).isActive = true
        timerButton.topAnchor.constraint(equalTo: timesheetInfoTV.bottomAnchor, constant: 10).isActive = true
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

    func setupTimerButton() {
        timerButton.status = .startWorking
        timerButton.action = { [weak self] in
            var key: EntryKey?
            var value: Any?
            switch (self?.timerButton.status)! {
            case .startWorking:
                self?.timerButton.status = .startLunchBreak
                key = .startWorking
                value = Date()
            case .startLunchBreak: // there is No UI update for this action
                self?.timesheet.breakFrom = Date()
                self?.timerButton.status = .stopLunchBreak
                return
            case .stopLunchBreak:
                self?.timerButton.status = .stopWorking
                key = .lunchBreak
                value = Date()
            case .stopWorking:
                self?.timerButton.status = .submit
                key = .stopWorking
                value = Date()
            case .submit:
                self?.preview()
                return
            }
            self?.update(key: key!, value: value!)
        }
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
    
    //MARK:- Preview
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

