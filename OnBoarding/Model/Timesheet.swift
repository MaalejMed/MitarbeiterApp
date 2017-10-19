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
    var lastSubmittedDay: Date?
    var day: Date?
    var associateID: String?
    var projectID: String?
    var activity: String?
    var billable: String?
    var from: Date?
    var until: Date?
    var workedHours: (hours: Int, minutes: Int)?
    var lunchBreak: Int?
    
    //MARK:- Init
    init(associateIdentifier: String) {
        day = Date()
        projectID = nil
        associateID = associateIdentifier
        activity = nil
        billable = nil
        from = nil
        until = nil
        workedHours = nil
        lunchBreak = nil
    }
    
    //MARK:- update
    mutating func setWorkedHours() {
        workedHours = nil
        guard let start = from, let end = until, let lunch = lunchBreak else {
            return
        }
        
        let diff = end.timeIntervalSince(start)
        guard diff > 0 else {
            return
        }
        let workTotlaHours = Int(diff / 3600)
        let workTotalMinutes = Int(diff.truncatingRemainder(dividingBy: 3600) / 60)
        
        let breakTotalHours = lunch / 60
        let breakTotalMinutes = lunch % 60
        
        
        var work: (hours: Int, minutes: Int) = (0,0)
        if workTotalMinutes >= breakTotalMinutes {
            work.minutes = workTotalMinutes - breakTotalMinutes
            work.hours = workTotlaHours - breakTotalHours
        } else {
            work.hours = workTotlaHours - 1
            work.minutes =  60 - (breakTotalMinutes - workTotalMinutes)
        }
        
        guard work.hours >= 0 && work.minutes >= 0 else {
            return
        }
        workedHours = work
    }
    
    //MARK:- JSON
    func convertToJson() -> [String: Any]? {
        guard associateID != nil, day != nil, projectID != nil, activity != nil, billable != nil, from != nil, until != nil, workedHours != nil, lunchBreak != nil else {
            return nil
        }
        let dic: [String: Any] = [
            "associateID": associateID!,
            "day": day!.simpleDateFormat(),
            "projectID": projectID!,
            "activity": activity!,
            "billable": billable!,
            "workFrom": from!.longDateFormat(),
            "workUntil": until!.longDateFormat(),
            "workedHours": "\(workedHours!.hours) : \(workedHours!.minutes)",
            "lunchBreak": "\(String(describing: lunchBreak!))"
        ]
        return dic
    }
    
    //MARK:- Others
    func missingTimesheets() -> Int? {
        guard let lastDay = lastSubmittedDay  else {
            return nil
        }
        var missingDays: Int = 0
        var currentDay = lastDay.tomorrow
        
        repeat {
            missingDays = !currentDay.isDateWeekend ?  missingDays + 1 : missingDays + 0
            currentDay = currentDay.tomorrow
            
        } while currentDay < Date().yesterday
        return missingDays
    }
}
