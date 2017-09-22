//
//  TimeRecordingDataTableView.swift
//  OnBoarding
//
//  Created by mmaalej on 20/09/2017.
//  Copyright © 2017 mmaalej. All rights reserved.
//

import UIKit

protocol TimeRecordingDataTableViewDelegate: class {
    func didSelectProjectDetail(timesheetDataTableView: TimesheetDataTableView, detail: ProjectVisibleDetail)
}

class TimeRecordingDataTableView: UIView {
    
    //MARK:- Properties
    let tableView: UITableView = {
        let tableView = UITableView()
        tableView.isScrollEnabled = false
        return tableView
    }()
    
    var dataSource: [Parameter : [Any]]? {
        didSet {
            tableView.reloadData()
        }
    }
    
    static var height: CGFloat {
        let projectDetails = ProjectVisibleDetail.allValues.count
        let timeDetails = TimeVisibleDetail.allValues.count
        return BasicTableViewCell.height * CGFloat(projectDetails + timeDetails) + 40
    }
    
    weak var delegate: TimeRecordingDataTableViewDelegate?
    
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

extension TimeRecordingDataTableView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return BasicTableViewCell.height
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let dataSource = self.dataSource else {
            return
        }
        let parameter = Array(dataSource.keys) [indexPath.section]
        guard parameter == .project else {
            return
        }
        let details = dataSource[parameter] as! [ProjectVisibleDetail]
        delegate?.didSelectProjectDetail(timesheetDataTableView: self, detail: details[indexPath.row])
    }
}

extension TimeRecordingDataTableView: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        guard let dataSource = self.dataSource else {
            return 0
        }
        return Array(dataSource.keys).count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let dataSource = self.dataSource else {
            return 0
        }
        let  parameter = Array(dataSource.keys) [section]
        let details = dataSource[parameter]
        return (details?.count)!
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: BasicTableViewCell.cellIdentifier) as? BasicTableViewCell
        
        guard let dataSource = self.dataSource else {
            return UITableViewCell()
        }
    
        let parameter = Array(dataSource.keys) [indexPath.section]
        
        switch parameter {
        case .project:
            let details = dataSource[parameter] as! [ProjectVisibleDetail]
            let detail = details[indexPath.row]
            var detailsDefaulValue = "-"
            if detail == .date {
                detailsDefaulValue = Date().simpleDateFormat()
            }
            cell?.data = (title: detail.rawValue, details: detailsDefaulValue,  icon: nil)
        case .time:
            let details = dataSource[parameter] as! [TimeVisibleDetail]
            let detail = details[indexPath.row]
            cell?.data = (title: detail.rawValue, details: "-",  icon: nil)
        }
        return cell!
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        guard let dataSource = self.dataSource else {
            return ""
        }
        let parameter = Array(dataSource.keys) [section]
        switch parameter {
        case .project:
            return "Project info"
        case .time:
            return "Time recording"
        }
    }
}
