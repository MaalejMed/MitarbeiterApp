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
    let dataPickerView = DataPickerView(frame: .zero)
    let datePickerView = DatePickerView(frame: .zero)
    var timesheetEntries: [EntryInfo: [TimesheetEntry]] = [:]
    
    lazy var previewBtn: UIButton = {
        let button = UIButton.init(type: .custom)
        button.setTitle("Preview", for: .normal)
        button.titleLabel?.textAlignment = .right
        button.frame.size = CGSize(width: 70.0, height: 40.0)
        button.addTarget(self, action: #selector(previewButtonTapped), for: .touchUpInside)
        return button
    }()
    
    //MARK:- Views lifecycles
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTimesheetInfoTV()
        setupPreviewButton()
        layout()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.view.backgroundColor = UIColor.BgColor
        self.title = "Time"
        self.navigationController?.navigationBar.tintColor = UIColor.white
        self.navigationController?.navigationBar.barTintColor = UIColor.navBarBgColor
    }
    
    //MARK:- Layout
    func layout() {
        let views: [String: UIView] = ["tableView": timesheetInfoTV]
        for (_, view) in views {
            view.translatesAutoresizingMaskIntoConstraints = false
            self.view.addSubview(view)
        }
        
        timesheetInfoTV.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        timesheetInfoTV.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        timesheetInfoTV.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor).isActive = true
        timesheetInfoTV.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: TimesheetInfoTableView.height).isActive = true
    }
    
    func layout(picker: UIView) {
        picker.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(picker)
        picker.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        picker.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        picker.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        picker.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: -200).isActive = true
    }
    
    //MARK:- Setup views
    func setupPreviewButton() {
        let button = UIBarButtonItem(customView: previewBtn)
        self.navigationItem.rightBarButtonItem = button
    }
    
    func setupPicker(entryKey: EntryKey) {
        var dataSource: [String] = []
        switch entryKey {
        case .identifier:
            dataSource = ["000001", "000002", "000003", "000004"]
            setupDataPickerView(dataSource: dataSource, key: entryKey)
        case .activity:
            dataSource = ["Activity 1", "Activity 2", "Activity 3", "Activity 4"]
            setupDataPickerView(dataSource: dataSource, key: entryKey)
        case .buillable:
            dataSource = ["Yes", "No"]
            setupDataPickerView(dataSource: dataSource, key: entryKey)
        case .lunchBreak:
            dataSource = ["1", "2", "3", "4","5", "6", "7", "8", "9", "10",
                          "11", "12", "13", "14","15", "16", "17", "18", "19", "20",
                          "21", "22", "23", "24","25", "26", "27", "28", "29", "30"
                         ]
            setupDataPickerView(dataSource: dataSource, key: entryKey)
        case .from, .until:
            setupDatePickerView(key: entryKey)
        case .date:
            break
        }
    }
    
    private func setupDataPickerView(dataSource: [String], key: EntryKey) {
        dataPickerView.dataSource = dataSource
        dataPickerView.titleLbl.text = "Select " + key.rawValue
        //Done button
        dataPickerView.doneButtonAction = { [weak self] (newValue: String) in
            self?.update(key: key, value: newValue)
            self?.dismiss(picker: self?.dataPickerView)
        }
        
        //Cancel
        dataPickerView.cancelButtonAction = { [weak self] in
            self?.dismiss(picker: self?.dataPickerView)
        }
    }
    
    func setupDatePickerView(key: EntryKey) {
        datePickerView.titleLbl.text = "Select " + key.rawValue
        datePickerView.datePicker.datePickerMode = .time
        
        //Done button
        datePickerView.doneButtonAction = { [weak self] (newValue: Date) in
            self?.update(key: key, value: newValue)
            self?.dismiss(picker: self?.datePickerView)
        }
        
        //Cancel
        datePickerView.cancelButtonAction = { [weak self] in
            self?.dismiss(picker: self?.datePickerView)
        }
    }
    
    func setupTimesheetInfoTV() {
        for parameter in EntryInfo.allValues {
            switch parameter {
            case .project:
                var entries: [TimesheetEntry] = []
                for key in EntryKey.allProjectKeys {
                    let value = (key == .date) ? DataManager.sharedInstance.timesheet?.day: nil
                    let timesheetEntry = TimesheetEntry (info: parameter, key: key, value: value?.simpleDateFormat())
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
        timesheetInfoTV.timesheetInfoTableViewDelegate = self
    }
    
    //MARK:- Selectors
    @objc func previewButtonTapped() {
        let dataManager = DataManager.sharedInstance
        guard dataManager.timesheet != nil else {
            return
        }
        
        guard dataManager.timesheet!.day != nil, dataManager.timesheet!.projectID != nil, dataManager.timesheet!.activity != nil, dataManager.timesheet!.billable != nil, dataManager.timesheet!.from != nil, dataManager.timesheet!.until != nil, dataManager.timesheet!.workedHours != nil, dataManager.timesheet!.lunchBreak != nil else {
            return
        }
        let timesheetPreviewVC = TimesheetPreviewViewController()
        self.navigationController?.pushViewController(timesheetPreviewVC, animated: true)
    }
    
    //MARK:- Picker
    func presentPickerFor(entryKey: EntryKey) {
        setupPicker(entryKey: entryKey)
        switch entryKey {
        case .activity, .buillable, .identifier, .lunchBreak :
            layout(picker: dataPickerView)
        case .date, .from, .until:
            layout(picker: datePickerView)
        }
    }
    
    func dismiss(picker: UIView?) {
        guard let aPicker = picker else {
            return
        }
        aPicker.removeFromSuperview()
    }

    //MARK:- Update timesheetEntries (view)
    func update(key:EntryKey, value: Any) {
        guard DataManager.sharedInstance.timesheet != nil else {
            return
        }
        
        guard  DataManager.sharedInstance.timesheet!.update(attribute: key, value: value) == true else {
            return
        }
        
        let section = key.section()
        switch (key) {
        case .activity:
            timesheetEntries[section]![key.index()].value = DataManager.sharedInstance.timesheet!.activity!
        case .buillable:
            timesheetEntries[section]![key.index()].value = DataManager.sharedInstance.timesheet!.billable!
        case .identifier:
            timesheetEntries[section]![key.index()].value = DataManager.sharedInstance.timesheet!.projectID!
        case .date:
            timesheetEntries[section]![key.index()].value = (DataManager.sharedInstance.timesheet!.day?.simpleDateFormat())!
        case .from:
            timesheetEntries[section]![key.index()].value = (DataManager.sharedInstance.timesheet!.from?.simpleHoursFormat())!
        case . until:
            timesheetEntries[section]![key.index()].value = (DataManager.sharedInstance.timesheet!.until?.simpleHoursFormat())!
        case .lunchBreak:
            timesheetEntries[section]![key.index()].value = String(describing: DataManager.sharedInstance.timesheet!.lunchBreak!)
        }
        timesheetInfoTV.dataSource = self.timesheetEntries
    }
}

extension TimesheetViewController: TimesheetInfoTableViewDelegate {
    func didSelectTimesheetInfo(timesheetInfoTableView: TimesheetInfoTableView, entry: TimesheetEntry) {
        
        guard entry.key != .date else {
            return
        }
        
        guard DataManager.sharedInstance.timesheet?.canSubmit() == true else {
            return
        }
    
        presentPickerFor(entryKey: entry.key)
    }
}
