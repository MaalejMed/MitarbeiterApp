//
//  Date+.swift
//  OnBoarding
//
//  Created by mmaalej on 21/09/2017.
//  Copyright © 2017 mmaalej. All rights reserved.
//

import Foundation

struct MyCalender {
    static let iso8061 = Calendar.init(identifier: .iso8601)
}

extension Date {
    var isDateWeekend: Bool {
        return MyCalender.iso8061.isDateInWeekend(self)
    }
    
    var tomorrow: Date {
        return MyCalender.iso8061.date(byAdding: .day, value: 1, to: self)!
    }
    
    var yesterday: Date {
        return MyCalender.iso8061.date(byAdding: .day, value: -1, to: self)!
    }
    
    func simpleDateFormat () -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        return dateFormatter.string(from: self)
    }
    
    func longDateFormat() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd hh:mm:ss"
        return dateFormatter.string(from: self)
    }
    
    func simpleHoursFormat() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        return dateFormatter.string(from: self)
    }
}
