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
    let contextView = ContextView(context: .send)
    
    var timesheet: Timesheet?
    
    //MARK:- Views lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTimesheetInfoTV()
        setupTimerView()
        layout()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        super.viewWillAppear(animated)
        self.view.backgroundColor = UIColor.BgColor
        self.title = "Preview"
        self.navigationController?.navigationBar.barTintColor = UIColor.navigationBarBgColor
    }
    
    //MARK:- Layout
    func layout() {
        let views: [String: UIView] = ["tableView": timesheetInfoTV, "context": contextView]
        for (_, view) in views {
            view.translatesAutoresizingMaskIntoConstraints = false
            self.view.addSubview(view)
            view.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
            view.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        }
        
        timesheetInfoTV.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor).isActive = true
        timesheetInfoTV.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: TimesheetInfoTableView.height).isActive = true
        contextView.topAnchor.constraint(equalTo: timesheetInfoTV.bottomAnchor, constant: 10).isActive = true
    }
    
    //MARK:- Setup views
    func setupTimesheetInfoTV() {
        var timesheetEntries: [EntryInfo:[TimesheetEntry]] = [:]
        for info in EntryInfo.allValues {
            var entries: [TimesheetEntry] = []
            switch info {
            case .project:
                for key in EntryKey.allProjectKeys {
                    switch key {
                    case .date:
                        entries.append(TimesheetEntry(info: key.section(), key: key, value: (timesheet?.date?.simpleDateFormat())! ))
                    case .identifier:
                        entries.append(TimesheetEntry(info: .project, key: key, value: (timesheet?.projectID)! ))
                    case .activity:
                        entries.append(TimesheetEntry(info: .project, key: key, value: (timesheet?.activity)! ))
                    case .buillable:
                        entries.append(TimesheetEntry(info: .project, key: key, value: (timesheet?.buillable)! ))
                    case .startWorking, .stopWorking, .lunchBreak: break
                    }
                }
            case .time:
                for key in EntryKey.allTimeKeys {
                    switch key {
                    case .date, .activity, .identifier, .buillable: break
                    case .startWorking:
                        entries.append(TimesheetEntry(info: key.section(), key: key, value: (timesheet?.workFrom?.simpleHoursFormat())! ))
                    case .stopWorking:
                        entries.append(TimesheetEntry(info: key.section(), key: key, value: (timesheet?.workUntil?.simpleHoursFormat())! ))
                    case .lunchBreak:
                        let hours = (timesheet?.lunchBreak?.hours)!
                        let minutes = (timesheet?.lunchBreak?.minutes)!
                        entries.append(TimesheetEntry(info: key.section(), key: key, value: "\(hours) : \(minutes)"))
                    }
                }
            }
            timesheetEntries[info] = entries
        }
        timesheetInfoTV.dataSource = timesheetEntries
    }
    
    func setupTimerView() {
        contextView.contextBtnAction = { [weak self] in
            self?.contextView.contextBtn.context = .idle
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0, execute: {
                for vc in (self?.navigationController?.viewControllers)! {
                    if  vc.isKind(of: HomeViewController.self){
                        self?.navigationController?.popToViewController(vc, animated: true)
                        return
                    }
                }
            })
        }
    }
}
