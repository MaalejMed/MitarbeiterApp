//
//  DatePickerView.swift
//  OnBoarding
//
//  Created by mmaalej on 12/10/2017.
//  Copyright © 2017 mmaalej. All rights reserved.
//

import UIKit

class DatePickerView: UIView {
    //MARK:- Properties
    let datePicker: UIDatePicker = {
        let datePicker = UIDatePicker()
        datePicker.datePickerMode = .time
        return datePicker
    }()
    
    private let doneBtn: UIButton = {
        let button = UIButton()
        button.setTitle("Done", for: .normal)
        button.titleLabel?.adjustsFontSizeToFitWidth = true
        button.titleEdgeInsets = UIEdgeInsets(top: 10.0, left: 10.0, bottom: 10.0, right: 10.0)
        button.titleLabel?.textColor = .white
        button.backgroundColor = UIColor.buttonColor
        button.layer.cornerRadius = 5.0
        button.addTarget(self, action: #selector(done), for: .touchUpInside)
        return button
    }()
    
    private let cancelBtn: UIButton = {
        let button = UIButton()
        button.setTitle("Cancel", for: .normal)
        button.titleLabel?.adjustsFontSizeToFitWidth = true
        button.sizeToFit()
        button.titleEdgeInsets = UIEdgeInsets(top: 10.0, left: 10.0, bottom: 10.0, right: 10.0)
        button.titleLabel?.textColor = .white
        button.backgroundColor = UIColor.buttonColor
        button.layer.cornerRadius = 5.0
        button.addTarget(self, action: #selector(cancel), for: .touchUpInside)
        return button
    }()
    
    private let lineImgV: UIImageView = {
        let line = UIImageView()
        line.backgroundColor =  .gray
        return line
    }()
    
    var doneButtonAction: ((_ time: Date)->())?
    var cancelButtonAction: (()->())?
    
    //MARK:- Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.BgColor
        layout()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK:- Layout
    func layout() {
        let views:[String: UIView] = ["cancel": cancelBtn, "done": doneBtn, "picker": datePicker, "line": lineImgV]
        for (_, view) in views {
            view.translatesAutoresizingMaskIntoConstraints = false
            self.addSubview(view)
        }
        
        var layoutConstrainsts: [NSLayoutConstraint] = []
        
        layoutConstrainsts += NSLayoutConstraint.constraints(withVisualFormat: "H:|-(10)-[cancel(80)]-(>=100)-[done(80)]-(10)-|", options: [], metrics: nil, views: views)
        layoutConstrainsts += NSLayoutConstraint.constraints(withVisualFormat: "H:|-(0)-[line]-(0)-|", options: [], metrics: nil, views: views)
        layoutConstrainsts += NSLayoutConstraint.constraints(withVisualFormat: "V:|-(10)-[done]", options: [], metrics: nil, views: views)
        layoutConstrainsts += NSLayoutConstraint.constraints(withVisualFormat: "V:|-(10)-[cancel]", options: [], metrics: nil, views: views)
        layoutConstrainsts += NSLayoutConstraint.constraints(withVisualFormat: "V:[cancel]-(10)-[line(2)]-[picker]-(0)-|", options: [], metrics: nil, views: views)
        layoutConstrainsts += NSLayoutConstraint.constraints(withVisualFormat: "H:|-(10)-[picker]-(10)-|", options: [], metrics: nil, views: views)
        NSLayoutConstraint.activate(layoutConstrainsts)
    }
    
    //MARK:- Selectors
    @objc func done() {
        guard let action = doneButtonAction else {
            return
        }
       
        let time = datePicker.date
        action(time)
    }
    
    @objc func cancel() {
        guard let action = cancelButtonAction else {
            return
        }
        action()
    }
}
