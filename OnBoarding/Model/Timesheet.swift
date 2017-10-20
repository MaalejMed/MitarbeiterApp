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
    var associateID: String?
    var projectID: String?
    var activity: String?
    var billable: String?
    var from: Date?
    var until: Date?
    var workedHours: (hours: Int, minutes: Int)?
    var lunchBreak: Int?
    var day: Date?
    var lastSubmittedDay: Date? {
        didSet {
            day = nextDayToSubmit()
        }
    }
    
    //MARK:- Init
    init(associateIdentifier: String) {
        associateID = associateIdentifier
    }
    
    //MARK:- Update
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
    
    mutating func update(attribute: EntryKey, value: Any) -> Bool {
        switch attribute {
        case .activity:
            guard let act = value as? String else {
                return false
            }
            activity =  act
            return true
        case .buillable:
            guard let bill = value as? String else {
                return false
            }
            billable = bill
            return true
        case .identifier:
            guard let proID = value as? String else {
                return false
            }
            projectID = proID
            return true
        case .date:
            guard let aDay = value as? Date else {
                return false
            }
            day = aDay
            return true
        case .from:
            guard let fromTime = value as? Date else {
                return false
            }
            from = fromTime
            self.setWorkedHours()
            return true
        case . until:
            guard let toTime = value as? Date else {
                return false
            }
            until = toTime
            self.setWorkedHours()
            return true
        case .lunchBreak:
            guard let breakTimeString = value as? String, let breakTime = Int(breakTimeString) else {
                return false
            }
            lunchBreak = breakTime
            self.setWorkedHours()
            return true
        }
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
    
    func canSubmit() -> Bool {
        guard lastSubmittedDay != nil else {
            return true
        }
        guard let currentDay = self.day, currentDay < Date() else {
            return false
        }
        let canSubmitDay = (currentDay <= Date()) ?  true :  false
        return canSubmitDay
    }
    
    func missingTimesheets() -> Int? {
        guard var lastDay = lastSubmittedDay  else {
            return nil
        }
        var missingDays = 0
        lastDay = lastDay.tomorrow
        
        while lastDay < Date().yesterday {
            missingDays = !lastDay.isDateWeekend ?  missingDays + 1 : missingDays + 0
            lastDay = lastDay.tomorrow
        }
        return missingDays
    }
    
    func nextDayToSubmit() -> Date? {
        guard let lastDay = lastSubmittedDay  else {
            return nil
        }
        var nextDay = lastDay
        repeat {
            nextDay = nextDay.tomorrow
        }while nextDay.isDateWeekend == true
        return nextDay
    }
}
