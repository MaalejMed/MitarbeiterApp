//
//  Timesheet.swift
//  OnBoarding
//
//  Created by mmaalej on 21/09/2017.
//  Copyright © 2017 mmaalej. All rights reserved.
//

import Foundation

struct Timesheet {
    
    //MARK:- Properties
    var day: Date?
    var associateID: String?
    var projectID: String?
    var activity: String?
    var billable: String?
    var from: Date?
    var until: Date?
    var workedHours: (hours: Int, minutes: Int)?
    var lunchBreak: (hours: Int, minutes: Int)?
    
    //MARK:- Init
    init(associate: String) {
        day = Date()
        projectID = nil
        associateID = associate
        activity = nil
        billable = nil
        from = nil
        until = nil
        workedHours = nil
        lunchBreak = nil
    }
    
    //MARK:- update
    
    //MARK:- JSON
    func convertToJson() -> [String: Any] {
        let dic: [String: Any] = [
            "associateID": associateID!,
            "day": day!.simpleDateFormat(),
            "projectID": projectID!,
            "activity": activity!,
            "billable": billable!,
            "from": from!.longDateFormat(),
            "until": until!.longDateFormat(),
            "workedHours": "\(workedHours!.hours) : \(workedHours!.minutes)",
            "lunchBreak": "\(lunchBreak!.hours) : \(lunchBreak!.minutes)",
        ]
        return dic
    }
}
