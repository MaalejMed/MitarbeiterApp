//
//  TimesheetPreviewViewController.swift
//  OnBoarding
//
//  Created by mmaalej on 22/09/2017.
//  Copyright © 2017 mmaalej. All rights reserved.
//

import UIKit

class TimesheetPreviewViewController: UIViewController {
    
    //MARK:- Properties
    let timesheetInfoTV = TimesheetInfoTableView(frame: .zero)
    let timerView = TimerView(status: .send)
    
    var timesheet: Timesheet?
    
    //MARK:- Views lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTimesheetInfoTV()
        layout()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        super.viewWillAppear(animated)
        self.view.backgroundColor = .white
        self.title = "Preview"
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
    
    //MARK:- Setup views
    func setupTimesheetInfoTV() {
        var timesheetEntries: [TimesheetEntry] = []
        let allKeys: [TimesheetKey] = TimesheetKey.allProjectKeys + TimesheetKey.allTimeKeys
        for key in allKeys {
            switch key {
            case .date:
                timesheetEntries.append(TimesheetEntry(info:.project, key: key, value: (timesheet?.date?.simpleDateFormat())!))
            case .identifier:
                timesheetEntries.append(TimesheetEntry(info:.project, key: key, value: (timesheet?.projectID)!))
            case .activity:
                timesheetEntries.append(TimesheetEntry(info:.project, key: key, value: (timesheet?.activity)!))
            case .buillable:
                timesheetEntries.append(TimesheetEntry(info:.project, key: key, value: (timesheet?.buillable)!))
            case .startWorking:
                timesheetEntries.append(TimesheetEntry(info:.time, key: key, value: (timesheet?.workFrom?.simpleDateFormat())!))
            case .stopWorking:
                timesheetEntries.append(TimesheetEntry(info:.time, key: key, value: (timesheet?.workUntil?.simpleDateFormat())!))
            case .lunchBreak:
                let hours = (timesheet?.lunchBreak!.hours)!
                let minutes = (timesheet?.lunchBreak!.minutes)!
                timesheetEntries.append(TimesheetEntry(info:.time, key: key, value:  "\(hours) : \(minutes)"))
            }
        }
        timesheetInfoTV.dataSource = timesheetEntries
    }
}

