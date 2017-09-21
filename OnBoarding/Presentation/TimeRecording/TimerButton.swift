//
//  TimerButton.swift
//  OnBoarding
//
//  Created by mmaalej on 21/09/2017.
//  Copyright © 2017 mmaalej. All rights reserved.
//

import UIKit

enum status: String {
    case startWorking = "Start"
    case startLunchBreak = "Lunch time"
    case stopLunchBreak = "Back to work"
    case stopWorking = "Go home!"
    case submit = "Submit"
}

class TimerButton: UIButton {
    var status: status?
}
