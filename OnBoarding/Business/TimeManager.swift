//
//  TimeManager.swift
//  OnBoarding
//
//  Created by mmaalej on 05/10/2017.
//  Copyright © 2017 mmaalej. All rights reserved.
//

import Foundation

class TimeManager {
    
    //MARK:-
    func insert(timesheet: Timesheet, completion: @escaping ((ServerResponse?)->()) ) {
        guard let dic = timesheet.convertToJson() else {
            let failure = ServerStatus.parse(status: .badRequest)
            completion(failure)
            return
        }
        TimeService.submitTimesheet(dic: dic, completion: { response in
            guard response != nil else {
                let failure = ServerStatus.parse(status: .serviceUnavailable)
                completion(failure)
                return
            }
            
            guard let serverStatus = Int(response!) else {
                let failure = ServerStatus.parse(status: .unknown)
                completion(failure)
                return
            }
            let serverResponse = ServerStatus.parse(status: ServerStatus(rawValue: serverStatus)!)
            completion(serverResponse)
            return
        })
    }
    
    //MARK:-
    func SelectLastSubmittedDay(associateID: String, completion: @escaping ((Date?, ServerResponse?)->()) ) {
        TimeService.lastSubmittedDay(associateID: associateID, completion: { response in
            guard response != nil else {
                let failure = ServerResponse(code: .serviceUnavailable, description: "Could not connect to the server")
                completion(nil,failure)
                return
            }
            guard let day = response?.date() else {
                guard let serverStatus = Int(response!) else {
                    let unkonwnResponse = ServerResponse(code: .unknown, description: "Unknown server failure")
                    completion(nil, unkonwnResponse)
                    return
                }
                let response = ServerStatus.parse(status: ServerStatus(rawValue: Int(serverStatus))!)
                completion(nil, response)
                return
            }
            completion(day, nil)
        })
    }
}
