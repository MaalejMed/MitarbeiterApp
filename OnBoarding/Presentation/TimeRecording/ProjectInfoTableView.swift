//
//  ProjectInfoTableView.swift
//  OnBoarding
//
//  Created by mmaalej on 20/09/2017.
//  Copyright © 2017 mmaalej. All rights reserved.
//

import UIKit

protocol ProjectInfoTableViewDelegate: class {
    func didSelectProjectParamter(projectInfoTableView:ProjectInfoTableView, parameter: InfoParamter)
}

class ProjectInfoTableView: UIView {
    //MARK:- Properties
    let tableView: UITableView = {
        let tableView = UITableView()
        tableView.isScrollEnabled = false
        return tableView
    }()
    
    var dataSource: [InfoKey : [InfoParamter]]? {
        didSet {
            tableView.reloadData()
        }
    }
    
    static var height: CGFloat {
        var numberOfParams = 0
        let keys = Array(InfoParamter.allValues.keys)
        for key in keys {
            numberOfParams += (InfoParamter.allValues[key]?.count)!
        }
        return BasicTableViewCell.height * CGFloat(numberOfParams) + 40
    }
    
    weak var delegate: ProjectInfoTableViewDelegate?
    
    //MARK:- Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(BasicTableViewCell.self, forCellReuseIdentifier: BasicTableViewCell.cellIdentifier)
        layout()
        tableView.tableFooterView = UIView()
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

extension ProjectInfoTableView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return BasicTableViewCell.height
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let dataSource = self.dataSource else {
            return
        }
        let key = Array(dataSource.keys) [indexPath.section]
        guard key == .project else {
            return
        }
        let params = dataSource[key]
        delegate?.didSelectProjectParamter(projectInfoTableView: self, parameter: params![indexPath.row])
    }
}

extension ProjectInfoTableView: UITableViewDataSource {
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
        let key = Array(dataSource.keys) [section]
        let params = dataSource[key]
        return (params?.count)!
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: BasicTableViewCell.cellIdentifier) as? BasicTableViewCell
        guard let dataSource = self.dataSource else {
            return UITableViewCell()
        }
    
        let key = Array(dataSource.keys) [indexPath.section]
        let params = dataSource[key]
        let item = params![indexPath.row]
        cell?.data = (title: item.rawValue, details: "default",  icon: nil)
        return cell!
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        guard let dataSource = self.dataSource else {
            return ""
        }
        let key = Array(dataSource.keys) [section]
        switch key {
        case .project:
            return "Project info"
        case .time:
            return "Time recording"
        }

    }
}
