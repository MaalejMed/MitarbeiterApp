//
//  TimerButton.swift
//  OnBoarding
//
//  Created by mmaalej on 21/09/2017.
//  Copyright © 2017 mmaalej. All rights reserved.
//

import UIKit

enum Status: String {
    case startWorking = "Start"
    case startLunchBreak = "Lunch time"
    case stopLunchBreak = "Back to work"
    case stopWorking = "Go home!"
    case submit = "Submit"
    case send = "Send"
}

class TimerButton: UIButton {
    var status: Status? {
        didSet {
            self.setTitle(status?.rawValue, for: .normal)
        }
    }
}
