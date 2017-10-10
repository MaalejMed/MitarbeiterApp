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
        return BasicTableViewCell.height * CGFloat(projectKeys + timeKeys) + 60
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
        let info = EntryInfo.allValues[indexPath.section]
        let entry = Array(dataSource![info]!)[indexPath.row]
        guard entry.info == .project,  entry.key != .date else {
            return
        }
        
        
        
        delegate?.didSelectTimesheetInfo(timesheetInfoTableView: self, entry: entry)
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
        let cell = tableView.dequeueReusableCell(withIdentifier: BasicTableViewCell.cellIdentifier) as? BasicTableViewCell
        let info = EntryInfo.allValues[indexPath.section]
        let entry = Array(dataSource![info]!)[indexPath.row]
        let value = entry.key == .date ? Date().simpleDateFormat() : entry.value
        
        var isEditableCell = false
        if editMode {
            isEditableCell = (entry.key == .startWorking ||  entry.key == .stopWorking || entry.key == .lunchBreak) ? true :  false
        }
      
        cell?.data = (title: entry.key.rawValue, details: value, isEditable: isEditableCell,  icon: nil)
        cell?.backgroundColor = UIColor.BgColor
        cell?.cellView.view.backgroundColor = UIColor.elementBgColor
        cell?.selectionStyle = .none
        return cell!
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

