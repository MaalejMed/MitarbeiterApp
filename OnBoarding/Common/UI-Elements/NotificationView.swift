//
//  NotificationView.swift
//  OnBoarding
//
//  Created by mmaalej on 13/10/2017.
//  Copyright © 2017 mmaalej. All rights reserved.
//

import UIKit

class NotificationView: UIView {
    
    //MARK:- Properties
    let notifLbl: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = .white
        label.font = UIFont.boldSystemFont(ofSize: 12.0)
        return label
    }()
    
    var value: Int? {
        didSet {
            guard let aValue = value else {
                return
            }
            notifLbl.text = "\(aValue)"
            layout()
        }
    }
    
    //MARK:- Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .red
        self.rounded()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK:- Layout
    func layout() {
        notifLbl.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(notifLbl)
        notifLbl.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 2).isActive = true
        notifLbl.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -2).isActive = true
        notifLbl.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        notifLbl.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
    }
    
    //MARK:- Reset
    func reset() {
        value = nil
        notifLbl.removeFromSuperview()
    }
}
