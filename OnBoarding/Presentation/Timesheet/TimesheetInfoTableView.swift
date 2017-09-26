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
}

class TimesheetInfoTableView: UIView {
    
    //MARK:- Properties
    let tableView: UITableView = {
        let tableView = UITableView()
        tableView.isScrollEnabled = false
        return tableView
    }()
    
    var dataSource: [TimesheetEntry]? {
        didSet {
            tableView.reloadData()
        }
    }
    
    static var height: CGFloat {
        let projectKeys = TimesheetKey.allProjectKeys.count
        let timeKeys = TimesheetKey.allTimeKeys.count
        return BasicTableViewCell.height * CGFloat(projectKeys + timeKeys) + 40
    }
    
    weak var delegate: TimesheetInfoTableViewDelegate?
    
    //MARK:- Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(BasicTableViewCell.self, forCellReuseIdentifier: BasicTableViewCell.cellIdentifier)
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
        return BasicTableViewCell.height
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let dataSource = self.dataSource else {
            return
        }
        
        let timesheetEntry = dataSource[indexPath.row]
        guard timesheetEntry.info == .project else {
            return
        }
        guard timesheetEntry.key != .date else {
            return
        }
        delegate?.didSelectTimesheetInfo(timesheetInfoTableView: self, entry: timesheetEntry)
    }
}

extension TimesheetInfoTableView: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return TimesheetInfo.allValues.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let info = TimesheetInfo.allValues[section]
        switch info {
        case .project:
            return TimesheetKey.allProjectKeys.count
        case .time:
            return TimesheetKey.allTimeKeys.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: BasicTableViewCell.cellIdentifier) as? BasicTableViewCell
        
        guard let dataSource = self.dataSource else {
            return UITableViewCell()
        }
        
        let info = TimesheetInfo.allValues[indexPath.section]
        let index = info.startIndex() + indexPath.row
        let timesheeEntry = dataSource[index]
        
        if  timesheeEntry.key == .date {
            cell?.data = (title: timesheeEntry.key.rawValue, details: Date().simpleDateFormat(),  icon: nil)
        } else {
            cell?.data = (title: timesheeEntry.key.rawValue, details: timesheeEntry.value,  icon: nil)
        }
        cell?.selectionStyle = .none
        return cell!
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let parameter = TimesheetInfo.allValues[section]
        switch parameter {
        case .project:
            return "Project info"
        case .time:
            return "Time info"
        }
    }
}

