//
//  TimeManager.swift
//  OnBoarding
//
//  Created by mmaalej on 05/10/2017.
//  Copyright © 2017 mmaalej. All rights reserved.
//

import Foundation

class TimeManager {
    
    //MARK:- Submit timesheet
    func submit(timesheet: Timesheet, completion: @escaping ((ServerResponse?)->()) ) {
        guard let dic = timesheet.convertToJson() else {
            let failure = ServerResponse(code: .badRequest, description: "Data could not be sent")
            completion(failure)
            return
        }
        TimeService.submit(dic: dic, completion: { response in
            guard response != nil else {
                let failure = ServerResponse(code: .unreachableServer, description: "Could not connect to the server")
                completion(failure)
                return
            }
            
            guard let serverStatus = Int(response!) else {
                let unkonwnResponse = ServerResponse(code: .unknown, description: "Unknown server failure")
                completion(unkonwnResponse)
                return
            }
            let serverResponse = ServerStatus.parse(status: serverStatus)
            completion(serverResponse)
            return
        })
    }
    
    //MARK:- Last submitted day
    func lastSubmittedDay(associateID: String, completion: @escaping ((Date?, ServerResponse?)->()) ) {
        TimeService.lastSubmittedDay(associateID: associateID, completion: { response in
            guard response != nil else {
                let failure = ServerResponse(code: .unreachableServer, description: "Could not connect to the server")
                completion(nil,failure)
                return
            }
            guard let payload = response as? String, let day = payload.date() else {
                let failure = ServerResponse(code: .badRequest, description: "Data could not be parsed")
                completion(nil, failure)
                return
            }
            completion(day, nil)
        })
    }
}
