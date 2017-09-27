//
//  ContextButton.swift
//  OnBoarding
//
//  Created by mmaalej on 21/09/2017.
//  Copyright © 2017 mmaalej. All rights reserved.
//

import UIKit

enum Context: String {
    case idle = ""
    case startWorking = "Start"
    case startLunchBreak = "Lunch time"
    case stopLunchBreak = "Back to work"
    case stopWorking = "Go home!"
    case submit = "Submit"
    case send = "Send"
}

class ContextButton: UIButton {
    
    //MARK:- Properties
    let activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.gray)
        return indicator
    }()
        
    var context: Context? {
        didSet {
            didChangeContext()
        }
    }
    
    //MARK:- Init
    override init(frame: CGRect) {
        super.init(frame: frame)
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
    func didChangeContext() {
        self.setTitle(context?.rawValue, for: .normal)
        let _ = context == .idle ? presentActivityIndicator() : dismissActivityIndicator()
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

