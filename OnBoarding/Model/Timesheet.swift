//
//  Timesheet.swift
//  OnBoarding
//
//  Created by mmaalej on 21/09/2017.
//  Copyright © 2017 mmaalej. All rights reserved.
//

import Foundation

struct Timesheet {
    var day: Date?
    var projectID: String?
    var associateID: String?
    var activity: String?
    var billable: String?
    var workFrom: Date?
    var workUntil: Date?
    var workedHours: (hours: Int, minutes: Int)?
    var breakFrom: Date?
    var breakUntil: Date?
    var lunchBreak: (hours: Int, minutes: Int)?
    
    init(associate: String) {
        day = Date()
        projectID = nil
        associateID = associate
        activity = nil
        billable = nil
        workFrom = nil
        workUntil = nil
        workedHours = nil
        breakFrom = nil
        breakUntil = nil
        lunchBreak = nil
    }
    func convertToJson() -> [String: Any] {
        let dic: [String: Any] = [
            "associateID": associateID!,
            "day": day!.simpleDateFormat(),
            "projectID": projectID!,
            "activity": activity!,
            "billable": billable!,
            "startWork": workFrom!.longDateFormat(),
            "endWork": workUntil!.longDateFormat(),
            "workedHours": "\(workedHours!.hours) : \(workedHours!.minutes)",
            "startBreak": breakFrom!.longDateFormat(),
            "endBreak": breakUntil!.longDateFormat(),
            "lunchBreak": "\(lunchBreak!.hours) : \(lunchBreak!.minutes)",
        ]
        return dic
    }
}
