//
//  TimeManager.swift
//  OnBoarding
//
//  Created by mmaalej on 05/10/2017.
//  Copyright © 2017 mmaalej. All rights reserved.
//

import Foundation

enum HTTPResponse: String {
    case ok = "200"
    case notAcceptable = "406"
}

class TimeManager {
    func submit(timesheet: Timesheet, completion: @escaping ((Failure?)->()) ) {
        let dic = timesheet.convertToJson()
        TimeService.submit(dic: dic, completion: { response in
            guard response != nil else {
                let failure = Failure(code: .networkConnection, description: "Could not connect to the server")
                completion(failure)
                return
            }
            
            guard let res = response as? String, res == HTTPResponse.ok.rawValue else {
                let failure = Failure(code: .parsingIssue, description: "Could not submit timesheet")
                completion(failure)
                return
            }
            completion(nil)
        })
    }
    
    func lastSubmittedDay(associateID: String, completion: @escaping ((Date?, Failure?)->()) ) {
        TimeService.lastSubmittedDay(associateID: associateID, completion: { response in
            guard response != nil else {
                let failure = Failure(code: .networkConnection, description: "Could not connect to the server")
                completion(nil,failure)
                return
            }
            guard let payload = response as? String, let day = payload.date() else {
                let failure = Failure(code: .parsingIssue, description: "Could not get last submitted day")
                completion(nil, failure)
                return
            }
            completion(day, nil)
        })
    }
}
