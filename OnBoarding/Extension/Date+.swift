//
//  Date+.swift
//  OnBoarding
//
//  Created by mmaalej on 21/09/2017.
//  Copyright © 2017 mmaalej. All rights reserved.
//

import Foundation

extension Date {
    func simpleDateFormat () -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        return dateFormatter.string(from: self)
    }
    
    func longDateFormat() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd hh:mm"
        return dateFormatter.string(from: self)
    }
    
    func simpleHoursFormat() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm:ss"
        return dateFormatter.string(from: self)
    }
}
