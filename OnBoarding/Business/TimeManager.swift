//
//  TimeManager.swift
//  OnBoarding
//
//  Created by mmaalej on 05/10/2017.
//  Copyright © 2017 mmaalej. All rights reserved.
//

import Foundation

class TimeManager: Subject {
    
    // MARK:- Properties
    static var observers: [Observer] = []
    
    //MARK:- Subject
    static func register(observer: Observer) {
        observers.append(observer)
    }
    
    static func deregister(observer: Observer) {
        for (index, ob) in observers.enumerated() {
            if ob.identifier == observer.identifier {
                observers.remove(at: index)
            }
        }
    }
    
    static func notify() {
        for observer in observers {
            observer.update(subject: self)
        }
    }
    
    //MARK:-
    static func insert(timesheet: Timesheet, completion: @escaping ((ServerResponse?)->()) ) {
        guard let dic = timesheet.convertToJson() else {
            return completion(ServerResponse(serverStatus: .badRequest))
        }
        TimeService.submitTimesheet(dic: dic, completion: { response in
            guard response.result.isSuccess == true else {
                return completion(ServerResponse(serverStatus: .serviceUnavailable))
            }
            completion(ServerResponse.init(serverStatus: response.result.value as! String))
            notify()
            return
        })
    }
    
    //MARK:-
    static func SelectLastSubmittedDay(associateID: String) {
        TimeService.lastSubmittedDay(associateID: associateID, completion: { response in
             guard response.result.isSuccess == true else {
                return
            }
            guard let day = response.result.value?.date() else {
                DataManager.sharedInstance.timesheet?.lastSubmittedDay = Date() // timesheet is never submitted
                return
            }
            DataManager.sharedInstance.timesheet?.lastSubmittedDay = day
            notify()
        })
    }
}
