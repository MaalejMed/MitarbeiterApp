//
//  TimeInterval+.swift
//  OnBoarding
//
//  Created by mmaalej on 21/09/2017.
//  Copyright © 2017 mmaalej. All rights reserved.
//

import Foundation

extension TimeInterval {
    func lunckBreak() -> (hours: Int, minutes: Int) {
        let hours = self / 3600
        let minutes = self.truncatingRemainder(dividingBy: 3600) / 60
        return (hours: Int(hours), minutes: Int(minutes))
    }
    
    func workedHours(lunchBreak: (hours: Int, minutes: Int)) -> (hours: Int, minutes: Int) {
        let totlaHours = Int(self / 3600)
        let totalMinutes = Int(self.truncatingRemainder(dividingBy: 3600) / 60)
        
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
