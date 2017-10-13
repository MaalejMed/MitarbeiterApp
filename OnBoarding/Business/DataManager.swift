//
//  DataManager.swift
//  OnBoarding
//
//  Created by mmaalej on 06/10/2017.
//  Copyright © 2017 mmaalej. All rights reserved.
//

import Foundation

class DataManager {
    
    //MARK:- Properties
    var associate: Associate?
    var timesheet: Timesheet?
    
    static let sharedInstance: DataManager = {
        let instance = DataManager()
        return instance
    }()
    
    func resetTimesheet() {
        guard let identifier = associate?.identifier else {
            return
        }
        self.timesheet = Timesheet(associateIdentifier: identifier)
    }
}
