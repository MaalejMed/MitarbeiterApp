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
    
    //MARK:- Setup
    func setup(associate: Associate, completion: @escaping ((ServerResponse?)->()) ) {
        //associate
        DataManager.sharedInstance.associate = associate
        //timesheet submission
        let timeManager = TimeManager()
        timeManager.SelectLastSubmittedDay(associateID: associate.identifier!, completion: {date, failure in
            guard let lastSubmittedDay = date else {
                completion(failure)
                return
            }
            DataManager.sharedInstance.timesheet = Timesheet(associateIdentifier: associate.identifier!)
            DataManager.sharedInstance.timesheet?.lastSubmittedDay = lastSubmittedDay
            completion(nil)
        })
    }
    
    //MARK:- Timesheet
    func updateLastSubmissionDay( completion: @escaping ((ServerResponse?)->()) ) {
        let timeManager = TimeManager()
        timeManager.SelectLastSubmittedDay(associateID: (self.associate?.identifier!)!, completion: {date, failure in
            guard let lastSubmittedDay = date else {
                let failure = ServerResponse.init(code: .badRequest, description: "Operation could not be completed")
                completion(failure)
                return
            }
            DataManager.sharedInstance.timesheet?.lastSubmittedDay = lastSubmittedDay
            let success = ServerResponse.init(code: .success, description: "Done !")
            completion(success)
        })
    }
    
    func resetTimesheet(completion: @escaping ((ServerResponse?)->()) ) {
        guard let identifier = associate?.identifier else {
            let failure = ServerResponse.init(code: .badRequest, description: "Operation could not be completed")
            completion(failure)
            return
        }
        self.timesheet = Timesheet(associateIdentifier: identifier)
        self.updateLastSubmissionDay(completion: { serverResponse in
            completion(serverResponse)
        })
    }
}
