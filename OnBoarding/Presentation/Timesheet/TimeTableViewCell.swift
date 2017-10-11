//
//  timesheetTableViewCell.swift
//  OnBoarding
//
//  Created by mmaalej on 10/10/2017.
//  Copyright © 2017 mmaalej. All rights reserved.
//

import UIKit

protocol TimesheetContentViewDelegate: class {
    func didChangeTime(timesheetContentView: TimesheetContentView, dateTime: Date, key: EntryKey)
}

class TimeTableViewCell: UITableViewCell, TableViewCellProtocols {
    
    //MARK:- Properties
    static var staticMetrics: CellMetrics = CellMetrics(topAnchor: 8.0, leftAnchor: 10.0, bottomAnchor: 5.0, rightAnchor: 10.0)
    
    var cellView: CellViewProtocol = TimesheetContentView()
    
    var data: (entry: TimesheetEntry?, editMode: Bool?)? {
        didSet {
            (cellView as! TimesheetContentView).data = data
        }
    }
        
    static let height: CGFloat = TimesheetContentView.dummy.view.systemLayoutSizeFitting(UILayoutFittingCompressedSize).height + staticMetrics.topAnchor + staticMetrics.bottomAnchor
    
    //MARK:- Init
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        styling()
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
    func styling() {
        self.backgroundColor = UIColor.BgColor
        self.cellView.view.backgroundColor = UIColor.elementBgColor
        self.selectionStyle = .none
    }
}

class TimesheetContentView: UIView, CellViewProtocol {
    static var dummy: CellViewProtocol = {
        let view  = TimesheetContentView()
        view.data = (entry: TimesheetEntry(info: .time, key: .from, value: " a value"), editMode: true)
        return view
    }()
    
    var data:(entry:TimesheetEntry?, editMode: Bool?)? {
        didSet {
            titleLbl.text = data?.entry?.key.rawValue
            timeTextField.text = data?.entry?.value
            timeTextField.isEnabled = (data?.editMode)!
            timeTextField.key = data?.entry?.key
            styleTimeTextField()
        }
    }
    
    weak var timesheetContentViewDelegate: TimesheetContentViewDelegate?
    
    let titleLbl: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 13)
        return label
    }()
    
    let timeTextField: TimeTextField = {
        let textfield = TimeTextField()
        textfield.textColor = .black
        textfield.font = UIFont.boldSystemFont(ofSize: 13)
        return textfield
    }()
    
    //MARK:- Layout
    override init(frame: CGRect) {
        super.init(frame: frame)
        timeTextField.timeTextDelegate = self
        layout()
        self.layer.cornerRadius = 5.0
    }
    
    //MARK:- Inits
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK:- Layout
    func layout() {
        let views: [String: UIView] = ["title": titleLbl, "time": timeTextField]
        
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
    
    func styleTimeTextField() {
        guard data?.editMode == true else {
            timeTextField.placeholder = ""
            timeTextField.borderStyle = .none
            timeTextField.layer.borderColor = UIColor.clear.cgColor
            return
        }
        timeTextField.placeholder = "HH:MM"
        timeTextField.borderStyle = .roundedRect
        timeTextField.layer.cornerRadius = 5.0
        timeTextField.layer.borderWidth = 1.0
        timeTextField.layer.borderColor = UIColor.BgColor.cgColor
    }
}

extension TimesheetContentView: TimeTextFieldDelegate {
    func didChangeValue(dateTime: Date, key: EntryKey) {
        timesheetContentViewDelegate?.didChangeTime(timesheetContentView: self, dateTime: dateTime, key: key)
    }
}
