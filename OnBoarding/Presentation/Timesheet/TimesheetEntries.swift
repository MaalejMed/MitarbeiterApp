//
//  TimesheetEntries.swift
//  OnBoarding
//
//  Created by mmaalej on 05/10/2017.
//  Copyright © 2017 mmaalej. All rights reserved.
//

import Foundation

struct TimesheetEntry: Equatable {
    var info: EntryInfo
    var key: EntryKey
    var value: String?
    
    static func ==(lhs: TimesheetEntry, rhs: TimesheetEntry) -> Bool {
        return lhs.key == rhs.key
    }
}

enum EntryInfo: String {
    case project = "project"
    case time = "time"
    static let allValues = [project, time]
}

enum EntryKey: String {
    case date = "Date"
    case identifier = "Project ID"
    case activity = "Activity"
    case buillable = "Buillable"
    case startWorking = "From"
    case stopWorking = "Until"
    case lunchBreak = "Lunch break"
    
    static let allProjectKeys = [date, identifier, activity, buillable]
    static let allTimeKeys = [startWorking, stopWorking, lunchBreak]
    
    func section() -> EntryInfo {
        switch self {
        case .date, .identifier, .activity, .buillable: return EntryInfo.allValues[0]
        case .startWorking, .stopWorking, .lunchBreak: return EntryInfo.allValues[1]
        }
    }
    
    func index() -> Int {
        let section = self.section()
        switch section {
        case .project:
            return EntryKey.allProjectKeys.index(of: self)!
        case .time:
            return EntryKey.allTimeKeys.index(of: self)!
        }
    }
}
