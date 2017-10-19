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
    let sendBtn =  TriggerButton(frame: .zero)
    let serverResponseView = ServerResponseView(frame: .zero)
    
    //MARK:- Views lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTimesheetInfoTV()
        setupSendButton()
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
        let views: [String: UIView] = ["tableView": timesheetInfoTV, "send": sendBtn]
        for (_, view) in views {
            view.translatesAutoresizingMaskIntoConstraints = false
            self.view.addSubview(view)
        }
        timesheetInfoTV.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        timesheetInfoTV.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        
        sendBtn.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 70).isActive = true
        sendBtn.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -70).isActive = true
        
        timesheetInfoTV.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor).isActive = true
        timesheetInfoTV.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: TimesheetInfoTableView.height).isActive = true
        sendBtn.topAnchor.constraint(equalTo: timesheetInfoTV.bottomAnchor, constant: 10).isActive = true
    }
    
    //MARK:- Setup views
    func setupTimesheetInfoTV() {
        let dataManager = DataManager.sharedInstance
        guard let previewTimesheet = dataManager.timesheet else {
            return
        }
        
        var timesheetEntries: [EntryInfo:[TimesheetEntry]] = [:]
        for info in EntryInfo.allValues {
            var entries: [TimesheetEntry] = []
            switch info {
            case .project:
                for key in EntryKey.allProjectKeys {
                    switch key {
                    case .date:
                        entries.append(TimesheetEntry(info: key.section(), key: key, value: (previewTimesheet.day?.simpleDateFormat())! ))
                    case .identifier:
                        entries.append(TimesheetEntry(info: .project, key: key, value: (previewTimesheet.projectID)! ))
                    case .activity:
                        entries.append(TimesheetEntry(info: .project, key: key, value: (previewTimesheet.activity)! ))
                    case .buillable:
                        entries.append(TimesheetEntry(info: .project, key: key, value: (previewTimesheet.billable)! ))
                    case .from, .until, .lunchBreak: break
                    }
                }
            case .time:
                for key in EntryKey.allTimeKeys {
                    switch key {
                    case .date, .activity, .identifier, .buillable: break
                    case .from:
                        entries.append(TimesheetEntry(info: key.section(), key: key, value: (previewTimesheet.from?.simpleHoursFormat())! ))
                    case .until:
                        entries.append(TimesheetEntry(info: key.section(), key: key, value: (previewTimesheet.until?.simpleHoursFormat())! ))
                    case .lunchBreak:
                        entries.append(TimesheetEntry(info: key.section(), key: key, value: String(previewTimesheet.lunchBreak!)))
                    }
                }
            }
            timesheetEntries[info] = entries
        }
        timesheetInfoTV.dataSource = timesheetEntries
    }
    
    func setupSendButton() {
        sendBtn.status = .idle
        sendBtn.addTarget(self, action: #selector(sendButtonTapped), for: .touchUpInside)
    }

    
    //MARK:- Selectors
    @objc func sendButtonTapped() {
        let dataManager = DataManager.sharedInstance
        guard let submittedTimesheet = dataManager.timesheet else {
            return
        }
        
        sendBtn.status = .loading
        let timeManager = TimeManager()
        timeManager.insert(timesheet: submittedTimesheet, completion: {[weak self] serverResponse in
            guard serverResponse?.code == .success else {
                self?.serverResponseView.present(serverResponse: serverResponse!)
                return
            }
            dataManager.resetTimesheet(completion: { serverResponse in
                guard serverResponse == .success else {
                    return
                }
            })
        })
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0, execute: { [weak self] in
            for vc in (self?.navigationController?.viewControllers)! {
                if  vc.isKind(of: HomeViewController.self){
                    self?.navigationController?.popToViewController(vc, animated: true)
                    return
                }
            }
            self?.sendBtn.status = .idle
        })
    }
}
