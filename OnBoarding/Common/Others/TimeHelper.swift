//
//  TimeHelper.swift
//  OnBoarding
//
//  Created by mmaalej on 22/09/2017.
//  Copyright © 2017 mmaalej. All rights reserved.
//

import Foundation

class TimeHelper {
    
    static func calculateLunckBreak(start: Date, end: Date) -> (hours: Int, minutes: Int) {
        let diff = end.timeIntervalSince(start)
        let hours = diff / 3600
        let minutes = diff.truncatingRemainder(dividingBy: 3600) / 60
        return (hours: Int(hours), minutes: Int(minutes))
    }
    
    static func calculateWorkedHours(start: Date, end: Date, lunchBreak: (hours: Int, minutes: Int)) -> (hours: Int, minutes: Int) {
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
    
    static func shoudlChange(timeString: String, range: NSRange, newString: String) -> Bool {
        
        guard newString == "" || newString.isNumber else {
            return false
        }
        
        if let indexOfSeperator = timeString.index(of: ":") {
            let timeComponents = timeString.components(separatedBy: ":")
            // validate hours change
            if timeComponents[0].count == 2, range.location <= (indexOfSeperator.encodedOffset), newString != "" {
                return false
            }
            // validate minutes change
            if timeComponents[1].count == 2, range.location > indexOfSeperator.encodedOffset, newString != "" {
                return false
            }
        }
        
        // cannot exceed 5 character2s including :
        if timeString.characters.count > 5 && newString != "" {
            return false
        }
        
        // cannot remove :
        if timeString.characterAtIndex(index: range.location) == ":", newString == "" {
            return false
        }
        return true
    }
}
