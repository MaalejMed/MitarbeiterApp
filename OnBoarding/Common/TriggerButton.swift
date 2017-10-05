//
//  Trigger.swift
//  OnBoarding
//
//  Created by mmaalej on 28/09/2017.
//  Copyright © 2017 mmaalej. All rights reserved.
//

import UIKit

enum Status: String {
    case idle
    case loading
}

class TriggerButton: UIButton {
   
    //MARK:- Properties
    let activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.gray)
        return indicator
    }()
    
    var status: Status? {
        didSet {
            didChangeStatus()
        }
    }
    
    var title: String?
    
    //MARK:- Init
    init(status: Status) {
        self.status = status
        super.init(frame: .zero)
        self.titleEdgeInsets = UIEdgeInsets(top: 10.0, left: 10.0, bottom: 10.0, right: 10.0)
        self.titleLabel?.textColor = .white
        self.backgroundColor = UIColor.buttonColor
        self.layer.cornerRadius = 5.0
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK:- Layout
    func layout() {
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(activityIndicator)
        activityIndicator.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        activityIndicator.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
    }
    
    //MARK:- Context
    func didChangeStatus() {
        if  status == .loading {
            title = self.titleLabel?.text
            self.setTitle("", for: .normal)
            presentActivityIndicator()
        } else {
            self.setTitle(title, for: .normal)
            dismissActivityIndicator()
        }
    }
    
    //MARK:- Acitivity indicator
    func presentActivityIndicator() {
        layout()
        activityIndicator.startAnimating()
    }
    
    func dismissActivityIndicator() {
        guard activityIndicator.superview != nil else {
            return
        }
        activityIndicator.stopAnimating()
        activityIndicator.removeFromSuperview()
    }
}
