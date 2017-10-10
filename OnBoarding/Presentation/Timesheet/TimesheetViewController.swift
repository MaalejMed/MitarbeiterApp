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
    
    lazy var editBtn: UIButton = {
        let button = UIButton.init(type: .custom)
        button.setTitle("Edit time", for: .normal)
        button.setTitle("Done", for: .selected)
        button.titleLabel?.textAlignment = .right
        button.frame.size = CGSize(width: 70.0, height: 40.0)
        button.addTarget(self, action: #selector(editButtonTapped), for: .touchUpInside)
        return button
    }()
    
    //MARK:- Views lifecycles
    override func viewDidLoad() {
        super.viewDidLoad()
        setupEditButton()
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
    func setupEditButton() {
        let button = UIBarButtonItem(customView: editBtn)
        self.navigationItem.rightBarButtonItem = button

    }
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
                    let timesheetEntry = TimesheetEntry (info: parameter, key: key, value: nil)
                    entries.append(timesheetEntry)
                    timesheetEntries [.project] = entries
                }
            case .time:
                var entries: [TimesheetEntry] = []
                for key in EntryKey.allTimeKeys {
                    let timesheetEntry = TimesheetEntry (info: parameter, key: key, value: nil)
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
        timerButton.addTarget(self, action: #selector(timeButtonTapped), for: .touchUpInside)
    }
    
    //MARK:- Update data
    func update(key:EntryKey, value: Any) {
        let dataManager = DataManager.sharedInstance
        guard dataManager.timesheet != nil else {
            return
        }
        
        let section = key.section()
        switch (key) {
        case .activity:
            dataManager.timesheet!.activity = value as? String ?? nil
            timesheetEntries[section]![key.index()].value = dataManager.timesheet!.activity!
        case .buillable:
            dataManager.timesheet!.billable = value as? String ?? nil
            timesheetEntries[section]![key.index()].value = dataManager.timesheet!.billable!
        case .identifier:
            dataManager.timesheet!.projectID = value as? String ?? nil
            timesheetEntries[section]![key.index()].value = dataManager.timesheet!.projectID!
        case .date:
            break
        case .startWorking:
            dataManager.timesheet!.workFrom = value as? Date ?? nil
            timesheetEntries[section]![key.index()].value = (dataManager.timesheet!.workFrom?.simpleHoursFormat())!
        case .lunchBreak:
            dataManager.timesheet!.breakUntil = value as? Date ?? nil
            let lunchBreak = TimeHelper.calculateLunckBreak(start: (dataManager.timesheet!.breakFrom)!, end: (dataManager.timesheet!.breakUntil)!)
            dataManager.timesheet!.lunchBreak = lunchBreak
            let hours = (dataManager.timesheet!.lunchBreak?.hours)!
            let minutes = (dataManager.timesheet!.lunchBreak?.minutes)!
            timesheetEntries[section]![key.index()].value = "\(hours) : \(minutes)"

        case . stopWorking:
            dataManager.timesheet!.workUntil = value as? Date ?? nil
            timesheetEntries[section]![key.index()].value = (dataManager.timesheet!.workUntil?.simpleHoursFormat())!
            dataManager.timesheet!.workedHours = TimeHelper.calculateWorkedHours(start: (dataManager.timesheet!.workFrom)!, end: (dataManager.timesheet!.workUntil)!, lunchBreak: dataManager.timesheet!.lunchBreak!)
        }
        
        timesheetInfoTV.dataSource = self.timesheetEntries
    }
    
    //MARK:- Selectors
    @objc func timeButtonTapped() {
        let dataManager = DataManager.sharedInstance
        guard dataManager.timesheet != nil else {
            return
        }
        
        var key: EntryKey?
        var value: Any?
        switch (timerButton.status)! {
        case .startWorking:
            timerButton.status = .startLunchBreak
            key = .startWorking
            value = Date()
        case .startLunchBreak: // there is No UI update for this action
            dataManager.timesheet!.breakFrom = Date()
            timerButton.status = .stopLunchBreak
            return
        case .stopLunchBreak:
            timerButton.status = .stopWorking
            key = .lunchBreak
            value = Date()
        case .stopWorking:
            timerButton.status = .submit
            key = .stopWorking
            value = Date()
        case .submit:
            preview()
            return
        }
        update(key: key!, value: value!)
    }
    
    @objc func editButtonTapped() {
        editBtn.isSelected = !editBtn.isSelected
        timesheetInfoTV.editMode = editBtn.isSelected
    }
    
    //MARK:- Preview
    func preview() {
        let dataManager = DataManager.sharedInstance
        guard dataManager.timesheet != nil else {
            return
        }
        
        guard dataManager.timesheet!.day != nil, dataManager.timesheet!.projectID != nil, dataManager.timesheet!.activity != nil, dataManager.timesheet!.billable != nil, dataManager.timesheet!.workFrom != nil, dataManager.timesheet!.workUntil != nil, dataManager.timesheet!.workedHours != nil, dataManager.timesheet!.breakFrom != nil, dataManager.timesheet!.breakUntil != nil, dataManager.timesheet!.lunchBreak != nil else {
            return
        }
        let timesheetPreviewVC = TimesheetPreviewViewController()
        self.navigationController?.pushViewController(timesheetPreviewVC, animated: true)
    }
}

extension TimesheetViewController: TimesheetInfoTableViewDelegate {
    func didSelectTimesheetInfo(timesheetInfoTableView: TimesheetInfoTableView, entry: TimesheetEntry) {
        presentPickerView(entry: entry)
    }
}

