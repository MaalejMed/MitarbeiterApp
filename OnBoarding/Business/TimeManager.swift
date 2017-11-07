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
    func insert(timesheet: Timesheet, completion: @escaping ((ServerResponse?)->()) ) {
        guard let dic = timesheet.convertToJson() else {
            let failure = ServerStatus.parse(status: .badRequest)
            completion(failure)
            return
        }
        TimeService.submitTimesheet(dic: dic, completion: { response in
            guard response.result.isSuccess == true else {
                let failure = ServerStatus.parse(status: .serviceUnavailable)
                completion(failure)
                return
            }
            
            guard let serverStatus = response.result.value as? Int else {
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
    static func SelectLastSubmittedDay() {
        guard let assIdentifier = DataManager.sharedInstance.associate?.identifier else {
            return
        }
        TimeService.lastSubmittedDay(associateID: assIdentifier, completion: { response in
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
