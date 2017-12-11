//
//  ProfileTableView.swift
//  OnBoarding
//
//  Created by mmaalej on 15/09/2017.
//  Copyright © 2017 mmaalej. All rights reserved.
//

import UIKit

protocol ProfileTableViewProtocol: class {
    func profileTableView (_ profileTableView: ProfileTableView, didSelect setting: Setting)
}

class ProfileTableView: UIView {
    //MARK:- Properties
    let tableView: UITableView = {
       let tableView = UITableView()
        tableView.backgroundColor = UIColor.BgColor
        tableView.separatorStyle = .none
        return tableView
    }()
    
    var dataSource: [Setting]? {
        didSet {
            tableView.reloadData()
        }
    }
    
    weak var profileTableViewDelegate: ProfileTableViewProtocol?
    
    //MARK:- Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(BasicTableViewCell.self, forCellReuseIdentifier: BasicTableViewCell.cellIdentifier)
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

extension ProfileTableView: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (dataSource?.count != nil) ?  (dataSource?.count)! : 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: BasicTableViewCell.cellIdentifier) as? BasicTableViewCell
        
        let item = dataSource![indexPath.row]
        cell?.data = (title: item.rawValue, details: nil, icon: item.icon())
        cell?.backgroundColor = UIColor.BgColor
        cell?.cellView.view.backgroundColor = UIColor.elementBgColor
        cell?.selectionStyle = .none
        return cell!
    }
}

extension ProfileTableView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return BasicTableViewCell.height
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedSetting = dataSource![indexPath.row]
        profileTableViewDelegate?.profileTableView(self, didSelect: selectedSetting)
    }
}
