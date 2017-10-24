//
//  MessageTableView.swift
//  OnBoarding
//
//  Created by mmaalej on 26/09/2017.
//  Copyright © 2017 mmaalej. All rights reserved.
//

import UIKit

class MessageTableView: UIView {
    
    //MARK:- Properties
    //MARK:- Properties
    let tableView: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = UIColor.BgColor
        tableView.separatorStyle = .none
        return tableView
    }()
    
    var dataSource: [Message]? {
        didSet {
            tableView.reloadData()
        }
    }
    
    //MARK:- Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(ExtendedTableViewCell.self, forCellReuseIdentifier: ExtendedTableViewCell.cellIdentifier)
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

extension MessageTableView: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (dataSource?.count != nil) ?  (dataSource?.count)! : 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ExtendedTableViewCell.cellIdentifier) as? ExtendedTableViewCell
        
        let message = dataSource![indexPath.row]
        cell?.data = (title:message.title , description: message.body, details: message.date?.simpleDateFormat(), icon: UIImage.init(named: "Mail")!)
        cell?.backgroundColor = UIColor.BgColor
        cell?.cellView.view.backgroundColor = UIColor.elementBgColor
        cell?.selectionStyle = .none
        return cell!
    }
}

extension MessageTableView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return ExtendedTableViewCell.height
    }
}
