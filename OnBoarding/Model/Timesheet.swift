//
//  Timesheet.swift
//  OnBoarding
//
//  Created by mmaalej on 21/09/2017.
//  Copyright © 2017 mmaalej. All rights reserved.
//

import Foundation

struct Timesheet {
    var date: Date?
    var projectID: String?
    var activity: String?
    var buillable: String?
    var workFrom: Date?
    var workUntil: Date?
    var workedHours: (hours: Int, minutes: Int)?
    var breakFrom: Date?
    var breakUntil: Date?
    var lunchBreak: (hours: Int, minutes: Int)?
}
