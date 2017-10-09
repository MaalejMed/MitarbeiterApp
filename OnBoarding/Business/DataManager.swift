//
//  DataManager.swift
//  OnBoarding
//
//  Created by mmaalej on 06/10/2017.
//  Copyright © 2017 mmaalej. All rights reserved.
//

import Foundation

class DataManager {
    
    var associate: Associate?
    var timesheet: Timesheet?
    
    static let sharedInstance: DataManager = {
        let instance = DataManager()
        return instance
    }()
    
    func resetTimesheet() {
        self.timesheet = Timesheet(associate: (associate?.identifier)!)
    }
}
