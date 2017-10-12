//
//  timesheetTableViewCell.swift
//  OnBoarding
//
//  Created by mmaalej on 10/10/2017.
//  Copyright © 2017 mmaalej. All rights reserved.
//

import UIKit

class TimeTableViewCell: UITableViewCell, TableViewCellProtocols {
    
    //MARK:- Properties
    static var staticMetrics: CellMetrics = CellMetrics(topAnchor: 8.0, leftAnchor: 10.0, bottomAnchor: 5.0, rightAnchor: 10.0)
    
    static let height: CGFloat = TimesheetContentView.dummy.view.systemLayoutSizeFitting(UILayoutFittingCompressedSize).height + staticMetrics.topAnchor + staticMetrics.bottomAnchor
    
    var cellView: CellViewProtocol = TimesheetContentView()
    
    var entry: TimesheetEntry? {
        didSet {
            (cellView as! TimesheetContentView).entry = entry
        }
    }
    
    //MARK:- Init
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        design()
        layout()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK:- Layout
    func layout() {
        cellView.view.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.addSubview(cellView.view)
        cellView.view.topAnchor.constraint(equalTo:self.topAnchor, constant: metrics.topAnchor).isActive = true
        cellView.view.leftAnchor.constraint(equalTo:self.leftAnchor, constant: metrics.leftAnchor).isActive = true
        cellView.view.rightAnchor.constraint(equalTo:self.rightAnchor, constant: -metrics.rightAnchor).isActive = true
        cellView.view.bottomAnchor.constraint(equalTo:self.bottomAnchor, constant: -metrics.rightAnchor).isActive = true
    }
    
    //MARK:- Style
    func design() {
        self.backgroundColor = UIColor.BgColor
        self.cellView.view.backgroundColor = UIColor.elementBgColor
        self.selectionStyle = .none
    }
}

class TimesheetContentView: UIView, CellViewProtocol {
    
    //MARK:- Properties
    static var dummy: CellViewProtocol = {
        let view  = TimesheetContentView()
        view.entry = TimesheetEntry(info: .time, key: .from, value: " a value")
        return view
    }()
    
    var entry:TimesheetEntry? {
        didSet {
            titleLbl.text = entry?.key.rawValue
            timeLbl.text = entry?.value
        }
    }
    
    let titleLbl: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 13)
        return label
    }()
    
    let timeLbl: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 13)
        return label
    }()
    
    //MARK:- Inits
    override init(frame: CGRect) {
        super.init(frame: frame)
        layout()
        self.layer.cornerRadius = 5.0
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK:- Layout
    func layout() {
        let views: [String: UIView] = ["title": titleLbl, "time": timeLbl]
        
        for (_, view) in views {
            view.translatesAutoresizingMaskIntoConstraints = false
            self.addSubview(view)
        }
        
        var layoutConstraints: [NSLayoutConstraint] = []
        layoutConstraints += NSLayoutConstraint.constraints(withVisualFormat: "H:|-(10)-[title]-(10)-[time(100)]-(10)-|", options: [], metrics: nil, views: views)
        layoutConstraints += NSLayoutConstraint.constraints(withVisualFormat: "V:|-(10)-[title]-(10)-|", options: [], metrics: nil, views: views)
        layoutConstraints += NSLayoutConstraint.constraints(withVisualFormat: "V:|-(10)-[time]-(10)-|", options: [], metrics: nil, views: views)
        NSLayoutConstraint.activate(layoutConstraints)
    }
    
}
