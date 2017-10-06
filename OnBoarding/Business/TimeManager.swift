//
//  TimeManager.swift
//  OnBoarding
//
//  Created by mmaalej on 05/10/2017.
//  Copyright © 2017 mmaalej. All rights reserved.
//

import Foundation

class TimeManager {
    func submit(timesheet: Timesheet, completion: @escaping ((Any?)->()) ) {
        let dic = timesheet.convertToJson()
        TimeService.submit(dic: dic, completion: { response in
            completion(response)
        })
    }
}
