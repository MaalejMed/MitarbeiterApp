//
//  TimesheetInfoTableView.swift
//  OnBoarding
//
//  Created by mmaalej on 20/09/2017.
//  Copyright © 2017 mmaalej. All rights reserved.
//

import UIKit

protocol TimesheetInfoTableViewDelegate: class {
    func didSelectTimesheetInfo(timesheetInfoTableView: TimesheetInfoTableView, entry: TimesheetEntry)
    func didEditTime(timesheetInfoTableView: TimesheetInfoTableView, dateTime: Date, key: EntryKey)
}

class TimesheetInfoTableView: UIView {
    
    //MARK:- Properties
    let tableView: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = UIColor.BgColor
        tableView.separatorStyle = .none
        return tableView
    }()
    
    var dataSource: [EntryInfo:[TimesheetEntry]]? {
        didSet {
            tableView.reloadData()
        }
    }
    
    var editMode = false {
        didSet {
            tableView.reloadData()
        }
    }
    
    static var height: CGFloat {
        let projectKeys = EntryKey.allProjectKeys.count
        let timeKeys = EntryKey.allTimeKeys.count
        return (BasicTableViewCell.height * CGFloat(projectKeys)) + (TimeTableViewCell.height * CGFloat(timeKeys)) + 60
    }
    
    weak var delegate: TimesheetInfoTableViewDelegate?
    
    //MARK:- Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(BasicTableViewCell.self, forCellReuseIdentifier: BasicTableViewCell.cellIdentifier)
        tableView.register(TimeTableViewCell.self, forCellReuseIdentifier: TimeTableViewCell.cellIdentifier)
        tableView.tableFooterView = UIView()
        layout()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK:- Lyout
    func layout() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(tableView)
        tableView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        tableView.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        tableView.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
    }
}

extension TimesheetInfoTableView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let info = EntryInfo.allValues[indexPath.section]
        switch info {
        case .project:
            return BasicTableViewCell.height
        case .time:
            return TimeTableViewCell.height
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let info = EntryInfo.allValues[indexPath.section]
        switch info {
        case .project:
            let entry = Array(dataSource![info]!)[indexPath.row]
            delegate?.didSelectTimesheetInfo(timesheetInfoTableView: self, entry: entry)
        case .time:
            return
        }
    }
}

extension TimesheetInfoTableView: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return (EntryInfo.allValues.count)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let info = EntryInfo.allValues[section]
        switch info {
        case .project:
            return EntryKey.allProjectKeys.count
        case .time:
            return EntryKey.allTimeKeys.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let info = EntryInfo.allValues[indexPath.section]
        let entry = Array(dataSource![info]!)[indexPath.row]
        switch info {
        case .project:
            let cell = tableView.dequeueReusableCell(withIdentifier: BasicTableViewCell.cellIdentifier) as? BasicTableViewCell
            let value = entry.key == .date ? Date().simpleDateFormat() : entry.value
            cell?.data = (title: entry.key.rawValue, details: value,  icon: nil)
            return cell!
        case .time:
            let cell = tableView.dequeueReusableCell(withIdentifier: TimeTableViewCell.cellIdentifier) as? TimeTableViewCell
            (cell?.cellView as! TimesheetContentView).timesheetContentViewDelegate = self
            cell?.data = (entry: entry, editMode: editMode)
            return cell!
        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let parameter = EntryInfo.allValues[section]
        switch parameter {
        case .project:
            return "Project info"
        case .time:
            return "Time info"
        }
    }
}

extension TimesheetInfoTableView: TimesheetContentViewDelegate {
    func didChangeTime(timesheetContentView: TimesheetContentView, dateTime: Date, key: EntryKey) {
        delegate?.didEditTime(timesheetInfoTableView: self, dateTime: dateTime, key: key)
    }
}

