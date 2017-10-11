//
//  ContextView.swift
//  OnBoarding
//
//  Created by mmaalej on 20/09/2017.
//  Copyright © 2017 mmaalej. All rights reserved.
//

import UIKit

enum TimerStatus: String {
    case startWorking = "Start"
    case stopWorking = "Go home!"
    case submit = "Submit"
}

class TimerButton: UIButton {
    
    //MARK:- Properties
    var status: TimerStatus? {
        didSet {
            self.setTitle(status?.rawValue, for: .normal)
        }
    }
    
    //MARK:- Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.titleEdgeInsets = UIEdgeInsets(top: 10.0, left: 10.0, bottom: 10.0, right: 10.0)
        self.titleLabel?.textColor = .white
        self.backgroundColor = UIColor.buttonColor
        self.layer.cornerRadius = 5.0
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
