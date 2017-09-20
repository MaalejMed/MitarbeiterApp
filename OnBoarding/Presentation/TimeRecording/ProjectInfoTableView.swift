//
//  ProjectInfoTableView.swift
//  OnBoarding
//
//  Created by mmaalej on 20/09/2017.
//  Copyright © 2017 mmaalej. All rights reserved.
//

import UIKit

protocol ProjectInfoTableViewDelegate: class {
    func didSelectProjectParamter(projectInfoTableView:ProjectInfoTableView, parameter: ProjectParamter)
}

class ProjectInfoTableView: UIView {
    //MARK:- Properties
    let tableView: UITableView = {
        let tableView = UITableView()
        tableView.isScrollEnabled = false
        return tableView
    }()
    
    var dataSource: [ProjectParamter]? {
        didSet {
            tableView.reloadData()
        }
    }
    
    static let height: CGFloat =  BasicTableViewCell.height * CGFloat(ProjectParamter.allValues.count) + 40
    
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
        let parameter = dataSource![indexPath.row]
        delegate?.didSelectProjectParamter(projectInfoTableView: self, parameter: parameter)
    }
}

extension ProjectInfoTableView: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (dataSource?.count != nil) ?  (dataSource?.count)! : 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: BasicTableViewCell.cellIdentifier) as? BasicTableViewCell
        
        let item = dataSource![indexPath.row]
        cell?.data = (title: item.rawValue, details: "default",  icon: nil)
        return cell!
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Project Info"
    }
}
