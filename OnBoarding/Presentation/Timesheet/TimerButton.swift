//
//  TimerButton.swift
//  OnBoarding
//
//  Created by mmaalej on 21/09/2017.
//  Copyright © 2017 mmaalej. All rights reserved.
//

import UIKit

enum Status: String {
    case idle = ""
    case startWorking = "Start"
    case startLunchBreak = "Lunch time"
    case stopLunchBreak = "Back to work"
    case stopWorking = "Go home!"
    case submit = "Submit"
    case send = "Send"
}

class TimerButton: UIButton {
    
    //MARK:- Properties
    var status: Status? {
        didSet {
            self.setTitle(status?.rawValue, for: .normal)
            guard status == .idle else {
                dismissSpinningWheel()
                return
            }
            presentSpinningWheel()
        }
    }
    
    let spinningWheel: UIActivityIndicatorView = {
        let activity = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.gray)
        return activity
    }()
    
    //MARK:- Init
    override init(frame: CGRect) {
        super.init(frame: frame)
       layoutSpinningWheel()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK:- Layout
    func layoutSpinningWheel() {
        spinningWheel.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(spinningWheel)
        spinningWheel.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        spinningWheel.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
    }
    
    //MARK:- Acitivity indicator
    func presentSpinningWheel () {
        layoutSpinningWheel()
        spinningWheel.startAnimating()
    }
    
    func dismissSpinningWheel() {
        guard spinningWheel.superview != nil else {
            return
        }
        spinningWheel.stopAnimating()
        spinningWheel.removeFromSuperview()
    }
}

