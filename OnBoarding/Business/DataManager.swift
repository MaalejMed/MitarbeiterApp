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
    var feeds: [Feed]?
    
    static let sharedInstance: DataManager = {
        let instance = DataManager()
        return instance
    }()
    
    //MARK:- Setup
    func setup(associate: Associate, completion: @escaping ((ServerResponse?)->()) ) {
        //associate
        DataManager.sharedInstance.associate = associate
        
        //timesheet
        DataManager.sharedInstance.timesheet = Timesheet(associateIdentifier: associate.identifier!)
        self.updateLastSubmittedDay(associateID: associate.identifier!, completion: { response in
            
        })

        //feed
        self.updateFeeds(completion: { response in
            
        })
    }

    
    //MARK:- Feed
    func updateFeeds(completion: @escaping ((ServerResponse?)->()) ) {
        let feedManager = FeedManager()
        feedManager.selectFeeds(completion: { failure, feed in
            guard failure == nil, let feedEntries = feed  else {
                return completion(nil)
            }
            DataManager.sharedInstance.feeds = feedEntries
            return completion(nil)
        })
    }
    
    //MARK:- Timesheet
    func updateLastSubmittedDay(associateID: String, completion: @escaping ((ServerResponse?)->()) ) {
        let timeManager = TimeManager()
        timeManager.SelectLastSubmittedDay(associateID: associateID, completion: { date, response in
            guard response == nil, date != nil else {
                completion(response)
                return
            }
            DataManager.sharedInstance.timesheet?.lastSubmittedDay = date
            completion(nil)
        })
    }
    
    func resetTimesheet(completion: @escaping ((ServerResponse?)->()) ) {
        guard let identifier = DataManager.sharedInstance.associate?.identifier else {
            let failure = ServerStatus.parse(status: .unknown)
            completion(failure)
            return
        }
        self.timesheet = Timesheet(associateIdentifier: identifier)
        self.updateLastSubmittedDay(associateID: identifier, completion: { response in
            
        })
    }
}
