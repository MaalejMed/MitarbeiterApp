//
//  TimeCalculator.swift
//  OnBoarding
//
//  Created by mmaalej on 22/09/2017.
//  Copyright © 2017 mmaalej. All rights reserved.
//

import Foundation

class TimeCalculator {
    static func lunckBreak(start: Date, end: Date) -> (hours: Int, minutes: Int) {
        let diff = end.timeIntervalSince(start)
        let hours = diff / 3600
        let minutes = diff.truncatingRemainder(dividingBy: 3600) / 60
        return (hours: Int(hours), minutes: Int(minutes))
    }
    
    static func workedHours(start: Date, end: Date, lunchBreak: (hours: Int, minutes: Int)) -> (hours: Int, minutes: Int) {
        let diff = end.timeIntervalSince(start)
        let totlaHours = Int(diff / 3600)
        let totalMinutes = Int(diff.truncatingRemainder(dividingBy: 3600) / 60)
        
        var workedHours: (hours: Int, minutes: Int) = (0,0)
        
        if totalMinutes >= lunchBreak.minutes {
            workedHours.minutes = totalMinutes - lunchBreak.minutes
            workedHours.hours = totlaHours - lunchBreak.hours
        } else {
            workedHours.hours = totlaHours - 1
            workedHours.minutes =  60 - (lunchBreak.minutes - totalMinutes)
        }
        return workedHours
    }
    
}
