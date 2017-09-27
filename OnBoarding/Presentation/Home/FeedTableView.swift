//
//  FeedTableView.swift
//  OnBoarding
//
//  Created by mmaalej on 19/09/2017.
//  Copyright © 2017 mmaalej. All rights reserved.
//

import UIKit

protocol FeedTableViewDelegate: class {
    func didScrollFeedTableView(feedTableView: FeedTableView)
    func didSelectFeed(feedTableView: FeedTableView, feed: Feed)
}

class FeedTableView: UIView {
    
    //MARK:- Properties
    let tableView: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = UIColor.BgColor
        tableView.separatorStyle = .none
        return tableView
    }()
    
    var dataSource: [Feed]? {
        didSet {
            tableView.reloadData()
        }
    }
    
    weak var delgate: FeedTableViewDelegate?
    
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

extension FeedTableView: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        delgate?.didScrollFeedTableView(feedTableView: self)
    }
}

extension FeedTableView: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (dataSource?.count != nil) ?  (dataSource?.count)! : 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ExtendedTableViewCell.cellIdentifier) as? ExtendedTableViewCell
        
        let feed = dataSource![indexPath.row]
        cell?.data = (title:feed.title , description: feed.description, details: feed.date, icon: UIImage.init(named: "Logo")!)
        cell?.backgroundColor = UIColor.BgColor
        cell?.cellView.view.backgroundColor = UIColor.elementBgColor
        cell?.selectionStyle = .none
        return cell!
    }
}

extension FeedTableView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return ExtendedTableViewCell.height
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let selectedFeed = dataSource?[indexPath.row] else {
            return
        }
        delgate?.didSelectFeed(feedTableView: self, feed: selectedFeed)
    }
}
