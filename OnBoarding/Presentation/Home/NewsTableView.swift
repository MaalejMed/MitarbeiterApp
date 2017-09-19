//
//  NewsTableView.swift
//  OnBoarding
//
//  Created by mmaalej on 19/09/2017.
//  Copyright © 2017 mmaalej. All rights reserved.
//

import UIKit

protocol NewsTableViewDelegate: class {
    func didScrollNewsTableView()
}

class NewsTableView: UIView {
    
    //MARK:- Properties
    let tableView: UITableView = {
        let tableView = UITableView()
        return tableView
    }()
    
    var dataSource: [Settings]? {
        didSet {
            tableView.reloadData()
        }
    }
    
    weak var delgate: NewsTableViewDelegate?
    
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

extension NewsTableView: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        delgate?.didScrollNewsTableView()
    }
}

extension NewsTableView: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (dataSource?.count != nil) ?  (dataSource?.count)! : 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: BasicTableViewCell.cellIdentifier) as? BasicTableViewCell
        
        let item = dataSource![indexPath.row]
        cell?.data = (title: item.rawValue, icon: item.icon())
        return cell!
    }
}

extension NewsTableView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return ExtendedTableViewCell.height
    }
}
